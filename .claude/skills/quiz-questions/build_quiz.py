#!/usr/bin/env python3
"""LearnForgeX quiz soruları: bir soru tanım dosyasını (spec) denetler ve migration'lara çevirir.

    python3 .claude/skills/quiz-questions/build_quiz.py check SPEC.json
    python3 .claude/skills/quiz-questions/build_quiz.py preview SPEC.json
    python3 .claude/skills/quiz-questions/build_quiz.py generate SPEC.json [--dry-run]

check     spec'i kurallara göre denetler; hiçbir dosya yazmaz.
preview   soruları, şıkların migration'daki nihai sırasıyla okunabilir biçimde basar.
generate  check'ten geçerse migration dosyalarını yazar (var olan dosyanın üzerine yazmaz).

Spec biçimi SKILL.md'de. Şıkların sırası burada belirlenir: yazar doğru/yanlış şıkları ayrı
listelerde verir, doğru şıkkın konumu soru sırasına göre deterministik olarak dağıtılır.
"""
import argparse
import itertools
import json
import os
import re
import shlex
import subprocess
import sys
import tempfile
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RES = ROOT / "src/main/resources"
CONTENT = RES / "content"
MIGRATIONS = RES / "db/migration"
DEFAULT_PSQL = "docker exec learning-platform-db psql -U learning -d learning"
LANGS = ("en", "tr")
TYPES = ("SINGLE_CHOICE", "MULTIPLE_CHOICE", "CODE_OUTPUT")
DIFFICULTIES = ("BEGINNER", "INTERMEDIATE", "ADVANCED")
QUIZ_TITLES = {"tr": "Bilgini Test Et", "en": "Test Your Knowledge"}
REVIEWER = "claude-code@anthropic.com"
MIN_PAIRS, MAX_PAIRS = 4, 7
# İki doğru şıklı MULTIPLE_CHOICE'ta doğruların konumları bu sırayla döner.
TWO_CORRECT_SLOTS = [(0, 1), (2, 3), (1, 2), (0, 3), (0, 2), (1, 3)]
SECTION_REF = re.compile(r"""(['"])([^'"\n]{3,120})\1\s*(?:bölüm\w*|section\b)""", re.I)
# Şık harfine atıf: "A ve B", "A, C", "şık B", "option C", "B şıkkı", "(D)", "A)".
# Satır içi kod (`A`) önce çıkarılır: bir kodun çıktısı olan harf atıf değildir.
# Harfler büyük/küçük duyarlı aranır ("a `break` or a `return`" atıf değildir).
OPTION_LETTER = re.compile(
    r"\b[A-D]\s*(?:,|(?i:ve|and|ile|ya da|veya|or))\s*[A-D]\b"
    r"|\b(?i:şık|şıkkı|şıklar|seçenek|seçeneği|option|options|choice|answer)\s+[A-D]\b"
    r"|\b[A-D]\s+(?i:şıkkı|şıkları|seçeneği|option|choice)\b"
    r"|\([A-D]\)|(?<![\w`])[A-D]\)")
JAVA_TIMEOUT_SECONDS = 20
CATCH_ALL = re.compile(r"all of the above|none of the above|hepsi|hiçbiri|yukarıdakilerin", re.I)


def fail(message):
    print(f"HATA: {message}", file=sys.stderr)
    sys.exit(2)


def norm(text):
    return re.sub(r"\s+", " ", text).strip()


def headings(lang, slug=None):
    paths = [CONTENT / lang / f"{slug}.md"] if slug else sorted((CONTENT / lang).glob("*.md"))
    found, inside = set(), False
    for path in paths:
        for line in path.read_text(encoding="utf-8").split("\n"):
            if line.lstrip().startswith("```"):
                inside = not inside
            elif not inside and re.match(r"#{1,2} ", line):
                found.add(norm(line.lstrip("#")))
    return found


def psql(sql):
    cmd = shlex.split(os.environ.get("QUIZ_PSQL", DEFAULT_PSQL))
    result = subprocess.run(cmd + ["-At", "-F", "\x1f", "-R", "\x1e", "-c", sql],
                            capture_output=True, text=True, timeout=60)
    if result.returncode != 0:
        return None
    out = result.stdout.rstrip("\n")
    return [row.split("\x1f") for row in out.split("\x1e")] if out else []


def migration_versions():
    return [int(m.group(1)) for p in MIGRATIONS.rglob("V*.sql") if (m := re.match(r"V(\d+)__", p.name))]


def quiz_shell_in_migrations(slug):
    """Bu konu için bir quiz shell'i zaten bir migration'da ekleniyor mu (Faz 157'deki
    'duplicate key' hatasının sebebi: bazı kursların topic migration'ı shell'i de ekliyor)."""
    pattern = re.compile(r"INSERT INTO quiz\b[^;]*?slug\s*=\s*'" + re.escape(slug) + r"'", re.I | re.S)
    return [p for p in MIGRATIONS.rglob("V*.sql") if pattern.search(p.read_text(encoding="utf-8"))]


LAYOUT = {}


def compute_layout(spec):
    """Her soru için doğru şık(lar)ın konumunu seçer. Yumuşak hedef: konumlar A-D arasında
    dengeli dağılsın. Sırayla, o ana kadar en az kullanılmış konum(lar) seçilir; eşitlikte
    soru sırasına göre dönen bir öncelik kullanılır (EN ve TR farklı noktadan başlar)."""
    LAYOUT.clear()
    for lang in LANGS:
        shift = 0 if lang == "en" else 1
        used = [0, 0, 0, 0]
        for index, pair in enumerate(spec["pairs"]):
            item = pair[lang]
            total, k = len(item["correct"]) + len(item["wrong"]), len(item["correct"])
            if k == 1:
                start = (index + 2 * shift) % total
                candidates = [((start + i) % total,) for i in range(total)]
            elif k == 2 and total == 4:
                start = (index + 3 * shift) % len(TWO_CORRECT_SLOTS)
                candidates = TWO_CORRECT_SLOTS[start:] + TWO_CORRECT_SLOTS[:start]
            else:
                candidates = list(itertools.combinations(range(total), k))
            best = min(candidates, key=lambda c: (sum(used[p] for p in c), max(used[p] for p in c)))
            for position in best:
                used[position] += 1
            LAYOUT[(lang, index)] = set(best)


def ordered_options(item, pair_index, lang):
    """(metin, doğru_mu) listesi, migration'daki nihai sırayla."""
    correct, wrong = list(item["correct"]), list(item["wrong"])
    slots = LAYOUT[(lang, pair_index)]
    return [(correct.pop(0), True) if position in slots else (wrong.pop(0), False)
            for position in range(len(item["correct"]) + len(item["wrong"]))]


# ------------------------------------------------------------------- kod çıktısı doğrulama

def java_home():
    configured = os.environ.get("QUIZ_JAVA_HOME")
    if configured:
        return configured
    try:
        found = subprocess.run(["/usr/libexec/java_home", "-v", "21"], capture_output=True, text=True, timeout=10)
        if found.returncode == 0 and found.stdout.strip():
            return found.stdout.strip()
    except (OSError, subprocess.SubprocessError):
        pass
    return os.environ.get("JAVA_HOME")


def run_java(code):
    """Kodu gerçekten derleyip çalıştırır. Dönüş: (durum, stdout, ayrıntı);
    durum 'ok' | 'compile-error' | 'exception' | 'unavailable'."""
    home = java_home()
    javac = str(Path(home) / "bin/javac") if home else "javac"
    java = str(Path(home) / "bin/java") if home else "java"
    declared = re.search(r"\bpublic\s+(?:final\s+)?class\s+(\w+)", code) or re.search(r"\bclass\s+(\w+)", code)
    if declared:
        name, source = declared.group(1), code
    else:
        name = "Snippet"
        body = "\n".join("        " + line for line in code.split("\n"))
        # `throws` bilerek yok: checked exception fırlatan bir parça (ör. `join()`) bu sarmalayıcıyla
        # derlenmez; öyle bir kod, okuyucunun da derleyebileceği tam bir sınıf olarak yazılmalıdır.
        source = f"public class Snippet {{\n    public static void main(String[] args) {{\n{body}\n    }}\n}}\n"
    with tempfile.TemporaryDirectory(prefix="quiz-java-") as directory:
        (Path(directory) / f"{name}.java").write_text(source, encoding="utf-8")
        try:
            compiled = subprocess.run([javac, "-encoding", "UTF-8", "-d", directory, f"{directory}/{name}.java"],
                                      capture_output=True, text=True, timeout=JAVA_TIMEOUT_SECONDS * 3)
        except OSError as error:
            return "unavailable", "", str(error)
        if compiled.returncode != 0:
            return "compile-error", "", compiled.stderr.strip()
        try:
            executed = subprocess.run([java, "-Dfile.encoding=UTF-8", "-Dstdout.encoding=UTF-8", "-cp", directory, name],
                                      capture_output=True, text=True, timeout=JAVA_TIMEOUT_SECONDS)
        except subprocess.TimeoutExpired:
            return "exception", "", f"{JAVA_TIMEOUT_SECONDS} saniyede bitmedi"
        return ("ok" if executed.returncode == 0 else "exception"), executed.stdout, executed.stderr.strip()


def verify_code_output(item, tag, errors, notes):
    """CODE_OUTPUT sorusunun kodunu çalıştırıp yazarın beyan ettiği sonuçla karşılaştırır."""
    language, expect = item.get("codeLanguage"), item.get("expect", "output")
    if language != "java":
        if not norm(item.get("manualVerification", "")):
            errors.append(f"{tag}: '{language}' kodu otomatik çalıştırılamıyor -- çıktının nasıl doğrulandığını "
                          f"manualVerification alanına yaz (ör. gerçek terminal çıktısı)")
        else:
            notes.append(f"{tag}: '{language}' kodu elle doğrulandı: {norm(item['manualVerification'])}")
        return
    if expect not in ("output", "compile-error", "exception"):
        errors.append(f"{tag}: expect '{expect}' geçersiz (output, compile-error, exception)")
        return
    status, stdout, detail = run_java(item["code"])
    if status == "unavailable":
        errors.append(f"{tag}: Java çalıştırılamadı ({detail}) -- QUIZ_JAVA_HOME ile bir JDK 21 göster")
        return
    actual_kind = {"ok": "output", "compile-error": "compile-error", "exception": "exception"}[status]
    if actual_kind != expect:
        first_line = detail.split("\n")[0] if detail else ""
        errors.append(f"{tag}: kod çalıştırıldı, beklenen '{expect}' ama gerçekleşen '{actual_kind}' {first_line}".rstrip())
        return
    if expect == "compile-error":
        notes.append(f"{tag}: kod derlenmiyor (beklendiği gibi)")
        return
    if expect == "exception":
        wanted = item.get("expectedException")
        if not wanted:
            errors.append(f"{tag}: expect 'exception' için expectedException (sınıf adı) yazılmalı -- gerçek hata: "
                          f"{detail.split(chr(10))[0]}")
            return
        if wanted not in detail:
            errors.append(f"{tag}: beklenen exception '{wanted}' değil -- gerçek hata: {detail.split(chr(10))[0]}")
            return
        if wanted not in item["correct"][0]:
            errors.append(f"{tag}: doğru şık fırlatılan exception'ı ('{wanted}') anmıyor")
            return
    if "expectedOutput" not in item:
        errors.append(f"{tag}: expectedOutput yok -- kodun gerçek çıktısı: {stdout.rstrip()!r}")
        return
    actual = "\n".join(line.rstrip() for line in stdout.rstrip().split("\n"))
    expected = "\n".join(line.rstrip() for line in item["expectedOutput"].rstrip().split("\n"))
    if actual != expected:
        errors.append(f"{tag}: gerçek çıktı beyan edilenle uyuşmuyor -- gerçek: {actual!r}, beyan: {expected!r}")
        return
    correct_text = item["correct"][0].replace("`", "")
    missing = [line for line in actual.split("\n") if line.strip() and line.strip() not in correct_text]
    if missing:
        errors.append(f"{tag}: doğru şık gerçek çıktıyı yansıtmıyor -- şıkta geçmeyen çıktı satırı: {missing[0]!r}")
        return
    for wrong in item["wrong"]:
        if wrong.replace("`", "").strip() == actual.strip():
            errors.append(f"{tag}: yanlış diye işaretlenen bir şık gerçek çıktıyla birebir aynı: \"{wrong}\"")
            return
    notes.append(f"{tag}: kod derlendi ve çalıştırıldı, çıktı doğrulandı: {actual!r}")


def code_terms(text):
    """Satır içi kod parçalarındaki ve kod bloğundaki tanımlayıcılar ve operatörler."""
    spans = re.findall(r"`([^`]+)`", text)
    terms = set()
    for span in spans:
        terms.update(re.findall(r"[A-Za-z_]\w+", span))
        terms.update(re.findall(r"\+\+|--|\+=|-=|\*=|/=|==|!=|<=|>=|&&|\|\||->|::|\?|%", span))
    return terms


def section_body(lang, slug, heading):
    """Bir H2 bölümünün metni (bir sonraki H2'ye kadar)."""
    lines = (CONTENT / lang / f"{slug}.md").read_text(encoding="utf-8").split("\n")
    out, inside = [], False
    for line in lines:
        if line.startswith("## "):
            if inside:
                break
            inside = norm(line[3:]) == heading
        elif inside:
            out.append(line)
    return "\n".join(out)


def h2_list(lang, slug):
    found, fenced = [], False
    for line in (CONTENT / lang / f"{slug}.md").read_text(encoding="utf-8").split("\n"):
        if line.lstrip().startswith("```"):
            fenced = not fenced
        elif not fenced and line.startswith("## "):
            found.append(norm(line[3:]))
    return found


# ------------------------------------------------------------------------------- check

def check(spec, run_code=True):
    errors, warnings, notes = [], [], []
    slug = spec.get("topic", "")
    for lang in LANGS:
        if not (CONTENT / lang / f"{slug}.md").is_file():
            errors.append(f"content/{lang}/{slug}.md yok -- konu slug'ı yanlış ya da çeviri eksik")
    pairs = spec.get("pairs", [])
    if errors:
        return errors, warnings, notes
    sections = {lang: h2_list(lang, slug) for lang in LANGS}
    if not MIN_PAIRS <= len(pairs) <= MAX_PAIRS:
        warnings.append(f"{len(pairs)} soru çifti var; konvansiyon ders yoğunluğuna göre {MIN_PAIRS}-{MAX_PAIRS}")
    own = {lang: headings(lang, slug) for lang in LANGS}
    everything = {lang: headings(lang) for lang in LANGS}
    seen = {lang: {} for lang in LANGS}
    types = Counter()
    for index, pair in enumerate(pairs):
        where = f"çift {index + 1}"
        qtype, difficulty = pair.get("type"), pair.get("difficulty")
        types[qtype] += 1
        if qtype not in TYPES:
            errors.append(f"{where}: type '{qtype}' geçersiz ({', '.join(TYPES)})")
        if difficulty not in DIFFICULTIES:
            errors.append(f"{where}: difficulty '{difficulty}' geçersiz ({', '.join(DIFFICULTIES)})")
        if not norm(pair.get("concept", "")):
            errors.append(f"{where}: concept boş -- çiftin ölçtüğü kavram tek cümleyle yazılmalı")
        # EN ve TR aynı kavramı soruyor mu: her çift, dersin iki dildeki AYNI bölümüne bağlanır.
        declared = pair.get("section") or {}
        positions = {}
        for lang in LANGS:
            heading = norm(declared.get(lang, ""))
            if not heading:
                errors.append(f"{where}: section.{lang} yok -- çiftin dayandığı bölümün H2 başlığı yazılmalı")
            elif heading not in sections[lang]:
                errors.append(f"{where}: section.{lang} \"{heading}\" content/{lang}/{slug}.md'de bir H2 değil")
            else:
                positions[lang] = sections[lang].index(heading)
        if len(positions) == 2:
            if len(sections["en"]) != len(sections["tr"]):
                notes.append(f"{where}: EN ve TR dersin bölüm sayısı farklı; bölüm eşleşmesi sırayla doğrulanamadı")
            elif positions["en"] != positions["tr"]:
                errors.append(f"{where}: EN sorusu {positions['en'] + 1}. bölüme, TR sorusu {positions['tr'] + 1}. "
                              f"bölüme bağlanmış -- aynı kavram çifti aynı bölüme dayanmalı")
        for lang in LANGS:
            item, tag = pair.get(lang), f"{where}/{lang}"
            if not item:
                errors.append(f"{tag}: eksik -- her kavram çifti hem EN hem TR soru içerir")
                continue
            question, explanation = item.get("question", ""), item.get("explanation", "")
            correct, wrong = item.get("correct", []), item.get("wrong", [])
            options = correct + wrong
            if not norm(question) or not norm(explanation):
                errors.append(f"{tag}: question ve explanation boş olamaz")
            if len(options) != 4:
                errors.append(f"{tag}: {len(options)} şık var, 4 olmalı")
            if qtype in ("SINGLE_CHOICE", "CODE_OUTPUT") and len(correct) != 1:
                errors.append(f"{tag}: {qtype} tam olarak 1 doğru şık ister ({len(correct)} var)")
            if qtype == "MULTIPLE_CHOICE":
                if len(correct) < 2:
                    errors.append(f"{tag}: MULTIPLE_CHOICE en az 2 doğru şık ister")
                elif len(correct) != 2:
                    warnings.append(f"{tag}: {len(correct)} doğru şık -- konvansiyon tam 2")
            code, code_language = item.get("code"), item.get("codeLanguage")
            if qtype == "CODE_OUTPUT" and not (code and code_language):
                errors.append(f"{tag}: CODE_OUTPUT için code ve codeLanguage zorunlu")
            if qtype != "CODE_OUTPUT" and code:
                errors.append(f"{tag}: code yalnızca CODE_OUTPUT'ta render edilir -- tipi değiştir ya da code'u kaldır")
            if qtype == "CODE_OUTPUT" and "```" in question:
                errors.append(f"{tag}: kod soru metninde değil, yalnızca code alanında olmalı")
            if len({norm(o) for o in options}) != len(options):
                errors.append(f"{tag}: aynı şık iki kez yazılmış")
            for text in [question, explanation, code or ""] + options:
                if "$$" in text or text.endswith("$"):
                    errors.append(f"{tag}: metin '$$' içeremez ve '$' ile bitemez (SQL dollar-quoting)")
            for field, text in [("soru", question), ("açıklama", explanation)] + [("şık", o) for o in options]:
                hit = OPTION_LETTER.search(re.sub(r"`[^`]*`", " ", text))
                if hit:
                    errors.append(f"{tag}: {field} metni şık harfine atıf yapıyor (\"{hit.group(0)}\") -- arayüzde "
                                  f"harf yok, şıkların sırası da script tarafından belirlenir")
            # Soru, bağlandığı bölümün gerçekten anlattığı bir şeye dayanıyor mu (kaba kontrol):
            # sorudaki kod terimlerinden en az biri o bölümün metninde geçmeli.
            heading = norm(declared.get(lang, ""))
            if heading in sections[lang]:
                own_terms = code_terms(" ".join([question, explanation] + options)) | code_terms(f"`{code or ''}`")
                body = section_body(lang, slug, heading)
                # Bölümün gömdüğü örnek dosyalar da o bölümün anlattığı şeydir.
                embedded = "".join(
                    (RES / "examples" / slug / f"{name}.{ext}").read_text(encoding="utf-8")
                    for name, ext in re.findall(r"\{\{(\w+)\.(\w+)}}", body)
                    if (RES / "examples" / slug / f"{name}.{ext}").is_file())
                section_terms = code_terms(body) | code_terms(f"`{embedded.replace('`', ' ')}`")
                if own_terms and section_terms and not own_terms & section_terms:
                    errors.append(f"{tag}: sorudaki kod terimlerinin hiçbiri \"{heading}\" bölümünde geçmiyor -- "
                                  f"soru bu bölüme dayanmıyor olabilir")
            if qtype == "CODE_OUTPUT" and code and code_language and len(correct) == 1 and run_code:
                verify_code_output(item, tag, errors, notes)
            for option in options:
                if CATCH_ALL.search(option):
                    warnings.append(f"{tag}: 'hepsi/hiçbiri' türü şık: \"{option}\"")
            if correct and wrong:
                longest_wrong = max(len(w) for w in wrong)
                if min(len(c) for c in correct) > 1.6 * longest_wrong:
                    warnings.append(f"{tag}: doğru şık yanlışların hepsinden belirgin uzun -- uzunluk ipucu veriyor")
            for body in (question, explanation):
                for match in SECTION_REF.finditer(body):
                    name = norm(match.group(2))
                    if name in own[lang]:
                        continue
                    if name in everything[lang]:
                        warnings.append(f"{tag}: \"{name}\" başka bir dersin başlığı -- kasıtlıysa sorun yok")
                    else:
                        errors.append(f"{tag}: \"{name}\" bölümüne atıf var ama content/{lang}/{slug}.md'de "
                                      f"böyle bir başlık yok (başlık birebir yazılmalı)")
            key = norm(question) + "\x1f" + norm(code or "")
            if key in seen[lang]:
                errors.append(f"{tag}: aynı soru çift {seen[lang][key]}'de de var")
            seen[lang][key] = index + 1
        if pair.get("en") and pair.get("tr") and norm(pair["en"].get("question", "")) == norm(pair["tr"].get("question", "")):
            errors.append(f"{where}: EN ve TR soru metni aynı")
    if types and types["SINGLE_CHOICE"] + types["CODE_OUTPUT"] == 0:
        warnings.append("hiç tek doğrulu soru yok")
    existing = psql("select q.language, q.question, coalesce(q.code_snippet, '') from question q "
                    f"join topic t on t.id = q.topic_id where t.slug = '{slug}'")
    if existing is None:
        warnings.append("veritabanı okunamadı -- konunun mevcut sorularıyla tekrar kontrolü yapılamadı")
    else:
        known = {(lang, norm(q) + "\x1f" + norm(c)) for lang, q, c in existing}
        for lang in LANGS:
            for key, number in seen[lang].items():
                if (lang, key) in known:
                    errors.append(f"çift {number}/{lang}: bu soru konunun havuzunda zaten var")
    return errors, warnings, notes


def position_summary(spec):
    """Dağılım satırları ve dengesizlik notları. Denge yumuşak bir hedeftir: üretimi durdurmaz."""
    lines, remarks = [], []
    for lang in LANGS:
        letters = Counter()
        for index, pair in enumerate(spec["pairs"]):
            for position, (_, is_correct) in enumerate(ordered_options(pair[lang], index, lang)):
                if is_correct:
                    letters["ABCD"[position]] += 1
        lines.append(f"  {lang}: " + "  ".join(f"{letter}={letters[letter]}" for letter in "ABCD"))
        counts = [letters[letter] for letter in "ABCD"]
        if max(counts) - min(counts) > 2:
            remarks.append(f"{lang}: doğru şıklar konumlara dengesiz dağılmış ({lines[-1].strip()})")
    return lines, remarks


def report(spec):
    errors, warnings, notes = check(spec)
    slug = spec.get("topic", "")
    for message in errors:
        print(f"[HATA]  {message}")
    for message in warnings:
        print(f"[UYARI] {message}")
    for message in notes:
        print(f"[BİLGİ] {message}")
    if not errors:
        compute_layout(spec)
        shells = quiz_shell_in_migrations(slug)
        print(f"Quiz shell: {'VAR (' + shells[0].name + ') -- yenisi üretilmeyecek' if shells else 'yok -- üretilecek'}")
        lines, remarks = position_summary(spec)
        print("Doğru şıkların konum dağılımı (yumuşak hedef: dengeli):")
        print("\n".join(lines))
        for remark in remarks:
            print(f"[BİLGİ] {remark}")
    print(f"{len(errors)} hata, {len(warnings)} uyarı")
    return errors


# ----------------------------------------------------------------------------- preview

def preview(spec):
    for index, pair in enumerate(spec["pairs"]):
        print(f"\n=== Çift {index + 1} — {pair.get('concept', '')} ({pair['type']}, {pair['difficulty']}) ===")
        print(f"    bölüm: EN \"{pair['section']['en']}\" / TR \"{pair['section']['tr']}\"")
        for lang in LANGS:
            item = pair[lang]
            print(f"\n[{lang.upper()}] {item['question']}")
            if item.get("code"):
                print("    ```" + item["codeLanguage"])
                print("\n".join("    " + line for line in item["code"].split("\n")))
                print("    ```")
            for position, (text, is_correct) in enumerate(ordered_options(item, index, lang)):
                print(f"   {'✓' if is_correct else ' '} {'ABCD'[position]}) {text}")
            print(f"   Açıklama: {item['explanation']}")


# ---------------------------------------------------------------------------- generate

def dq(text):
    return "NULL" if text is None else f"$${text}$$"


def question_select(slug, lang, pair, item, extra_where=""):
    return (f"    SELECT id, '{lang}', '{pair['type']}', '{pair['difficulty']}', 'PUBLISHED', 'CLAUDE',\n"
            f"           {dq(item['question'])},\n"
            f"           {dq(item.get('code'))}, {dq(item.get('codeLanguage'))},\n"
            f"           {dq(item['explanation'])},\n"
            f"           '{REVIEWER}', now(), now(), now()\n"
            f"    FROM topic\n"
            f"    WHERE slug = '{slug}'{extra_where}\n"
            f"    RETURNING id")


INSERT_QUESTION = ("    INSERT INTO question (topic_id, language, type, difficulty, status, source,\n"
                   "                           question, code_snippet, code_language, explanation,\n"
                   "                           reviewed_by, reviewed_at, created_at, updated_at)\n")


def option_values(item, index, lang):
    rows = [f"        ({dq(text)}, {'TRUE' if ok else 'FALSE'}, {position})"
            for position, (text, ok) in enumerate(ordered_options(item, index, lang))]
    return ",\n".join(rows)


def promote_sql(spec):
    slug, pairs = spec["topic"], spec["pairs"]
    out = [f"-- Promotion batch\n-- Topic: {slug} (language: en x{len(pairs)}, tr x{len(pairs)})\n--\n"
           f"-- Generated by .claude/skills/quiz-questions/build_quiz.py from a hand-authored spec:\n"
           f"-- {len(pairs)} concept pairs, each an EN and an independently written TR question on the\n"
           f"-- same concept, grounded in content/en/{slug}.md and content/tr/{slug}.md. Not produced\n"
           f"-- by n8n and not ingested via /api/internal/questions/ingest, so no dev ids exist.\n"
           f"-- status = 'PUBLISHED', source = 'CLAUDE'. Option order is assigned by the script.\n"]
    for index, pair in enumerate(pairs):
        for lang in LANGS:
            item, cte = pair[lang], f"new_question_{lang}{index + 1}"
            out.append(f"\n-- Pair {index + 1} / {lang.upper()} ({pair['type']}, {pair['difficulty']})\n"
                       f"WITH {cte} AS (\n{INSERT_QUESTION}{question_select(slug, lang, pair, item)}\n)\n"
                       f"INSERT INTO question_option (question_id, option_text, is_correct, sort_order)\n"
                       f"SELECT {cte}.id, v.option_text, v.is_correct, v.sort_order\n"
                       f"FROM {cte}\n"
                       f"         CROSS JOIN (VALUES\n{option_values(item, index, lang)}\n"
                       f"    ) AS v(option_text, is_correct, sort_order);\n")
    return "".join(out)


def shell_sql(slug):
    lines = [f"-- `{slug}` konusunun sabit quiz shell'i (TR+EN) -- soru içermez; sorular bu dosyayı\n"
             f"-- izleyen link migration'larında bağlanır. slug='default', pass_threshold=0.80.\n"]
    for lang in ("tr", "en"):
        lines.append(f"\nINSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)\n"
                     f"SELECT id, '{lang}', 'default', '{QUIZ_TITLES[lang]}', 0.80, true FROM topic WHERE slug = '{slug}';\n")
    return "".join(lines)


def link_sql(spec, lang, start_position):
    slug, pairs = spec["topic"], spec["pairs"]
    out = [f"-- Links the {lang.upper()} {slug} questions to the topic's fixed quiz. Same NOT EXISTS /\n"
           f"-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is\n"
           f"-- found by its text (or created if missing) and linked at its position, so the file is\n"
           f"-- safe on a fresh database and on one where the promotion migration already ran.\n"]
    for index, pair in enumerate(pairs):
        item, n = pair[lang], index + 1
        match = f"      AND question = {dq(item['question'])}"
        if item.get("code"):
            match += f"\n      AND code_snippet = {dq(item['code'])}"
        extra = f"\n      AND NOT EXISTS (SELECT 1 FROM existing_q{n})"
        out.append(
            f"\n-- Question {n}/{len(pairs)} (pair {n} {lang.upper()}, quiz position {start_position + index}, {pair['type']})\n"
            f"WITH existing_q{n} AS (\n"
            f"    SELECT id FROM question\n"
            f"    WHERE topic_id = (SELECT id FROM topic WHERE slug = '{slug}')\n"
            f"      AND language = '{lang}'\n"
            f"      AND status = 'PUBLISHED'\n{match}\n),\n"
            f"inserted_q{n} AS (\n{INSERT_QUESTION}{question_select(slug, lang, pair, item, extra)}\n),\n"
            f"target_q{n} AS (\n"
            f"    SELECT id, TRUE AS newly_inserted FROM inserted_q{n}\n"
            f"    UNION ALL\n"
            f"    SELECT id, FALSE AS newly_inserted FROM existing_q{n}\n),\n"
            f"option_ins_q{n} AS (\n"
            f"    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)\n"
            f"    SELECT target_q{n}.id, v.option_text, v.is_correct, v.sort_order\n"
            f"    FROM target_q{n}\n"
            f"             CROSS JOIN (VALUES\n{option_values(item, index, lang)}\n"
            f"        ) AS v(option_text, is_correct, sort_order)\n"
            f"    WHERE target_q{n}.newly_inserted\n"
            f"    RETURNING 1\n)\n"
            f"INSERT INTO quiz_question_link (quiz_id, question_id, position)\n"
            f"SELECT quiz.id, target_q{n}.id, {start_position + index}\n"
            f"FROM target_q{n}\n"
            f"         JOIN quiz ON TRUE\n"
            f"         JOIN topic t ON t.id = quiz.topic_id\n"
            f"WHERE t.slug = '{slug}'\n"
            f"  AND quiz.language = '{lang}'\n"
            f"  AND quiz.slug = 'default'\n"
            f"ON CONFLICT (quiz_id, question_id) DO NOTHING;\n")
    return "".join(out)


def generate(spec, dry_run):
    slug = spec["topic"]
    under = slug.replace("-", "_")
    version = max(migration_versions()) + 1
    batch = len(list((MIGRATIONS / "question-promotion").glob(f"V*__promote_questions_{slug}-batch-*.sql"))) + 1
    start = {}
    for lang in LANGS:
        rows = psql("select coalesce(max(l.position), 0) from quiz q join topic t on t.id = q.topic_id "
                    f"left join quiz_question_link l on l.quiz_id = q.id where t.slug = '{slug}' and q.language = '{lang}'")
        if rows is None:
            fail("veritabanı okunamadı -- mevcut quiz'in son pozisyonu bilinmeden link migration'ı üretilemez")
        start[lang] = int(rows[0][0]) + 1 if rows else 1
    files = [(MIGRATIONS / "question-promotion" / f"V{version}__promote_questions_{slug}-batch-{batch}.sql", promote_sql(spec))]
    version += 1
    if not quiz_shell_in_migrations(slug):
        files.append((MIGRATIONS / slug / f"V{version}__{under}_quiz_topic.sql", shell_sql(slug)))
        version += 1
    suffix = "" if batch == 1 else f"_batch_{batch}"
    files.append((MIGRATIONS / slug / f"V{version}__link_{under}_quiz_questions{suffix}.sql", link_sql(spec, "en", start["en"])))
    files.append((MIGRATIONS / slug / f"V{version + 1}__link_{under}_quiz_questions{suffix}_tr.sql", link_sql(spec, "tr", start["tr"])))
    for path, sql in files:
        relative = path.relative_to(ROOT)
        if dry_run:
            print(f"--- {relative} ({len(sql.splitlines())} satır)")
            continue
        if path.exists():
            fail(f"{relative} zaten var -- üzerine yazılmadı")
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(sql, encoding="utf-8")
        print(f"yazıldı: {relative}")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("command", choices=("check", "preview", "generate"))
    parser.add_argument("spec")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    spec = json.loads(Path(args.spec).read_text(encoding="utf-8"))
    errors = report(spec)
    if errors:
        return 1
    if args.command == "preview":
        preview(spec)
    elif args.command == "generate":
        generate(spec, args.dry_run)
    return 0


if __name__ == "__main__":
    sys.exit(main())
