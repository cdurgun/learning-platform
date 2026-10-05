#!/usr/bin/env python3
"""LearnForgeX içerik denetimi -- YALNIZCA RAPORLAR, hiçbir dosyayı/DB satırını değiştirmez.

Kullanım:
    python3 .claude/skills/content-check/check_content.py [seçenekler]

    --slug SLUG      yalnızca bu konu(lar) (virgülle ayrılabilir)
    --only KONTROL   yalnızca bu kontrol(ler): dosya,embed,baslik,atif,markdown,migration,seo
    --all            her kontrolde tüm bulguları yaz (varsayılan: kontrol başına ilk 15)
    --report DOSYA   tam raporu (tüm bulgular) bu markdown dosyasına da yaz
    --no-db          veritabanı gerektiren kontrolleri atla

Önem dereceleri:
    HATA   kesin sorun (sayfada/derlemede gerçekten yanlış sonuç verir)
    OLASI  sezgisel kontrol -- yanlış alarm olabilir, gözle doğrulanmalı
    BİLGİ  kural ihlali değil, bilmekte fayda olan durum

Veritabanı: varsayılan olarak yerel dev container'ı okunur (salt-okunur SELECT'ler).
Farklı bir bağlantı için CONTENT_CHECK_PSQL ortam değişkenine psql komut önekini verin,
ör. CONTENT_CHECK_PSQL="psql -h localhost -p 5433 -U learning -d learning".
"""
import argparse
import difflib
import os
import re
import shlex
import subprocess
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RES = ROOT / "src/main/resources"
CONTENT = RES / "content"
EXAMPLES = RES / "examples"
MIGRATIONS = RES / "db/migration"
LANGS = ("tr", "en")
DEFAULT_PSQL = "docker exec learning-platform-db psql -U learning -d learning"

# MarkdownService.EXAMPLE_PLACEHOLDER ile birebir aynı desen.
EMBED = re.compile(r"\{\{(\w+)\.(\w+)}}")
ANY_DOUBLE_BRACE = re.compile(r"\{\{[^{}\n]*}}")
FENCE = re.compile(r"^\s*(```|~~~)")
HEADING = re.compile(r"^(#{1,6})\s+(.*?)\s*$")
QUOTED = re.compile(r'"([^"]{2,160})"')
# Quiz soru metinlerinde bölüm adı hem tek hem çift tırnakla yazılıyor; arkasından
# "bölümü/bölümüne" ya da "section" gelmesi atıf olduğunu gösterir. Tek tırnaklı biçimde
# ad kendi içinde kesme işareti taşıyabildiği için ("Agent'lar") çift tırnak ayrı desendir.
QUIZ_SECTION_REFS = (
    re.compile(r"'([^'\n]{3,120})'\s*(?:bölüm\w*|section\b)", re.I),
    re.compile(r'"([^"\n]{3,120})"\s*(?:bölüm\w*|section\b)', re.I),
)
REF_AFTER = re.compile(r"^[\w'’]*\s*\(?(bölüm\w*|başlıklı|section\b)", re.I)
REF_BEFORE = re.compile(r"(bkz\.?|see(\s+the)?|section|bölümündeki)\s*\(?$", re.I)
ORDERED_LIST_ITEM = re.compile(r"^\s*\d+[.)]\s")
NUMBERED_REF = re.compile(r"\b(Bölüm|Section)\s+\d+\b|\b\d+\.\s*bölüm(de|ünde|ü)?\b")
TABLE_SEPARATOR = re.compile(r"^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?\s*$")
CALLOUT_START = re.compile(r"^>\s*(💡|⚠️|⚠)\s*(\S+)?")
MIGRATION_NAME = re.compile(r"^V(\d+)__[A-Za-z0-9_.\-]+\.sql$")
PROJECT_PHRASE = re.compile(r"this project|bu proje", re.I)
# TR başlıkta bunlardan biri tam kelime olarak geçiyorsa başlık çevrilmemiş bir İngilizce
# ifade OLABİLİR (teknik terimler -- "git stash list", "Constructor Injection" -- eşleşmez).
# Tek başına yeterli olanlar ("What Are Hooks?") ve yalnızca ikisi birlikte sayılanlar: tek bir
# "for"/"on"/"in" çoğu zaman bir anahtar kelime ya da terimdir ("for Loop", "ON CONFLICT").
STRONG_ENGLISH_WORDS = {
    "what", "why", "how", "when", "where", "which", "who", "is", "are", "does", "the",
    "and", "of", "from", "our", "your", "this", "that", "into",
}
WEAK_ENGLISH_WORDS = {"a", "an", "or", "to", "with", "without", "in", "on", "for", "it", "its", "by", "at", "as", "do"}
ALLOWED_ENGLISH_HEADINGS = {"Best Practices"}
SEO_TITLE_MAX = 60
SEO_DESCRIPTION_MAX = 160
SEVERITIES = ("HATA", "OLASI", "BİLGİ")
CHECKS = {
    "dosya": "İçerik dosyası <-> veritabanı eşleşmesi",
    "embed": "{{Dosya.ext}} gömmeleri <-> örnek dosyalar <-> code_example",
    "baslik": "Başlıklar (TR'de çevrilmemiş başlık, H1 <-> DB başlığı)",
    "atif": "Bölüm/ders atıfları",
    "markdown": "Markdown render sorunları",
    "migration": "Migration dosyaları",
    "seo": "SEO başlık ve açıklamaları",
}


class Findings:
    def __init__(self):
        self.items = []

    def add(self, check, severity, path, line, message):
        rel = str(path.relative_to(ROOT)) if isinstance(path, Path) else path
        self.items.append((check, severity, rel, line, message))


def norm(text):
    return re.sub(r"\s+", " ", text).strip()


def clean_quote(text):
    """Tırnak içi metni başlıkla karşılaştırmaya hazırlar: blockquote satır devamındaki ">"
    işaretini ve İngilizce yazımda tırnağın İÇİNE alınan son virgül/noktayı atar."""
    text = re.sub(r"\n\s*>\s?", " ", text)
    return norm(text)


def same_modulo_quotes(text):
    """Başlığın kendi içindeki çift tırnak, atıfta zorunlu olarak tek tırnakla yazılır."""
    return text.replace('"', "'").replace("’", "'")


def loose(text):
    """Büyük/küçük harf, noktalama ve backtick farklarını yok sayan karşılaştırma anahtarı."""
    return re.sub(r"[^\w]+", " ", text.replace("`", "").lower()).strip()


def read_lines(path):
    return path.read_text(encoding="utf-8").split("\n")


def fence_mask(lines):
    """Her satır için: kod bloğunun (fence satırları dahil) içinde mi."""
    mask, inside = [], False
    for line in lines:
        if FENCE.match(line):
            mask.append(True)
            inside = not inside
        else:
            mask.append(inside)
    return mask, inside  # inside=True kalırsa kapanmamış fence var


class Markdown:
    def __init__(self, path, lang):
        self.path, self.lang, self.slug = path, lang, path.stem
        self.lines = read_lines(path)
        self.in_fence, self.unclosed_fence = fence_mask(self.lines)
        self.headings = []  # (level, text, line_no)
        for i, line in enumerate(self.lines):
            if not self.in_fence[i]:
                m = HEADING.match(line)
                if m:
                    self.headings.append((len(m.group(1)), m.group(2), i + 1))

    def heading_texts(self, level=None):
        return [t for (lv, t, _) in self.headings if level is None or lv == level]

    def embeds(self):
        """(ad, uzantı, satır) -- MarkdownService ham metnin TAMAMINDA arar, fence dahil."""
        out = []
        for i, line in enumerate(self.lines):
            for m in EMBED.finditer(line):
                out.append((m.group(1), m.group(2), i + 1))
        return out

    def prose_paragraphs(self):
        """Kod blokları dışındaki paragraflar: (başlangıç satırı, metin)."""
        start, buf = None, []
        for i, line in enumerate(self.lines):
            if self.in_fence[i] or not line.strip():
                if buf:
                    yield start, "\n".join(buf)
                start, buf = None, []
            else:
                if start is None:
                    start = i + 1
                buf.append(line)
        if buf:
            yield start, "\n".join(buf)


class Database:
    def __init__(self, enabled):
        self.cmd = shlex.split(os.environ.get("CONTENT_CHECK_PSQL", DEFAULT_PSQL))
        self.available = False
        self.error = None
        if enabled:
            try:
                self.query("select 1")
                self.available = True
            except Exception as e:  # noqa: BLE001 -- her hata "DB yok" demek
                self.error = str(e).strip().split("\n")[0][:200]

    def query(self, sql):
        result = subprocess.run(self.cmd + ["-At", "-F", "\x1f", "-R", "\x1e", "-c", sql],
                                capture_output=True, text=True, timeout=60)
        if result.returncode != 0:
            raise RuntimeError(result.stderr or "psql başarısız")
        out = result.stdout.rstrip("\n")
        return [row.split("\x1f") for row in out.split("\x1e")] if out else []


def load_markdown(slugs):
    docs = {}
    for lang in LANGS:
        for path in sorted((CONTENT / lang).glob("*.md")):
            if slugs and path.stem not in slugs:
                continue
            docs[(lang, path.stem)] = Markdown(path, lang)
    return docs


# --------------------------------------------------------------------------- kontroller

def check_files(docs, db, f, slugs):
    all_slugs = {s for (_, s) in docs}
    for slug in sorted(all_slugs):
        present = [lang for lang in LANGS if (lang, slug) in docs]
        if len(present) == 1:
            f.add("dosya", "OLASI", docs[(present[0], slug)].path, None,
                  f"yalnızca '{present[0]}' dosyası var, diğer dilde karşılığı yok")
    if not db.available:
        return
    rows = db.query("select t.slug, tt.language, tt.published from topic_translation tt "
                    "join topic t on t.id = tt.topic_id")
    known = {r[0] for r in rows}
    for slug, lang, published in rows:
        if slugs and slug not in slugs:
            continue
        if published == "t" and (lang, slug) not in docs:
            f.add("dosya", "HATA", f"src/main/resources/content/{lang}/{slug}.md", None,
                  "çeviri DB'de yayında ama içerik dosyası yok -- sayfa 'içerik mevcut değil' gösterir")
    for (lang, slug), doc in docs.items():
        if slug not in known:
            f.add("dosya", "OLASI", doc.path, None,
                  "bu slug'a sahip bir topic DB'de yok (migration eksik ya da dev DB güncel değil)")


def check_embeds(docs, db, f, slugs):
    embedded = defaultdict(set)  # slug -> {"Ad.ext"}
    for (lang, slug), doc in docs.items():
        for name, ext, line in doc.embeds():
            embedded[slug].add(f"{name}.{ext}")
            if not (EXAMPLES / slug / f"{name}.{ext}").is_file():
                f.add("embed", "HATA", doc.path, line,
                      f"{{{{{name}.{ext}}}}} -> examples/{slug}/{name}.{ext} bulunamadı "
                      f"(sayfada '// Örnek bulunamadı' yazar)")
        # Deseni tutmayan {{...}}: gömme olarak işlenmez, sayfada ham metin kalır.
        for i, line in enumerate(doc.lines):
            if doc.in_fence[i]:
                continue
            for m in ANY_DOUBLE_BRACE.finditer(re.sub(r"`[^`]*`", "", line)):
                if not EMBED.fullmatch(m.group(0)):
                    f.add("embed", "OLASI", doc.path, i + 1,
                          f"{m.group(0)} gömme desenine uymuyor (ad yalnızca harf/rakam/_ içerebilir) "
                          f"-- gömme niyetiyle yazıldıysa sayfada ham metin olarak kalır")
    for slug in sorted({s for (_, s) in docs}):
        per_lang = {lang: {f"{n}.{e}" for n, e, _ in docs[(lang, slug)].embeds()}
                    for lang in LANGS if (lang, slug) in docs}
        if len(per_lang) == 2 and per_lang["tr"] != per_lang["en"]:
            only_tr = sorted(per_lang["tr"] - per_lang["en"])
            only_en = sorted(per_lang["en"] - per_lang["tr"])
            detail = "; ".join(p for p in (
                f"yalnızca TR: {', '.join(only_tr)}" if only_tr else "",
                f"yalnızca EN: {', '.join(only_en)}" if only_en else "") if p)
            f.add("embed", "OLASI", docs[("tr", slug)].path, None,
                  f"TR ve EN farklı örnekleri gömüyor ({detail}) -- H2 sayısı gibi bu da zorunlu değil")
        directory = EXAMPLES / slug
        if directory.is_dir():
            for path in sorted(directory.iterdir()):
                if path.is_file() and not path.name.startswith(".") and path.name not in embedded[slug]:
                    f.add("embed", "OLASI", path, None,
                          "hiçbir dilde gömülmüyor (kullanılmayan örnek dosyası ya da başka bir "
                          "örneğin yardımcı dosyası)")
    if EXAMPLES.is_dir() and not slugs:
        content_slugs = {p.stem for lang in LANGS for p in (CONTENT / lang).glob("*.md")}
        for directory in sorted(EXAMPLES.iterdir()):
            if directory.is_dir() and directory.name not in content_slugs:
                f.add("embed", "OLASI", directory, None, "bu klasöre karşılık gelen bir içerik dosyası yok")
    if not db.available:
        return
    rows = db.query("select t.slug, ce.example_name from code_example ce join topic t on t.id = ce.topic_id")
    registered = defaultdict(set)
    for slug, name in rows:
        registered[slug].add(name)
    for slug in sorted({s for (_, s) in docs}):
        stems = {n.rsplit(".", 1)[0] for n in embedded[slug]}
        path = f"src/main/resources/content/tr/{slug}.md"
        for name in sorted(registered[slug] - stems):
            f.add("embed", "OLASI", path, None,
                  f"code_example satırı '{name}' hiçbir {{{{...}}}} gömmesine karşılık gelmiyor "
                  f"(tablo çalışma anında okunmuyor; yalnızca metadata tutarsızlığı)")
        for name in sorted(stems - registered[slug]):
            f.add("embed", "BİLGİ", path, None,
                  f"gömülen '{name}' için code_example satırı yok (tablo çalışma anında okunmuyor)")


def check_headings(docs, db, f, slugs):
    for (lang, slug), doc in docs.items():
        h1 = doc.heading_texts(1)
        if len(h1) > 1:
            f.add("baslik", "OLASI", doc.path, doc.headings[0][2], f"{len(h1)} adet H1 var")
        seen = Counter(doc.heading_texts(2))
        for text, count in seen.items():
            if count > 1:
                f.add("baslik", "HATA", doc.path, None,
                      f"aynı H2 {count} kez geçiyor: \"{text}\" (anchor id'leri ve atıflar belirsizleşir)")
    for slug in sorted({s for (_, s) in docs}):
        if ("tr", slug) not in docs or ("en", slug) not in docs:
            continue
        tr, en = docs[("tr", slug)], docs[("en", slug)]
        english = set(en.heading_texts())
        for level, text, line in tr.headings:
            if text in english and text not in ALLOWED_ENGLISH_HEADINGS:
                # Tireli bileşikler ("Built-in", "do-while"), bayraklar ("--force-with-lease"),
                # satır içi kod ve TAMAMI BÜYÜK kelimeler ("ON CONFLICT") terim sayılır.
                plain = re.sub(r"`[^`]*`", " ", text)
                tokens = [t for t in re.findall(r"[A-Za-z][A-Za-z'-]*", plain) if "-" not in t and not t.isupper()]
                words = {t.lower() for t in tokens}
                strong, weak = words & STRONG_ENGLISH_WORDS, words & WEAK_ENGLISH_WORDS
                hits = sorted(strong | weak)
                if strong or len(weak) >= 2:
                    f.add("baslik", "OLASI", tr.path, line,
                          f"TR başlık EN ile birebir aynı ve İngilizce bir ifadeye benziyor: \"{text}\" "
                          f"(eşleşen kelimeler: {', '.join(hits)})")
    if not db.available:
        return
    titles = {(r[0], r[1]): r[2] for r in db.query(
        "select t.slug, tt.language, tt.title from topic_translation tt join topic t on t.id = tt.topic_id")}
    for (lang, slug), doc in docs.items():
        h1 = doc.heading_texts(1)
        title = titles.get((slug, lang))
        if h1 and title and norm(h1[0]) != norm(title):
            f.add("baslik", "BİLGİ", doc.path, doc.headings[0][2],
                  f"H1 \"{h1[0]}\" ile DB başlığı \"{title}\" farklı (sayfada ikisi alt alta görünür)")


def ordered_list_lines(paragraph):
    """Paragrafın her satırı için: numaralı bir liste maddesinin (ya da girintili devamının) parçası mı."""
    flags, inside = [], False
    for line in paragraph.split("\n"):
        if ORDERED_LIST_ITEM.match(line):
            inside = True
        elif not line.startswith((" ", "\t")):
            inside = False
        flags.append(inside)
    return flags


def check_references(docs, db, f, slugs):
    # Geçerli hedefler dil başına: o dildeki TÜM içerik dosyalarının başlıkları + DB başlıkları.
    # --slug ile daraltılmış olsa bile hedef kümesi tüm içerikten kurulur.
    targets = {lang: set() for lang in LANGS}
    for lang in LANGS:
        for path in (CONTENT / lang).glob("*.md"):
            doc = docs.get((lang, path.stem)) or Markdown(path, lang)
            targets[lang].update(norm(t) for t in doc.heading_texts())
    if db.available:
        for lang, title in db.query("select language, title from topic_translation"):
            targets.setdefault(lang, set()).add(norm(title))
        for (name,) in db.query("select name from category union select name from course"):
            for lang in LANGS:
                targets[lang].add(norm(name))
    loose_index = {lang: defaultdict(set) for lang in LANGS}
    for lang in LANGS:
        for t in targets[lang]:
            loose_index[lang][loose(t)].add(t)
            loose_index[lang][loose(t.replace("`", ""))].add(t)
    exact_plain = {lang: {same_modulo_quotes(v) for t in targets[lang] for v in (t, t.replace("`", ""))}
                   for lang in LANGS}

    def classify(lang, text, is_reference):
        """(önem, mesaj) ya da None."""
        other = "en" if lang == "tr" else "tr"
        text = same_modulo_quotes(text)
        if text in exact_plain[lang] or text.rstrip(",.;:") in exact_plain[lang]:
            return None
        near = loose_index[lang].get(loose(text))
        # Atıf bağlamı olmayan, küçük harfle başlayan tek bir kelime/terim ("deep learning",
        # "name") başlığa değil kavramın kendisine işaret eder -- gürültü, raporlanmaz.
        looks_like_title = text[:1].isupper() and len(text.split()) >= 2
        if near and (is_reference or looks_like_title):
            return ("HATA" if is_reference else "OLASI",
                    f"\"{text}\" hiçbir başlıkla BİREBİR eşleşmiyor; yalnızca harf/noktalama farkıyla: "
                    f"\"{sorted(near)[0]}\"")
        if (text in exact_plain[other] or text.rstrip(",.;:") in exact_plain[other]) and len(text.split()) >= 2:
            return ("HATA" if is_reference else "OLASI",
                    f"\"{text}\" yalnızca {other.upper()} içerikte bir başlık; {lang.upper()} karşılığı kullanılmalı")
        if not is_reference:
            return None
        close = difflib.get_close_matches(text, list(targets[lang]), n=1, cutoff=0.82)
        if close:
            return ("HATA", f"\"{text}\" bir bölüme atıf gibi ama hiçbir başlıkla eşleşmiyor; "
                            f"en yakın: \"{close[0]}\"")
        return ("OLASI", f"\"{text}\" bir bölüme atıf gibi ama hiçbir başlıkla eşleşmiyor "
                         f"(başlık olmayan bir alıntı da olabilir)")

    for (lang, slug), doc in docs.items():
        for start, para in doc.prose_paragraphs():
            if para.lstrip().startswith("#"):
                continue
            step_lines = ordered_list_lines(para)
            for m in QUOTED.finditer(para):
                text = clean_quote(m.group(1))
                before = norm(para[max(0, m.start() - 30):m.start()])
                after = para[m.end():m.end() + 30].replace("\n", " ")
                is_reference = bool(REF_AFTER.match(after) or REF_BEFORE.search(before))
                result = classify(lang, text, is_reference)
                if result:
                    offset = para[:m.start()].count("\n")
                    severity, message = result
                    # Numaralı adım listeleri bir araçtaki işlem sırasını anlatır; oradaki
                    # tırnaklı "X bölümü" çoğunlukla dersin değil aracın arayüzündeki bir
                    # bölümdür ("Environment Variables" bölümüne ekle). Tüm içerikteki ~1250
                    # bölüm atfının yalnızca 3'ü numaralı adımın içinde. Bulgu atılmaz,
                    # yalnızca "kesin" sayılmaz.
                    if severity == "HATA" and step_lines[offset]:
                        severity = "OLASI"
                        message += " (numaralı adım listesinde: bir aracın arayüzündeki bölüm olabilir)"
                    f.add("atif", severity, doc.path, start + offset, message)
            for m in NUMBERED_REF.finditer(para):
                line = start + para[:m.start()].count("\n")
                f.add("atif", "OLASI", doc.path, line,
                      f"numarayla bölüm atfı olabilir: \"{m.group(0)}\" (kural: bölümlere isimle atıf yapılır)")
    if not db.available:
        return
    rows = db.query("select q.id, t.slug, q.language, q.status, q.question, q.explanation from question q "
                    "join topic t on t.id = q.topic_id where q.status = 'PUBLISHED'")
    for qid, slug, lang, status, question, explanation in rows:
        if (slugs and slug not in slugs) or lang not in targets:
            continue
        for field, body in (("soru", question), ("açıklama", explanation)):
            for pattern in QUIZ_SECTION_REFS:
                for m in pattern.finditer(body):
                    result = classify(lang, norm(m.group(1)), True)
                    if result:
                        f.add("atif", result[0], f"DB question id={qid} ({slug}, {lang})", None,
                              f"{field} metni: {result[1]}")


def check_markdown(docs, db, f, slugs):
    for (lang, slug), doc in docs.items():
        if doc.unclosed_fence:
            f.add("markdown", "HATA", doc.path, None,
                  "kapanmamış kod bloğu (``` sayısı tek) -- dosyanın kalanı kod olarak render olur")
        lines = doc.lines
        for i in range(1, len(lines)):
            if (not doc.in_fence[i] and TABLE_SEPARATOR.match(lines[i]) and "|" in lines[i - 1]
                    and not doc.in_fence[i - 1]):
                f.add("markdown", "HATA", doc.path, i,
                      "markdown tablosu (GFM tables eklentisi yok, düz metin olarak render olur)")
        i = 0
        while i < len(lines):
            if doc.in_fence[i] or not lines[i].startswith(">"):
                i += 1
                continue
            j = i
            while j < len(lines) and lines[j].startswith(">") and not doc.in_fence[j]:
                j += 1
            block = lines[i:j]
            m = CALLOUT_START.match(block[0])
            if m:
                expected = "Tip" if m.group(1) == "💡" else "Warning"
                if m.group(2) != expected:
                    f.add("markdown", "HATA", doc.path, i + 1,
                          f"{m.group(1)} sonrası \"{expected}\" bekleniyor, \"{m.group(2) or ''}\" var "
                          f"-- alert'e çevrilmez, düz blockquote kalır")
                if any(re.fullmatch(r">\s*", b) for b in block[1:]):
                    f.add("markdown", "HATA", doc.path, i + 1,
                          "Tip/Warning blockquote'u birden fazla paragraf içeriyor -- alert'e çevrilmez")
                if any(re.match(r">\s*(```|~~~)", b) for b in block):
                    f.add("markdown", "HATA", doc.path, i + 1,
                          "Tip/Warning blockquote'u içinde kod bloğu var -- alert'e çevrilmez")
            i = j


def check_migrations(docs, db, f, slugs):
    if slugs:
        return  # migration kontrolü proje geneli, slug filtresiyle anlamlı değil
    placeholder_disabled = "placeholder-replacement: false" in (RES / "application.yml").read_text(encoding="utf-8")
    versions = defaultdict(list)
    for path in sorted(MIGRATIONS.rglob("*.sql")):
        m = MIGRATION_NAME.match(path.name)
        if not m:
            f.add("migration", "HATA", path, None, "dosya adı V{n}__{aciklama}.sql desenine uymuyor (Flyway yok sayar)")
            continue
        versions[int(m.group(1))].append(path)
        if path.parent == MIGRATIONS:
            f.add("migration", "BİLGİ", path, None, "konu alt klasöründe değil, db/migration kökünde")
        for i, line in enumerate(read_lines(path)):
            if "${" in line:
                if placeholder_disabled:
                    f.add("migration", "BİLGİ", path, i + 1,
                          "dolar-süslü-parantez içeriyor; application.yml'de placeholder-replacement: false "
                          "olduğu için artık hata vermez")
                else:
                    f.add("migration", "HATA", path, i + 1,
                          "dolar-süslü-parantez içeriyor -- Flyway placeholder sanar, uygulama başlamaz")
                break
    for version, paths in sorted(versions.items()):
        if len(paths) > 1:
            f.add("migration", "HATA", paths[0], None,
                  f"V{version} birden fazla dosyada: {', '.join(p.name for p in paths)}")
    if versions:
        missing = sorted(set(range(1, max(versions) + 1)) - set(versions))
        if missing:
            preview = ", ".join(f"V{v}" for v in missing[:12]) + (" ..." if len(missing) > 12 else "")
            f.add("migration", "BİLGİ", "src/main/resources/db/migration", None,
                  f"{len(missing)} sürüm numarası atlanmış: {preview}")
    if db.available and versions:
        applied = db.query("select coalesce(max(version::int), 0) from flyway_schema_history where success")[0][0]
        if int(applied) != max(versions):
            f.add("migration", "BİLGİ", "DB flyway_schema_history", None,
                  f"dev DB V{applied}'de, dosyalar V{max(versions)}'de -- DB'ye dayanan kontroller eski "
                  f"veriyle çalışmış olabilir (uygulamayı bir kez başlatın)")


def check_seo(docs, db, f, slugs):
    if not db.available:
        return
    rows = db.query("select t.slug, tt.language, tt.seo_title, tt.seo_description from topic_translation tt "
                    "join topic t on t.id = tt.topic_id where tt.published")
    by_title = defaultdict(list)
    for slug, lang, title, description in rows:
        if slugs and slug not in slugs:
            continue
        where = f"DB topic_translation ({slug}, {lang})"
        if not title:
            f.add("seo", "HATA", where, None, "seo_title boş (sayfa başlığı ders başlığına düşer)")
        else:
            by_title[(lang, title)].append(slug)
            if len(title) > SEO_TITLE_MAX:
                f.add("seo", "OLASI", where, None,
                      f"seo_title {len(title)} karakter (öneri: en çok {SEO_TITLE_MAX}): \"{title}\"")
        if not description:
            f.add("seo", "HATA", where, None, "seo_description boş (sayfada meta description olmaz)")
        else:
            if len(description) > SEO_DESCRIPTION_MAX:
                f.add("seo", "OLASI", where, None,
                      f"seo_description {len(description)} karakter (öneri: en çok {SEO_DESCRIPTION_MAX})")
            if PROJECT_PHRASE.search(description):
                f.add("seo", "OLASI", where, None,
                      "seo_description 'bu proje'/'this project' diyor -- arama sonucunda bağlamı yok")
    for (lang, title), slug_list in sorted(by_title.items()):
        if len(slug_list) > 1:
            f.add("seo", "HATA", f"DB topic_translation ({lang})", None,
                  f"aynı seo_title {len(slug_list)} konuda: \"{title}\" ({', '.join(slug_list)})")


RUNNERS = {"dosya": check_files, "embed": check_embeds, "baslik": check_headings, "atif": check_references,
           "markdown": check_markdown, "migration": check_migrations, "seo": check_seo}


# --------------------------------------------------------------------------------- çıktı

def render(findings, selected, db, limit):
    out = []
    by_check = defaultdict(list)
    for item in findings.items:
        by_check[item[0]].append(item)
    out.append("# LearnForgeX içerik denetimi")
    out.append("")
    if not db.available:
        out.append(f"> Veritabanı okunamadı ({db.error or '--no-db'}); DB gerektiren kontroller atlandı.")
        out.append("")
    out.append("## Özet")
    out.append("")
    out.append(f"{'Kontrol':<10} {'HATA':>5} {'OLASI':>6} {'BİLGİ':>6} {'Dosya':>6}")
    totals = Counter()
    for check in selected:
        items = by_check.get(check, [])
        counts = Counter(i[1] for i in items)
        totals.update(counts)
        files = len({i[2] for i in items})
        out.append(f"{check:<10} {counts['HATA']:>5} {counts['OLASI']:>6} {counts['BİLGİ']:>6} {files:>6}")
    all_files = len({i[2] for i in findings.items})
    out.append(f"{'TOPLAM':<10} {totals['HATA']:>5} {totals['OLASI']:>6} {totals['BİLGİ']:>6} {all_files:>6}")
    out.append("")
    for check in selected:
        items = by_check.get(check, [])
        out.append(f"## {check} — {CHECKS[check]} ({len(items)} bulgu)")
        out.append("")
        if not items:
            out.append("Bulgu yok.")
            out.append("")
            continue
        items.sort(key=lambda i: (SEVERITIES.index(i[1]), i[2], i[3] or 0))
        shown = items if limit is None else items[:limit]
        for _, severity, path, line, message in shown:
            location = f"{path}:{line}" if line else path
            out.append(f"- [{severity}] {location}")
            out.append(f"    {message}")
        if len(items) > len(shown):
            out.append(f"- ... {len(items) - len(shown)} bulgu daha (--all ya da --report ile tamamı)")
        out.append("")
    return "\n".join(out)


def main():
    parser = argparse.ArgumentParser(description="LearnForgeX içerik denetimi (yalnızca raporlar)")
    parser.add_argument("--slug")
    parser.add_argument("--only")
    parser.add_argument("--all", action="store_true")
    parser.add_argument("--report")
    parser.add_argument("--no-db", action="store_true")
    args = parser.parse_args()

    slugs = {s.strip() for s in args.slug.split(",")} if args.slug else None
    selected = [c.strip() for c in args.only.split(",")] if args.only else list(CHECKS)
    unknown = [c for c in selected if c not in CHECKS]
    if unknown:
        parser.error(f"bilinmeyen kontrol: {', '.join(unknown)} (geçerli: {', '.join(CHECKS)})")

    docs = load_markdown(slugs)
    if slugs and not docs:
        parser.error(f"bu slug için içerik dosyası yok: {', '.join(sorted(slugs))}")
    db = Database(not args.no_db)
    findings = Findings()
    for check in selected:
        RUNNERS[check](docs, db, findings, slugs)

    print(render(findings, selected, db, None if args.all else 15))
    if args.report:
        Path(args.report).write_text(render(findings, selected, db, None) + "\n", encoding="utf-8")
        print(f"Tam rapor: {args.report}")
    return 1 if any(i[1] == "HATA" for i in findings.items) else 0


if __name__ == "__main__":
    sys.exit(main())
