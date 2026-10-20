#!/usr/bin/env python3
"""LearnForgeX canlı site kontrolü -- yalnızca okur, hiçbir şeyi değiştirmez.

    python3 .claude/skills/deploy-check/check_deploy.py            # şimdi kontrol et
    python3 .claude/skills/deploy-check/check_deploy.py --wait     # önce deployment'ın bitmesini bekle
    python3 .claude/skills/deploy-check/check_deploy.py --base http://localhost:8080 --no-github

--wait      origin/main'in son commit'i için Railway deployment'ı SUCCESS olana kadar bekler
            (en fazla --timeout saniye). Durum `railway deployment list`'ten okunur (salt okunur,
            oturum açmış ve bu projeye bağlı bir Railway CLI gerekir); GitHub'ın deployment
            kaydı yalnızca tanılama bilgisidir, Railway onu her zaman güncellemiyor.
--base      kontrol edilecek site (varsayılan: canlı site)
--no-github deployment kayıtlarına (Railway, GitHub) bakma (yerel bir sunucuyu kontrol ederken)

"Beklenen Çıktı" bölümü, sayfalardaki çıktı panellerini repodaki examples/**/*.out dosyalarıyla
karşılaştırır. Canlıya bakarken bu dosyalar yerel HEAD'den (`git show`) okunur ve Railway'in canlıda
sunduğu commit kesin olarak bu commit olmalı; değilse ya da Railway okunamıyorsa bölüm çalıştırılmaz
ve bir HATA olarak sayılır (yanlış commit'e karşı ölçüp yanıltıcı sonuç vermemek için).
--no-github ile yerel bir sunucuya bakarken çalışma ağacındaki dosyalar kullanılır.

Çıkış kodu: bir kontrol başarısızsa 1, deployment beklenirken zaman aşımı olursa 2.
"""
import argparse
import html as html_module
import json
import random
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
LIVE = "https://www.learnforgex.com"
REPO = "cdurgun/learning-platform"
SITEMAP_SAMPLE = 12
AUTHOR = "Cemalettin Durgun"
ISO_DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
OUTPUT_LABELS = {"en": "Expected Output", "tr": "Beklenen Çıktı"}
OUTPUT_PANEL = re.compile(r'<figure class="code-output"><figcaption class="code-output-label">(.*?)</figcaption>'
                          r'<pre class="code-output-body"><samp>(.*?)</samp></pre></figure>', re.S)
JAVA_EMBED = re.compile(r"\{\{(\w+)\.java\}\}")
EXAMPLES_DIR = "src/main/resources/examples"
CONTENT_DIR = "src/main/resources/content"


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *args, **kwargs):
        return None


def fetch(url, headers=None, follow=True, timeout=40):
    """(durum, başlıklar, gövde). Yönlendirme izlenmiyorsa 3xx yanıtı olduğu gibi döner."""
    request = urllib.request.Request(url, headers={"User-Agent": "learnforgex-deploy-check", **(headers or {})})
    opener = urllib.request.build_opener() if follow else urllib.request.build_opener(NoRedirect)
    try:
        with opener.open(request, timeout=timeout) as response:
            return response.status, {k.lower(): v for k, v in response.headers.items()}, response.read()
    except urllib.error.HTTPError as error:
        return error.code, {k.lower(): v for k, v in error.headers.items()}, error.read()
    except (urllib.error.URLError, TimeoutError) as error:
        return 0, {}, str(error).encode()


def gh(path, query):
    result = subprocess.run(["gh", "api", path, "--jq", query], capture_output=True, text=True, timeout=30)
    return result.stdout.strip() if result.returncode == 0 else None


def git(*args):
    return subprocess.run(["git", "-C", str(ROOT), *args], capture_output=True, text=True).stdout.strip()


# Deployment durumunun birincil kaynağı Railway'in kendisi (`railway deployment list`). GitHub'ın
# deployment kaydını Railway yazar ama her zaman güncellemez (2026-10-20: Railway SUCCESS iken
# kayıt `in_progress`'te kaldı); o kayıt yalnızca tanılama bilgisidir.
RAILWAY_SERVICE = "learning-platform"
RAILWAY_ENVIRONMENT = "production"
# Railway durumu -> bu script'in durumları. Listede olmayan her durum (COMPLETED, SLEEPING, ileride
# eklenecek bir ad ...) "unknown" olur ve hiçbir zaman başarı sayılmaz.
RAILWAY_STATES = {
    "SUCCESS": "success",
    "FAILED": "failure", "CRASHED": "failure",
    "SKIPPED": "skipped",
    "REMOVED": "removed", "REMOVING": "removed",
    "INITIALIZING": "in_progress", "WAITING": "in_progress", "QUEUED": "in_progress",
    "BUILDING": "in_progress", "DEPLOYING": "in_progress", "NEEDS_APPROVAL": "in_progress",
}
TERMINAL_STATES = ("success", "failure", "skipped", "removed")


def railway_deployments():
    """Bu servisin Railway deployment'ları, en yeni önce: (liste, None) ya da (None, sebep). CLI,
    bağlı projeyi dizinden bulduğu için repo kökünden çalıştırılır; servis ve ortam açıkça verilir.
    Çıktı beklenen biçimde değilse başarı varsayılmaz."""
    command = ["railway", "deployment", "list", "--json", "--limit", "20",
               "--service", RAILWAY_SERVICE, "--environment", RAILWAY_ENVIRONMENT]
    try:
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=30)
    except (OSError, subprocess.TimeoutExpired) as error:
        return None, f"railway CLI çalıştırılamadı ({type(error).__name__})"
    if result.returncode != 0:
        first = (result.stderr or result.stdout).strip().splitlines()
        return None, f"railway CLI hata verdi ({first[0] if first else result.returncode})"
    try:
        rows = json.loads(result.stdout)
        if not isinstance(rows, list):
            raise TypeError("liste değil")
        for row in rows:
            if not (isinstance(row["id"], str) and isinstance(row["status"], str)
                    and isinstance(row["meta"], dict)):
                raise TypeError("eksik alan")
        rows.sort(key=lambda row: datetime.fromisoformat(row["createdAt"].replace("Z", "+00:00")), reverse=True)
    except (ValueError, KeyError, TypeError, AttributeError) as error:
        return None, f"railway CLI çıktısı okunamadı ({type(error).__name__})"
    return rows, None


def belongs_to(row, sha):
    """Kayıt bu repodaki bu commit'in deployment'ı mı? Commit'i olmayan (Postgres gibi) ya da başka
    repodan gelen kayıtlar asla eşleşmez."""
    return bool(sha) and row["meta"].get("commitHash") == sha and row["meta"].get("repo") == REPO


def deployment_state():
    """origin/main'in son commit'i için (sha, durum, ayrıntı). Durum: RAILWAY_STATES'in değerlerinden
    biri, "unknown", kayıt yoksa None, Railway okunamazsa "unreadable" (ayrıntı = sebep).
    Aynı commit'in birden fazla deployment'ı varsa en yenisi geçerlidir."""
    head = git("rev-parse", "origin/main")
    rows, problem = railway_deployments()
    if rows is None:
        return head, "unreadable", problem
    mine = [row for row in rows if belongs_to(row, head)]
    if not mine:
        return head, None, None
    return head, RAILWAY_STATES.get(mine[0]["status"], "unknown"), f"{mine[0]['status']}, {mine[0]['id'][:8]}"


def live_deployment():
    """Railway'in şu an sunduğu commit: (sha, None) ya da (None, sebep). Kesin değilse bilinmiyor
    sayılır: servisin EN YENİ deployment'ı SUCCESS olmalı, tek SUCCESS kaydı olmalı ve bu repodan bir
    commit'e ait olmalı. Daha yeni bir başarısız/atlanmış/süren deployment ya da aynı anda iki SUCCESS
    (geçişteki kısa çakışma) varsa eski bir başarı canlı sürüm diye kabul edilmez."""
    rows, problem = railway_deployments()
    if rows is None:
        return None, problem
    if not rows:
        return None, "Railway'de bu servisin deployment kaydı yok"
    newest = rows[0]
    if newest["status"] != "SUCCESS":
        return None, f"en yeni deployment {newest['id'][:8]} durumu {newest['status']}, SUCCESS değil"
    successes = [row for row in rows if row["status"] == "SUCCESS"]
    if len(successes) != 1:
        return None, f"{len(successes)} SUCCESS kaydı var, canlı sürüm belirsiz"
    if not belongs_to(newest, newest["meta"].get("commitHash")):
        return None, f"en yeni deployment {newest['id'][:8]} bu repodaki bir commit'e ait değil"
    return newest["meta"]["commitHash"], None


def github_state(sha):
    """Yalnızca tanılama: Railway'in GitHub deployment kaydına en son yazdığı durum (yoksa None)."""
    found = gh(f"repos/{REPO}/deployments?sha={sha}&per_page=1", ".[0].id")
    if not found or found == "null":
        return None
    return gh(f"repos/{REPO}/deployments/{found}/statuses?per_page=1", ".[0].state")


def describe_state(state, detail):
    if state is None:
        return "henüz başlamadı"
    if state == "unreadable":
        return f"Railway okunamadı: {detail}"
    return f"{state} ({detail})"


def wait_for_deployment(timeout):
    started = time.time()
    last = "?"
    while time.time() - started < timeout:
        head, state, detail = deployment_state()
        label = describe_state(state, detail)
        if label != last:
            print(f"  deployment {head[:7]}: {label}")
            last = label
        if state == "success":
            return True
        if state in TERMINAL_STATES:
            return False
        time.sleep(15)
    return False


class Report:
    def __init__(self):
        self.failed = 0
        self.notes = 0

    def check(self, ok, label, detail=""):
        self.failed += 0 if ok else 1
        print(f"  [{'TAMAM' if ok else 'HATA '}] {label}" + (f" -- {detail}" if detail and not ok else ""))
        return ok

    def note(self, label):
        self.notes += 1
        print(f"  [BİLGİ] {label}")


def json_ld(html):
    return [json.loads(block) for block in re.findall(r'<script type="application/ld\+json">(.*?)</script>', html, re.S)]


def check_author_and_dates(base, report, lesson_html, sitemap_xml):
    """Yazar satırı, JSON-LD ve sitemap'in AYNI güncellenme tarihini gösterdiğini doğrular.

    Tarihin doğru olup olmadığını bilemez (o, veritabanındaki updated_at'tir); yalnızca üç yerin
    birbiriyle tutarlı olduğuna ve <lastmod>'un yalnızca ders adreslerinde bulunduğuna bakar.
    datePublished bilinçli olarak yayınlanmaz, burada da aranmaz.
    """
    print("Yazar ve güncellenme tarihi")
    byline = (re.search(r'<p class="topic-byline[^"]*">(.*?)</p>', lesson_html, re.S) or [None, ""])[1]
    shown = re.search(r'<time datetime="([^"]*)">\s*([^<]+?)\s*</time>', byline)
    page_date = shown.group(1) if shown else None
    visible = re.sub(r"\s+", " ", re.sub(r"<[^>]+>", " ", byline)).strip()
    report.check('href="/en/about"' in byline and AUTHOR in byline and "Last updated:" in visible
                 and bool(page_date) and bool(ISO_DATE.match(page_date)),
                 "ders sayfasında yazar bağlantısı ve son güncelleme tarihi", visible or "yazar satırı yok")

    try:
        resource = next((b for b in json_ld(lesson_html) if b.get("@type") == "LearningResource"), {})
    except ValueError:
        resource = {}
    author = resource.get("author") or {}
    modified = resource.get("dateModified")
    report.check(author.get("@type") == "Person" and author.get("name") == AUTHOR
                 and author.get("url") == base + "/en/about"
                 and isinstance(modified, str) and bool(ISO_DATE.match(modified)) and modified == page_date,
                 "yapılandırılmış veride yazar ve dateModified (sayfadaki tarihle aynı)",
                 f"author={author or '-'} dateModified={modified} sayfa={page_date}")

    # Sunucu ile bu makinenin günü farklı olabilir: "gelecekte değil" kontrolünde bir gün pay.
    latest = time.strftime("%Y-%m-%d", time.gmtime(time.time() + 2 * 86400))
    wrong = []
    lesson_lastmod = None
    for block in re.findall(r"<url>(.*?)</url>", sitemap_xml, re.S):
        loc = (re.search(r"<loc>(.*?)</loc>", block) or [None, ""])[1]
        lastmods = re.findall(r"<lastmod>(.*?)</lastmod>", block)
        if "/topics/" in loc:
            if len(lastmods) != 1 or not ISO_DATE.match(lastmods[0]) or lastmods[0] > latest:
                wrong.append(loc)
            if loc == base + "/en/topics/enum" and lastmods:
                lesson_lastmod = lastmods[0]
        elif lastmods:
            wrong.append(loc)
    topics = len(re.findall(r"<loc>[^<]*/topics/[^<]*</loc>", sitemap_xml))
    report.check(topics > 0 and not wrong, f"sitemap'te yalnızca ders adresleri <lastmod> taşıyor ({topics} ders adresi)",
                 f"{len(wrong)} uyumsuz adres, ör. {', '.join(wrong[:3])}")
    report.check(bool(page_date) and lesson_lastmod == page_date, "sitemap <lastmod> ile sayfadaki tarih aynı",
                 f"sitemap={lesson_lastmod} sayfa={page_date}")


def repo_text(path, commit):
    """Bir repo dosyasının içeriği: commit verilirse o commit'teki hâli, yoksa çalışma ağacı."""
    if commit:
        result = subprocess.run(["git", "-C", str(ROOT), "show", f"{commit}:{path}"], capture_output=True)
        return result.stdout.decode("utf-8") if result.returncode == 0 else None
    file = ROOT / path
    return file.read_text(encoding="utf-8") if file.is_file() else None


def expected_panels(commit):
    """{slug: {dil: [<samp> metni, ...]}} -- her ders sayfasında, sırasıyla, hangi çıktı panelinin
    olması gerektiği. Bir .out, gömüldüğü her yerde bir panel üretir; boş .out panel üretmez."""
    if commit:
        listed = git("ls-tree", "-r", "--name-only", commit, "--", EXAMPLES_DIR).splitlines()
    else:
        listed = [str(p.relative_to(ROOT)) for p in (ROOT / EXAMPLES_DIR).rglob("*.out")]
    outputs = {}
    for path in listed:
        if path.endswith(".out"):
            slug, name = Path(path).parent.name, Path(path).stem
            text = repo_text(path, commit)
            body = text[:-1] if text.endswith("\n") else text
            if body:
                # Panel metni: .out'tan tek son satır sonu düşer, CommonMark kod bloğunu yine \n ile kapatır.
                outputs.setdefault(slug, {})[name] = body + "\n"
    expected = {}
    for slug, names in sorted(outputs.items()):
        for lang in OUTPUT_LABELS:
            markdown = repo_text(f"{CONTENT_DIR}/{lang}/{slug}.md", commit) or ""
            expected.setdefault(slug, {})[lang] = [names[n] for n in JAVA_EMBED.findall(markdown) if n in names]
    return expected


def page_without_outputs(commit, with_outputs):
    """Java örneği gömen ama hiç .out'u olmayan ilk ders -- panel ÇIKMAMASI gereken sayfa."""
    for path in sorted(git("ls-tree", "-r", "--name-only", commit or "HEAD", "--", f"{CONTENT_DIR}/en").splitlines()):
        slug = Path(path).stem
        if slug not in with_outputs and JAVA_EMBED.search(repo_text(path, commit) or ""):
            return slug
    return None


def check_expected_outputs(base, report, commit, unusable_reason=None):
    print("Beklenen Çıktı")
    if unusable_reason:
        report.check(False, "Beklenen Çıktı kontrolleri çalıştırılmadı", unusable_reason)
        return
    expected = expected_panels(commit)
    report.check(bool(expected), f"repoda yayında olması gereken çıktı paneli var ({len(expected)} ders)")
    for slug, by_lang in expected.items():
        for lang, samps in by_lang.items():
            path = f"/{lang}/topics/{slug}"
            status, _, body = fetch(base + path)
            page = body.decode("utf-8", "replace")
            panels = OUTPUT_PANEL.findall(page)
            problems = []
            if status != 200:
                problems.append(f"HTTP {status}")
            shown = [html_module.unescape(text) for _, text in panels]
            if len(shown) != len(samps):
                problems.append(f"{len(shown)} panel bulundu, {len(samps)} bekleniyordu")
            else:
                differing = [i + 1 for i, (a, b) in enumerate(zip(shown, samps)) if a != b]
                if differing:
                    problems.append("metni .out ile aynı olmayan panel(ler): " + ", ".join(map(str, differing)))
            if any(label != OUTPUT_LABELS[lang] for label, _ in panels):
                problems.append("etiket bu dilde değil: " + ", ".join(sorted({label for label, _ in panels})))
            if page.count('</code></pre>\n<figure class="code-output">') != len(panels):
                problems.append("panel bir kod bloğunun hemen ardında değil")
            if re.search(r"<code[^>]*>(?:(?!</code>).)*<figure class=\"code-output\"", page, re.S):
                problems.append("panel bir <code> içinde (highlight.js'e girer)")
            report.check(not problems, f"{path}: {len(samps)} çıktı paneli, metin .out ile birebir", "; ".join(problems))
    plain = page_without_outputs(commit, expected)
    if plain:
        status, _, body = fetch(f"{base}/en/topics/{plain}")
        report.check(status == 200 and 'class="code-output"' not in body.decode("utf-8", "replace"),
                     f"/en/topics/{plain}: .out'u olmayan derste panel yok", str(status))


def run_checks(base, report, output_commit=None, output_problem=None):
    host = base.split("://", 1)[1]

    print("Temel sayfalar")
    status, headers, _ = fetch(base + "/", follow=False)
    report.check(status == 302 and headers.get("location", "").endswith("/en"), "/ İngilizce anasayfaya yönleniyor",
                 f"{status} {headers.get('location')}")
    for path in ("/en", "/tr", "/en/about", "/en/contact", "/en/privacy", "/en/terms", "/robots.txt"):
        status, _, _ = fetch(base + path)
        report.check(status == 200, f"{path} açılıyor", str(status))
    status, headers, _ = fetch(base + "/en/sayfa-yok", headers={"Accept": "text/html"})
    report.check(status == 404 and "text/html" in headers.get("content-type", ""), "bilinmeyen adres HTML 404 sayfası veriyor",
                 f"{status} {headers.get('content-type')}")

    print("Ders sayfası")
    status, _, body = fetch(base + "/en/topics/enum")
    html = body.decode("utf-8", "replace")
    title = (re.search(r"<title>(.*?)</title>", html, re.S) or [None, ""])[1]
    report.check(status == 200, "/en/topics/enum açılıyor", str(status))
    report.check(bool(title) and "translation." not in title and "${" not in title, "başlık gerçek metin", title)
    report.check(len(re.findall(r"<h1[ >]", html)) == 1, "tek <h1>", str(len(re.findall(r"<h1[ >]", html))))
    report.check(f'rel="canonical" href="{base}/en/topics/enum"' in re.sub(r"\s+", " ", html), "canonical kendi adresi")
    try:
        types = [block["@type"] for block in json_ld(html)]
        report.check({"LearningResource", "BreadcrumbList"} <= set(types), "yapılandırılmış veri geçerli ve tam", str(types))
    except (ValueError, KeyError) as error:
        report.check(False, "yapılandırılmış veri geçerli JSON", str(error))

    lesson_html = html

    print("Erişim kuralı")
    status, _, body = fetch(base + "/en/topics/what-is-docker")
    html = body.decode("utf-8", "replace")
    report.check(status == 200, "Java dışı ders girişsiz açılıyor", str(status))
    report.check('class="quiz-question' not in html, "Java dışı derste quiz soruları girişsiz görünmüyor")
    status, headers, _ = fetch(base + "/en/quiz/spring-core", follow=False)
    location = headers.get("location", "")
    report.check(status == 302 and location.endswith("/en/login"), "Java dışı Quiz Area girişe yönleniyor", f"{status} {location}")
    if base.startswith("https://"):
        report.check(location.startswith("https://"), "giriş yönlendirmesi https ile dönüyor", location)

    print("Sitemap")
    status, _, body = fetch(base + "/sitemap.xml")
    sitemap_xml = body.decode("utf-8", "replace")
    urls = re.findall(r"<loc>(.*?)</loc>", sitemap_xml)
    courses = [u for u in urls if "/courses/" in u]
    report.check(status == 200 and len(urls) >= 300, f"sitemap {len(urls)} adres içeriyor", str(status))
    report.check(len(courses) >= 14, f"kurs sayfaları sitemap'te ({len(courses)})")
    report.check(all(u.startswith(base + "/") for u in urls), "tüm adresler bu siteye ait",
                 next((u for u in urls if not u.startswith(base + "/")), ""))
    sample = random.sample(urls, min(SITEMAP_SAMPLE, len(urls)))
    broken = [u for u in sample if fetch(u)[0] != 200]
    report.check(not broken, f"sitemap'ten rastgele {len(sample)} adres açılıyor", ", ".join(broken))

    check_author_and_dates(base, report, lesson_html, sitemap_xml)

    print("Performans ve arama motoru başlıkları")
    status, headers, body = fetch(base + "/en", headers={"Accept-Encoding": "gzip"})
    report.check(headers.get("content-encoding") == "gzip", "yanıtlar sıkıştırılıyor", str(headers.get("content-encoding")))
    _, _, plain = fetch(base + "/en")
    css = re.search(r'href="(/css/custom-[0-9a-f]{32}\.css)"', plain.decode("utf-8", "replace"))
    if report.check(bool(css), "CSS bağlantısı içerik hash'i taşıyor"):
        _, headers, _ = fetch(base + css.group(1))
        report.check("max-age=31536000" in headers.get("cache-control", ""), "statik dosyalar uzun süre önbellekleniyor",
                     str(headers.get("cache-control")))
    status, headers, _ = fetch(base + "/en/topics/enum/pdf")
    report.check(status == 200 and headers.get("x-robots-tag") == "noindex", "PDF indexlemeye kapalı",
                 f"{status} {headers.get('x-robots-tag')}")
    started = time.time()
    fetch(base + "/en/topics/enum")
    elapsed = time.time() - started
    report.check(elapsed < 3, f"ders sayfası {elapsed:.1f} saniyede yanıt veriyor")

    check_expected_outputs(base, report, output_commit, output_problem)

    print("Kayıt formu")
    _, _, body = fetch(base + "/en/register")
    report.check('id="termsAccepted"' in body.decode("utf-8", "replace"), "onay kutusu görünüyor")

    if host.startswith("www."):
        bare = base.replace("://www.", "://", 1)
        status, headers, _ = fetch(bare + "/", follow=False)
        target = headers.get("location", "")
        if not (status in (301, 308) and "://www." in target):
            report.note(f"www'siz adres www'ye kalıcı yönlenmiyor ({status} {target or '-'}) -- Cloudflare'daki 'Apex to WWW' Redirect Rule'unu kontrol et")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--base", default=LIVE)
    parser.add_argument("--wait", action="store_true")
    parser.add_argument("--timeout", type=int, default=900)
    parser.add_argument("--no-github", action="store_true")
    args = parser.parse_args()
    base = args.base.rstrip("/")

    report = Report()
    if not args.no_github:
        print("Deployment")
        if args.wait and not wait_for_deployment(args.timeout):
            head, state, detail = deployment_state()
            print(f"  [HATA ] {head[:7]} için deployment tamamlanmadı ({describe_state(state, detail)}).")
            if state is None:
                print("          Railway bu commit'i görmedi: servis ayarlarında bağlı branch `main` mi,\n"
                      "          otomatik deploy açık mı? Gerekirse panelden elle deploy başlat.")
            elif state == "skipped":
                print("          Railway deploy'u atladı: Wait for CI açıkken CI başarısız ya da iptal olmuş,\n"
                      "          veya 2 saat içinde bitmemiş olabilir. GitHub Actions sonucuna bak.")
            return 2
        head, state, detail = deployment_state()
        local = git("rev-parse", "HEAD")
        if local != head:
            report.note(f"yerel HEAD ({local[:7]}) henüz push edilmemiş; canlıda beklenen {head[:7]}")
        if state == "success":
            print(f"  [TAMAM] {head[:7]} yayında (Railway {detail})")
            github = github_state(head)
            if github != "success":
                report.note(f"GitHub deployment kaydı '{github or 'yok ya da okunamadı'}' gösteriyor, Railway "
                            f"SUCCESS -- karar Railway'e göre verildi")
        else:
            report.note(f"{head[:7]} için Railway durumu: {describe_state(state, detail)} -- aşağıdaki kontroller "
                        f"önceki sürümü ölçüyor olabilir (--wait ile bekletilebilir)")

    # Çıktı panelleri yerel repodaki dosyalarla karşılaştırılır: canlıya bakarken yalnızca canlıdaki
    # commit yerel HEAD ile aynıysa anlamlıdır. Canlı commit Railway'den okunur; kesin değilse bölüm
    # çalıştırılmaz (GitHub'daki bir "success" kaydı tek başına yetmez).
    output_commit, output_problem = None, None
    if args.no_github:
        print("  [BİLGİ] Beklenen Çıktı: çalışma ağacındaki .out ve ders dosyalarıyla karşılaştırılıyor")
    else:
        live_sha, problem = live_deployment()
        local = git("rev-parse", "HEAD")
        if not live_sha:
            output_problem = f"canlı sürüm Railway'den doğrulanamadı: {problem}"
        elif live_sha != local:
            output_problem = f"canlıdaki commit {live_sha[:7]}, yerel HEAD {local[:7]} -- aynı commit değil"
        else:
            output_commit = local

    run_checks(base, report, output_commit, output_problem)
    print(f"\n{report.failed} hata, {report.notes} bilgi notu -- {base}")
    return 1 if report.failed else 0


if __name__ == "__main__":
    sys.exit(main())
