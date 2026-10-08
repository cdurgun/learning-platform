#!/usr/bin/env python3
"""LearnForgeX canlı site kontrolü -- yalnızca okur, hiçbir şeyi değiştirmez.

    python3 .claude/skills/deploy-check/check_deploy.py            # şimdi kontrol et
    python3 .claude/skills/deploy-check/check_deploy.py --wait     # önce deployment'ın bitmesini bekle
    python3 .claude/skills/deploy-check/check_deploy.py --base http://localhost:8080 --no-github

--wait      origin/main'in son commit'i için Railway deployment'ı "success" olana kadar bekler
            (en fazla --timeout saniye). Railway durumu GitHub deployment kayıtlarına yazar.
--base      kontrol edilecek site (varsayılan: canlı site)
--no-github GitHub deployment kaydına bakma (yerel bir sunucuyu kontrol ederken)

Çıkış kodu: bir kontrol başarısızsa 1, deployment beklenirken zaman aşımı olursa 2.
"""
import argparse
import json
import random
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
LIVE = "https://www.learnforgex.com"
REPO = "cdurgun/learning-platform"
SITEMAP_SAMPLE = 12


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


def deployment_state():
    """origin/main'in son commit'i için (sha, durum). Kayıt yoksa durum None."""
    head = git("rev-parse", "origin/main")
    found = gh(f"repos/{REPO}/deployments?sha={head}&per_page=1", ".[0].id")
    if not found or found == "null":
        return head, None
    return head, gh(f"repos/{REPO}/deployments/{found}/statuses?per_page=1", ".[0].state")


def wait_for_deployment(timeout):
    started = time.time()
    last = "?"
    while time.time() - started < timeout:
        head, state = deployment_state()
        if state != last:
            print(f"  deployment {head[:7]}: {state or 'henüz başlamadı'}")
            last = state
        if state == "success":
            return True
        if state in ("failure", "error"):
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


def run_checks(base, report):
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
    urls = re.findall(r"<loc>(.*?)</loc>", body.decode("utf-8", "replace"))
    courses = [u for u in urls if "/courses/" in u]
    report.check(status == 200 and len(urls) >= 300, f"sitemap {len(urls)} adres içeriyor", str(status))
    report.check(len(courses) >= 14, f"kurs sayfaları sitemap'te ({len(courses)})")
    report.check(all(u.startswith(base + "/") for u in urls), "tüm adresler bu siteye ait",
                 next((u for u in urls if not u.startswith(base + "/")), ""))
    sample = random.sample(urls, min(SITEMAP_SAMPLE, len(urls)))
    broken = [u for u in sample if fetch(u)[0] != 200]
    report.check(not broken, f"sitemap'ten rastgele {len(sample)} adres açılıyor", ", ".join(broken))

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

    if not args.no_github:
        print("Deployment")
        if args.wait and not wait_for_deployment(args.timeout):
            head, state = deployment_state()
            print(f"  [HATA ] {head[:7]} için deployment tamamlanmadı (durum: {state or 'hiç başlamadı'}).")
            if state is None:
                print("          Railway bu commit'i görmedi: servis ayarlarında bağlı branch `main` mi,\n"
                      "          otomatik deploy açık mı? Gerekirse panelden elle deploy başlat.")
            return 2
        head, state = deployment_state()
        local = git("rev-parse", "HEAD")
        if local != head:
            print(f"  [BİLGİ] yerel HEAD ({local[:7]}) henüz push edilmemiş; canlıda beklenen {head[:7]}")
        if state == "success":
            print(f"  [TAMAM] {head[:7]} yayında")
        else:
            print(f"  [BİLGİ] {head[:7]} için deployment durumu: {state or 'kayıt yok'} -- aşağıdaki kontroller "
                  f"önceki sürümü ölçüyor olabilir (--wait ile bekletilebilir)")

    report = Report()
    run_checks(base, report)
    print(f"\n{report.failed} hata, {report.notes} bilgi notu -- {base}")
    return 1 if report.failed else 0


if __name__ == "__main__":
    sys.exit(main())
