#!/usr/bin/env python3
"""
"Expected Output" generator for Java examples -- STAGING ONLY.

Compiles and runs an EXPLICIT list of examples (never "all of them") inside
throwaway, isolated Docker containers and writes each example's raw stdout to
.example-outputs/staging/{slug}/{Name}.out, together with a JSON
metadata file and a human review report (.example-outputs/report.md).
The staging root sits outside target/ on purpose: `mvn clean` (from any session)
must not wipe outputs that are generated but not yet reviewed or promoted. It is
git-ignored, so nothing in it is ever committed.

`generate` never writes to src/: an output only reaches a lesson page after a
human has reviewed it against the Java source and the TR/EN lesson text and it
has been promoted with `promote`, which copies the staged bytes next to the
.java file and records the hashes in scripts/example-outputs/manifest.tsv.

Usage:
    scripts/example_outputs.py generate primitive-parallel-streams/IntStreamCreationExample ...
    scripts/example_outputs.py generate --topic if-else --topic switch [--dry-run]
    scripts/example_outputs.py promote --reviewer NAME primitive-parallel-streams/IntStreamCreationExample ...
    scripts/example_outputs.py promote --reviewer NAME --review .example-outputs/review.tsv
    scripts/example_outputs.py selftest      # proves the sandbox restrictions hold

`--topic SLUG` expands to the .java examples that lesson embeds (TR order, then any
EN-only ones) -- still an explicit list, there is no "all lessons" option. `--dry-run`
prints that list with each example's pre-check result and writes nothing. Examples
without a main method (NO_MAIN), with non-JDK imports (NON_JDK) or that need another
example file of the same lesson to compile (MULTI_FILE) are listed but never run.

Each `generate` merges its results into results.json by slug/Name, so generating one
lesson never drops another lesson's staged, not yet promoted results. It also rewrites
report.md (grouped by lesson) and review.tsv: one row per GENERATED example with an
empty decision. The reviewer's verdict goes into that sheet row by row (approve /
reject); `promote --review` checks the whole sheet first and writes nothing unless
every row is valid and decided and every hash still matches.

Isolation (every example, two containers: compile, then run):
  * image pinned by digest (IMAGE below); the local RepoDigests must match it
    before anything runs, otherwise the script aborts
  * --network none, --read-only root filesystem, small --tmpfs /tmp
  * the ONLY host mounts are one per-example scratch directory under
    .example-outputs/work/: the source dir (read-only) and, for the
    compile step only, an empty classes dir (read-write); the run step mounts
    the classes dir read-only
  * --user 65534:65534 (nobody), --cap-drop ALL, no-new-privileges,
    --pids-limit, --memory/--memory-swap, --cpus
  * separate wall-clock timeouts for compile and run; on timeout the
    container is killed, and it is always force-removed afterwards
  * stdout is capped; the host environment is never passed in
  * stdin is empty (the docker client gets /dev/null, no -i), and the program
    always runs with no command-line arguments

Generation is NOT correctness: a result here only means "this code prints
exactly these bytes, repeatably, in this environment". Every run is repeated
with varied CPU count, ForkJoinPool parallelism, locale, timezone and
identity-hash mode; any difference marks the example NONDETERMINISTIC and no
.out is written. APIs whose output order or format is not fixed by the Java
API contract are only flagged -- deciding is a human review step.
"""

import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXAMPLES = ROOT / "src/main/resources/examples"
CONTENT = ROOT / "src/main/resources/content"
OUT_ROOT = ROOT / ".example-outputs"
WORK = OUT_ROOT / "work"
STAGING = OUT_ROOT / "staging"
SELFTEST_SOURCES = Path(__file__).resolve().parent / "example-outputs/selftest"
MANIFEST = Path(__file__).resolve().parent / "example-outputs/manifest.tsv"
REVIEW_HEADER = "slug\texample\tout_sha256\tdecision\tnote"
REVIEW_DECISIONS = ("approve", "reject")

# eclipse-temurin:21-jdk (Temurin 21.0.12.1, multi-arch index), verified 2026-10-18
# against the registry manifest, the Docker Hub API and docker-library/official-images
# (GitCommit 511f9356dc4d50932a0a5f8cfb0f87ed1aef4f07).
IMAGE_DIGEST = "sha256:23cc5734ff46e776f51ce66eb9ee08444fd47caabec0a95b7eb6e94be2d3696d"
IMAGE = "eclipse-temurin@" + IMAGE_DIGEST

CONTAINER_PREFIX = "lfx-example-"
COMPILE_TIMEOUT_S = 60
RUN_TIMEOUT_S = 15
MAX_STDOUT_BYTES = 64 * 1024
NAME_PATTERN = re.compile(r"^([a-z0-9-]+)/(\w+)$")
TOPIC_PATTERN = re.compile(r"^[a-z0-9-]+$")
JAVA_EMBED = re.compile(r"\{\{(\w+)\.java\}\}")

BASE_JAVA_PROPS = [
    "-Duser.language=en", "-Duser.country=US", "-Duser.timezone=UTC",
    "-Dfile.encoding=UTF-8", "-Dstdout.encoding=UTF-8", "-Dstderr.encoding=UTF-8",
]

# Each variant must print exactly the same bytes as the first one. The first is
# the one whose output would be published.
VARIANTS = [
    ("base-1", "2", []),
    ("base-2", "2", []),
    ("base-3", "2", []),
    ("cpus-1", "1", []),
    ("cpus-4-fj-3", "4", ["-Djava.util.concurrent.ForkJoinPool.common.parallelism=3"]),
    ("fj-1", "2", ["-Djava.util.concurrent.ForkJoinPool.common.parallelism=1"]),
    ("locale-tr", "2", ["-Duser.language=tr", "-Duser.country=TR"]),
    ("tz-istanbul", "2", ["-Duser.timezone=Europe/Istanbul"]),
    ("identity-hash", "2", ["-XX:+UnlockExperimentalVMOptions", "-XX:hashCode=2"]),
]

# Static hints about APIs whose printed result the Java API contract does NOT fix
# (iteration order of hash-based collections, parallel scheduling, time, randomness,
# identity hashes, the outside world). Identical output across every variant run is
# NOT proof of a guarantee -- the pilot showed parallel examples printing the same
# bytes in all 9 runs -- so a BLOCKING flag means no .out is staged at all.
# Informational flags only point the human reviewer at something to double-check.
# Blocking patterns run on the code with comments and string/char literals blanked out
# (strip_comments_and_strings): "System.in" in a comment or in printed text does not make
# the program read stdin. A blocking pattern that matches ONLY there is still reported, as
# the informational "<flag>:text-only". Informational patterns run on the raw source.
CONTRACT_FLAGS = [
    ("hash-order", r"\bHash(Map|Set)\b|Collectors\.(toSet|groupingBy|toMap|partitioningBy)\b|\b(Set|Map)\.of\("),
    ("parallel", r"parallel\(|parallelStream\("),
    ("concurrency", r"\bThread\b|Executor|CompletableFuture"),
    ("time", r"\.now\(|currentTimeMillis|nanoTime"),
    ("random", r"\bRandom\b|Math\.random|UUID\.randomUUID"),
    # Reads standard input: the sandbox gives an empty stdin, so the output would show
    # what the program does WITHOUT the input the lesson describes. new Scanner(String)
    # and other in-memory sources are not flagged.
    ("stdin", r"System\.in\b|System\.console\("),
    # The JVM's default zone / locale / charset / properties describe the machine, not the
    # program. The locale and timezone variant runs may happen not to show a difference.
    ("default-env", r"ZoneId\.systemDefault\(|TimeZone\.getDefault\(|Locale\.getDefault\(|Clock\.systemDefaultZone\("
                    r"|Charset\.defaultCharset\(|System\.getProperty\(|Runtime\.version\(|availableProcessors\("
                    r"|\.ofLocalized(Date|Time|DateTime)\("),
    # Class.getDeclaredFields()/getMethods()/... : "The elements in the returned array are not
    # sorted and are not in any particular order." HotSpot happens to keep declaration order.
    # getRecordComponents(), getEnumConstants() and the single-member lookups
    # (getDeclaredField("x")) have a defined result and are not flagged.
    ("reflection-order", r"\.get(Declared)?(Fields|Methods|Constructors|Classes|Annotations)\(\s*\)"),
    # Informational: the lesson may print what happens when a fail-fast iterator notices a
    # modification. The API only promises that on a best-effort basis.
    ("fail-fast", r"ConcurrentModificationException"),
    ("locale-format", r"String\.format|\.printf\(|\.formatted\(|toUpperCase\(\)|toLowerCase\(\)"),
    ("floating-point-text", r"\bdouble\b|\bfloat\b|Double|average\(\)"),
    ("identity-text", r"hashCode\(\)|Object\.toString"),
    ("io-or-env", r"\bFiles\.|\bPaths\.get\(|\bPath\.of\(|\bjava\.nio\.file\b|\bFileSystems\b"
                  r"|\bnew\s+(File|FileReader|FileWriter|FileInputStream|FileOutputStream|RandomAccessFile)\s*\("
                  r"|Socket|HttpClient|openConnection\(|openStream\(|System\.getenv|ProcessBuilder|Runtime\.getRuntime"),
]
BLOCKING_FLAGS = {"hash-order", "parallel", "concurrency", "time", "random", "stdin", "default-env",
                  "reflection-order", "identity-text", "io-or-env"}
# Informational, set by main_reads_args(): the run always passes no arguments (a fixed,
# repeatable input), so the reviewer checks the output is the branch the lesson shows.
MAIN_ARGS_FLAG = "main-args"
# Shown in report.md and pre-filled as the review.tsv note. A note is never a decision: the
# row's decision stays empty until the reviewer writes approve or reject.
RISK_NOTES = {
    "fail-fast": "RISK fail-fast: Java throws ConcurrentModificationException only on a best-effort basis "
                 "(not guaranteed by the API); approve only if the lesson presents it that way.",
}
TEXT_ONLY_SUFFIX = ":text-only"
RISK_NOTES.update({
    flag + TEXT_ONLY_SUFFIX: f"NOTE {flag}: matched only in a comment or string literal, not in the code; "
                             f"check the output and the lesson text do not depend on it."
    for flag in sorted(BLOCKING_FLAGS)
})


def contract_flags(source: str) -> list:
    code = strip_comments_and_strings(source)
    flags = []
    for flag, pattern in CONTRACT_FLAGS:
        if flag not in BLOCKING_FLAGS:
            if re.search(pattern, source):
                flags.append(flag)
        elif re.search(pattern, code):
            flags.append(flag)
        elif re.search(pattern, source):
            flags.append(flag + TEXT_ONLY_SUFFIX)
    if main_reads_args(source):
        flags.append(MAIN_ARGS_FLAG)
    return flags


MAIN_SIGNATURE = re.compile(
    r"static\s+void\s+main\s*\(\s*(?:final\s+)?String\s*(?:\[\s*\]\s*(\w+)|\.\.\.\s*(\w+)|(\w+)\s*\[\s*\])\s*\)")


def has_main(source: str) -> bool:
    return MAIN_SIGNATURE.search(source) is not None


def main_reads_args(source: str) -> bool:
    """True only when main's OWN parameter is read inside main's body (a local variable
    called args in another method does not count)."""
    match = MAIN_SIGNATURE.search(strip_comments_and_strings(source))
    if not match:
        return False
    param = next(g for g in match.groups() if g)
    body = method_body(strip_comments_and_strings(source), match.end())
    return re.search(r"\b" + re.escape(param) + r"\b", body) is not None


def method_body(source: str, after: int) -> str:
    start = source.find("{", after)
    if start < 0:
        return ""
    depth = 0
    for i in range(start, len(source)):
        if source[i] == "{":
            depth += 1
        elif source[i] == "}":
            depth -= 1
            if depth == 0:
                return source[start + 1:i]
    return source[start + 1:]


def strip_comments_and_strings(source: str) -> str:
    """Blanks out comments, string/text-block and char literals (structure-only analysis)."""
    pattern = re.compile(r'"""[\s\S]*?"""|"(?:\\.|[^"\\\n])*"|\'(?:\\.|[^\'\\\n])*\'|//[^\n]*|/\*[\s\S]*?\*/')
    return pattern.sub(lambda m: " " if not m.group().startswith(('"', "'")) else '""', source)


NON_JDK_IMPORT = re.compile(r"^\s*import\s+(?:static\s+)?(?!java\.|javax\.|jdk\.)[\w.]+", re.MULTILINE)
TOP_LEVEL_TYPE = re.compile(
    r"^(?:(?:public|final|abstract|sealed|non-sealed|strictfp)\s+)*(?:class|record|enum|interface)\s+(\w+)",
    re.MULTILINE)
ANY_TYPE = re.compile(r"\b(?:class|record|enum|interface)\s+(\w+)")


def sibling_dependencies(java_file: Path) -> list:
    """Top-level types declared in OTHER .java files of the same lesson folder that this
    file uses without declaring them itself -- it cannot compile on its own."""
    source = strip_comments_and_strings(java_file.read_text(encoding="utf-8"))
    own = set(ANY_TYPE.findall(source))
    deps = []
    for sibling in sorted(java_file.parent.glob("*.java")):
        if sibling == java_file:
            continue
        for type_name in TOP_LEVEL_TYPE.findall(strip_comments_and_strings(sibling.read_text(encoding="utf-8"))):
            if type_name not in own and type_name not in deps and re.search(r"\b" + type_name + r"\b", source):
                deps.append(type_name)
    return deps


def precheck(slug: str, name: str) -> dict:
    """Static checks that decide, without running anything, whether an example can be run."""
    java_file = EXAMPLES / slug / f"{name}.java"
    if not java_file.is_file():
        return {"status": "MISSING_SOURCE"}
    source = java_file.read_text(encoding="utf-8")
    result = {"status": None, "flags": contract_flags(source)}
    if not has_main(source):
        result["status"] = "NO_MAIN"
    elif NON_JDK_IMPORT.search(source):
        result["status"] = "NON_JDK"
    else:
        deps = sibling_dependencies(java_file)
        if deps:
            result["status"] = "MULTI_FILE"
            result["depends_on"] = deps
    return result


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def verify_image() -> str:
    """Abort unless the pinned image is present locally with exactly the pinned digest."""
    result = subprocess.run(
        ["docker", "image", "inspect", IMAGE, "--format", "{{json .RepoDigests}}"],
        capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"ABORT: image {IMAGE} is not available locally (pull it explicitly first).")
    digests = json.loads(result.stdout.strip())
    if not any(d.endswith("@" + IMAGE_DIGEST) for d in digests):
        sys.exit(f"ABORT: local image digests {digests} do not match the pinned {IMAGE_DIGEST}.")
    name = f"{CONTAINER_PREFIX}{uuid.uuid4().hex[:12]}-version"
    version = run_container(docker_args(name, cpus="1"), ["java", "-version"], COMPILE_TIMEOUT_S, name)
    if version["exit"] != 0:
        sys.exit("ABORT: 'java -version' failed inside the sandbox.")
    return version["stderr"].decode("utf-8").strip()


def cleanup_leftover_containers():
    """Remove containers left behind by an interrupted earlier run (only our own prefix)."""
    names = subprocess.run(
        ["docker", "ps", "-a", "--filter", f"name=^{CONTAINER_PREFIX}", "--format", "{{.Names}}"],
        capture_output=True, text=True).stdout.split()
    for name in names:
        if name.startswith(CONTAINER_PREFIX):
            subprocess.run(["docker", "rm", "-f", name], capture_output=True)


def docker_args(name: str, cpus: str, mounts=()) -> list:
    args = [
        "docker", "run", "--rm", "--name", name,
        "--network", "none",
        "--read-only", "--tmpfs", "/tmp:rw,nosuid,nodev,size=16m",
        "--user", "65534:65534",
        "--cap-drop", "ALL", "--security-opt", "no-new-privileges",
        "--pids-limit", "128",
        "--memory", "512m", "--memory-swap", "512m",
        "--cpus", cpus,
        "--workdir", "/tmp",
    ]
    for host, container, mode in mounts:
        args += ["-v", f"{host}:{container}:{mode}"]
    return args


def run_container(args_before_image: list, command: list, timeout_s: int, name: str) -> dict:
    """Run one container; kill it on timeout; always force-remove it afterwards."""
    process = subprocess.Popen(args_before_image + [IMAGE] + command, stdin=subprocess.DEVNULL,
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    timed_out = False
    try:
        stdout, stderr = process.communicate(timeout=timeout_s)
    except subprocess.TimeoutExpired:
        timed_out = True
        subprocess.run(["docker", "kill", name], capture_output=True)
        stdout, stderr = process.communicate()
    finally:
        subprocess.run(["docker", "rm", "-f", name], capture_output=True)
    return {"exit": process.returncode, "stdout": stdout, "stderr": stderr, "timed_out": timed_out}


def capped(stdout: bytes) -> tuple:
    return stdout[:MAX_STDOUT_BYTES], len(stdout) > MAX_STDOUT_BYTES


def compile_example(java_file: Path, work_dir: Path) -> dict:
    src = work_dir / "src"
    classes = work_dir / "classes"
    if work_dir.exists():
        shutil.rmtree(work_dir)
    src.mkdir(parents=True)
    classes.mkdir()
    classes.chmod(0o777)  # writable by the container's "nobody" user
    shutil.copy2(java_file, src / java_file.name)
    name = f"{CONTAINER_PREFIX}{uuid.uuid4().hex[:12]}-compile"
    result = run_container(
        docker_args(name, cpus="2", mounts=[(src, "/src", "ro"), (classes, "/classes", "rw")]),
        ["javac", "-J-Xmx256m", "-J-XX:-UsePerfData", "-encoding", "UTF-8", "-d", "/classes",
         "/src/" + java_file.name],
        COMPILE_TIMEOUT_S, name)
    result["classes"] = classes
    return result


def run_variant(main_class: str, classes: Path, cpus: str, extra_props: list) -> dict:
    name = f"{CONTAINER_PREFIX}{uuid.uuid4().hex[:12]}-run"
    props = BASE_JAVA_PROPS + extra_props
    result = run_container(
        docker_args(name, cpus=cpus, mounts=[(classes, "/classes", "ro")]),
        # JVM unified-logging warnings go to stdout by default; send them to stderr so
        # they can never end up inside a published output (they fail the run instead).
        ["java", "-Xmx256m", "-XX:-UsePerfData", "-Xlog:disable", "-Xlog:all=warning:stderr"]
        + props + ["-cp", "/classes", main_class],
        RUN_TIMEOUT_S, name)
    result["stdout"], result["truncated"] = capped(result["stdout"])
    return result


def stdout_problems(stdout: bytes) -> list:
    problems = []
    try:
        text = stdout.decode("utf-8")
    except UnicodeDecodeError:
        return ["stdout is not valid UTF-8"]
    if not text:
        problems.append("stdout is empty")
    if "\r" in text:
        problems.append("stdout contains \\r")
    if re.search(r"[\x00-\x08\x0b-\x1f\x7f]", text.replace("\r", "")):
        problems.append("stdout contains control characters")
    return problems


def lesson_context(slug: str, name: str) -> dict:
    """The paragraphs right before and after each {{Name.java}} embed, per language."""
    context = {}
    for lang in ("tr", "en"):
        path = CONTENT / lang / f"{slug}.md"
        if not path.exists():
            continue
        lines = path.read_text(encoding="utf-8").split("\n")
        for i, line in enumerate(lines):
            if line.strip() == "{{" + name + ".java}}":
                context[lang] = {
                    "file": str(path.relative_to(ROOT)),
                    "line": i + 1,
                    "before": paragraph(lines, i - 1, -1),
                    "after": paragraph(lines, i + 1, +1),
                }
    return context


def paragraph(lines: list, start: int, step: int) -> str:
    i = start
    while 0 <= i < len(lines) and not lines[i].strip():
        i += step
    collected = []
    while 0 <= i < len(lines) and lines[i].strip():
        collected.append(lines[i])
        i += step
    return "\n".join(reversed(collected) if step < 0 else collected)


def generate_one(spec: str, jdk_version: str) -> dict:
    slug, name = NAME_PATTERN.match(spec).groups()
    java_file = EXAMPLES / slug / f"{name}.java"
    record = {"slug": slug, "name": name, "java": str(java_file.relative_to(ROOT))}
    pre = precheck(slug, name)
    if pre["status"] == "MISSING_SOURCE":
        record.update(status="MISSING_SOURCE")
        return record

    source_bytes = java_file.read_bytes()
    record["java_sha256"] = sha256(source_bytes)
    record["flags"] = pre["flags"]
    record["context"] = lesson_context(slug, name)
    if pre["status"]:  # NO_MAIN / NON_JDK / MULTI_FILE: listed, never compiled or run
        record["status"] = pre["status"]
        if "depends_on" in pre:
            record["depends_on"] = pre["depends_on"]
        return record

    compiled = compile_example(java_file, WORK / f"{slug}__{name}")
    record["compile"] = {"exit": compiled["exit"], "timed_out": compiled["timed_out"],
                         "stderr": compiled["stderr"].decode("utf-8", "replace")}
    if compiled["timed_out"] or compiled["exit"] != 0:
        record["status"] = "COMPILE_TIMEOUT" if compiled["timed_out"] else "COMPILE_ERROR"
        return record

    runs = []
    for label, cpus, extra in VARIANTS:
        result = run_variant(name, compiled["classes"], cpus, extra)
        runs.append({"variant": label, "exit": result["exit"], "timed_out": result["timed_out"],
                     "truncated": result["truncated"], "stdout_sha256": sha256(result["stdout"]),
                     "stdout": result["stdout"].decode("utf-8", "replace"),
                     "stderr": result["stderr"].decode("utf-8", "replace")})
        if result["timed_out"] or result["exit"] != 0:
            break
    record["runs"] = runs
    first = runs[0]

    if any(r["timed_out"] for r in runs):
        record["status"] = "RUN_TIMEOUT"
    elif any(r["exit"] != 0 for r in runs):
        record["status"] = "RUN_ERROR"
    elif any(r["stderr"] for r in runs):
        record["status"] = "STDERR_NOT_EMPTY"
    elif any(r["truncated"] for r in runs):
        record["status"] = "OUTPUT_TOO_LARGE"
    elif len({r["stdout_sha256"] for r in runs}) > 1:
        record["status"] = "NONDETERMINISTIC"
    elif BLOCKING_FLAGS.intersection(record["flags"]):
        record["status"] = "CONTRACT_BLOCKED"
    elif stdout_problems(first["stdout"].encode("utf-8")):
        record["status"] = "INVALID_STDOUT"
        record["problems"] = stdout_problems(first["stdout"].encode("utf-8"))
    else:
        record["status"] = "GENERATED"
        stdout_bytes = first["stdout"].encode("utf-8")
        target_dir = STAGING / slug
        target_dir.mkdir(parents=True, exist_ok=True)
        out_file = target_dir / f"{name}.out"
        out_file.write_bytes(stdout_bytes)
        written = out_file.read_bytes()
        record["out"] = str(out_file.relative_to(ROOT))
        record["out_sha256"] = sha256(written)
        record["out_matches_raw_stdout"] = written == stdout_bytes and sha256(written) == first["stdout_sha256"]
    record["jdk"] = {"image": IMAGE, "version": jdk_version}
    return record


class ReviewError(Exception):
    """A problem in review.tsv or in a promotion plan; nothing has been written."""


def record_key(record: dict) -> str:
    return f"{record['slug']}/{record['name']}"


def fence_for(text: str, info: str = "") -> tuple:
    longest = max((len(m) for m in re.findall(r"`+", text)), default=0)
    fence = "`" * max(3, longest + 1)
    return fence + info, fence


def visible_stdout(stdout: str) -> list:
    """Raw stdout with `·` for each trailing space and `⏎` at each line end."""
    lines = []
    for out_line in stdout.split("\n"):
        stripped = out_line.rstrip(" ")
        lines.append(stripped + "·" * (len(out_line) - len(stripped)) + "⏎")
    if stdout.endswith("\n"):
        lines.pop()  # the last "⏎" already marks the final line terminator
    else:
        lines[-1] = lines[-1][:-1] + "  (no final line terminator)"
    return lines


def flag_text(flags: list) -> str:
    return ", ".join(f"`{f}`" + (" (blocking)" if f in BLOCKING_FLAGS else "") for f in flags)


def write_report(records: list, jdk_version: str):
    """report.md, one section per lesson: GENERATED examples in full (source, raw stdout,
    lesson context) first, then everything that was blocked or not run."""
    lines = ["# Expected Output -- staging review report", "",
             f"Generated: {datetime.now(timezone.utc).isoformat(timespec='seconds')}",
             f"Image: `{IMAGE}`", "", "```", jdk_version, "```", "",
             "**Nothing in this report is reviewed or published.** A GENERATED output only means the",
             "code printed the same bytes in every variant run -- that is NOT proof that the output is",
             "fixed by the Java API contract or correct for the lesson. Every program ran with no",
             "command-line arguments and an empty stdin. Decide per example in `review.tsv`.", ""]
    slugs = list(dict.fromkeys(r["slug"] for r in records))
    for slug in slugs:
        lesson = [r for r in records if r["slug"] == slug]
        generated = [r for r in lesson if r["status"] == "GENERATED"]
        others = [r for r in lesson if r["status"] != "GENERATED"]
        lines += [f"## {slug} -- {len(generated)} generated, {len(others)} blocked or not run", ""]
        for r in generated:
            source = (ROOT / r["java"]).read_text(encoding="utf-8") if (ROOT / r["java"]).is_file() else ""
            opening, closing = fence_for(source, "java")
            lines += [f"### {r['name']} -- GENERATED", "",
                      f"Source: `{r['java']}` (sha256 `{r['java_sha256']}`)"]
            if r.get("flags"):
                lines.append("Review flags: " + flag_text(r["flags"]))
            for flag in r.get("flags", []):
                if flag in RISK_NOTES:
                    lines.append(f"**{RISK_NOTES[flag]}**")
            lines += [f"Runs: {len(r['runs'])}/{len(VARIANTS)} variants printed identical bytes; staged "
                      f"`{r['out']}` (sha256 `{r['out_sha256']}`, bytes equal raw stdout: "
                      f"{r['out_matches_raw_stdout']})", "", opening, source.rstrip("\n"), closing, "",
                      "Raw stdout (`⏎` = end of line, `·` = trailing space):", "```"]
            lines += visible_stdout(r["runs"][0]["stdout"]) + ["```"]
            for lang in ("tr", "en"):
                c = r.get("context", {}).get(lang)
                if c:
                    lines += ["", f"**{lang.upper()}** `{c['file']}:{c['line']}` -- before:", "",
                              "> " + c["before"].replace("\n", "\n> "), "", "after:", "",
                              "> " + c["after"].replace("\n", "\n> ")]
            lines.append("")
        if others:
            lines += ["### Blocked or not run", ""]
        for r in others:
            detail = [f"- **{r['name']}** -- {r['status']}"]
            if r.get("flags"):
                detail.append("flags: " + flag_text(r["flags"]))
            if r.get("depends_on"):
                detail.append("needs: " + ", ".join(f"`{d}`" for d in r["depends_on"]))
            if r.get("error"):
                detail.append("error: " + r["error"])
            lines.append("; ".join(detail))
            if r.get("compile", {}).get("stderr"):
                lines += ["  ```", "  " + r["compile"]["stderr"].rstrip().replace("\n", "\n  "), "  ```"]
            runs = r.get("runs", [])
            for run in runs:
                if run["timed_out"] or run["exit"] != 0 or run["stderr"] or run["truncated"]:
                    lines.append(f"  - run `{run['variant']}`: exit {run['exit']}"
                                 + (", TIMEOUT" if run["timed_out"] else "")
                                 + (", TRUNCATED" if run["truncated"] else "")
                                 + (", stderr: " + run["stderr"].strip()[:300] if run["stderr"] else ""))
            distinct = {}
            for run in runs:
                distinct.setdefault(run["stdout"], []).append(run["variant"])
            if r["status"] in ("NONDETERMINISTIC", "CONTRACT_BLOCKED", "INVALID_STDOUT"):
                for stdout, variants in distinct.items():
                    lines += [f"  stdout of {', '.join(f'`{v}`' for v in variants)}:", "  ```"]
                    lines += ["  " + line for line in visible_stdout(stdout)] + ["  ```"]
        lines.append("")
    (OUT_ROOT / "report.md").write_text("\n".join(lines), encoding="utf-8")


def topic_specs(slug: str) -> list:
    """The .java examples a lesson embeds: TR order first, then any EN-only ones."""
    if not TOPIC_PATTERN.match(slug):
        raise ReviewError(f"'{slug}' is not a lesson slug.")
    names, found = [], False
    for lang in ("tr", "en"):
        path = CONTENT / lang / f"{slug}.md"
        if path.is_file():
            found = True
            for name in JAVA_EMBED.findall(path.read_text(encoding="utf-8")):
                if name not in names:
                    names.append(name)
    if not found:
        raise ReviewError(f"unknown lesson '{slug}': no content/tr or content/en/{slug}.md")
    return [f"{slug}/{name}" for name in names]


def expand_specs(specs: list, topics: list) -> list:
    """Explicit slug/Name entries plus every --topic expansion, in order, without duplicates."""
    for spec in specs:
        if not NAME_PATTERN.match(spec):
            raise ReviewError(f"'{spec}' is not an explicit slug/ExampleName entry.")
    expanded = list(specs)
    for slug in topics:
        expanded += topic_specs(slug)
    expanded = list(dict.fromkeys(expanded))
    if not expanded:
        raise ReviewError("nothing to do: give slug/ExampleName entries or --topic SLUG.")
    return expanded


def load_results() -> list:
    path = OUT_ROOT / "results.json"
    return json.loads(path.read_text(encoding="utf-8")) if path.exists() else []


def save_results(records: list) -> list:
    """Merges this run's records into results.json by slug/Name (a rerun replaces that
    example's entry in place; other lessons' entries stay). A staged .out whose example is
    no longer GENERATED is removed, so it can never be promoted."""
    merged = {record_key(r): r for r in load_results()}
    for record in records:
        if record.get("status") != "GENERATED":
            stale = STAGING / record["slug"] / f"{record['name']}.out"
            if stale.exists():
                stale.unlink()
        merged[record_key(record)] = record
    OUT_ROOT.mkdir(parents=True, exist_ok=True)
    results = list(merged.values())
    (OUT_ROOT / "results.json").write_text(json.dumps(results, indent=2, ensure_ascii=False), encoding="utf-8")
    return results


def read_review_sheet(path: Path, require_decisions: bool = True) -> list:
    """Parses review.tsv strictly. Raises ReviewError listing every problem found."""
    if not path.is_file():
        raise ReviewError(f"{path} does not exist.")
    lines = path.read_text(encoding="utf-8").split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    if not lines or lines[0] != REVIEW_HEADER:
        raise ReviewError(f"{path.name}: the first line must be exactly the header {REVIEW_HEADER!r}.")
    rows, problems, seen = [], [], set()
    for number, line in enumerate(lines[1:], start=2):
        cols = line.split("\t")
        if len(cols) != 5:
            problems.append(f"line {number}: expected 5 tab-separated columns, found {len(cols)}")
            continue
        slug, name, out_sha, decision, note = cols
        key = f"{slug}/{name}"
        if not NAME_PATTERN.match(key):
            problems.append(f"line {number}: '{key}' is not a slug/ExampleName entry")
            continue
        if key in seen:
            problems.append(f"line {number}: {key} appears more than once")
            continue
        seen.add(key)
        if not re.fullmatch(r"[0-9a-f]{64}", out_sha):
            problems.append(f"line {number}: {key}: out_sha256 is not a sha256 hex digest")
        if decision == "" and require_decisions:
            problems.append(f"line {number}: {key}: no decision (approve or reject)")
        elif decision and decision not in REVIEW_DECISIONS:
            problems.append(f"line {number}: {key}: invalid decision '{decision}' (approve or reject)")
        rows.append({"key": key, "slug": slug, "name": name, "out_sha256": out_sha,
                     "decision": decision, "note": note})
    if problems:
        raise ReviewError("\n".join(problems))
    return rows


def read_review_sheet_unchecked(path: Path) -> list:
    """Same strict format checks, but undecided rows are allowed (a sheet still being filled)."""
    return read_review_sheet(path, require_decisions=False)


def write_review_sheet(records: list):
    """review.tsv: one row per GENERATED example. A decision already in the sheet is kept
    only while the row's out_sha256 still matches -- a regenerated output is decided again."""
    path = OUT_ROOT / "review.tsv"
    previous = {}
    if path.exists():
        for line in path.read_text(encoding="utf-8").split("\n")[1:]:
            cols = line.split("\t")
            if len(cols) == 5:
                previous[(f"{cols[0]}/{cols[1]}", cols[2])] = (cols[3], cols[4])
    lines = [REVIEW_HEADER]
    for r in records:
        if r.get("status") == "GENERATED":
            risk = " ".join(RISK_NOTES[f] for f in r.get("flags", []) if f in RISK_NOTES)
            decision, note = previous.get((record_key(r), r["out_sha256"]), ("", risk))
            lines.append("\t".join([r["slug"], r["name"], r["out_sha256"], decision, note]))
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def plan_promotion(key: str, record, manifest_keys: set, expected_out_sha=None) -> tuple:
    """Every check for one promotion; raises ReviewError, writes nothing."""
    if record is None or record.get("status") != "GENERATED":
        raise ReviewError(f"{key} is not GENERATED in results.json "
                          f"(status = {record.get('status') if record else 'missing'}).")
    slug, name = record["slug"], record["name"]
    java_file = EXAMPLES / slug / f"{name}.java"
    staged = STAGING / slug / f"{name}.out"
    target = EXAMPLES / slug / f"{name}.out"
    if not java_file.is_file() or sha256(java_file.read_bytes()) != record["java_sha256"]:
        raise ReviewError(f"{key}: the .java changed after generation -- regenerate and review again.")
    if not staged.is_file():
        raise ReviewError(f"{key}: the staged .out is missing.")
    data = staged.read_bytes()
    if sha256(data) != record["out_sha256"] or sha256(data) != record["runs"][0]["stdout_sha256"]:
        raise ReviewError(f"{key}: the staged .out no longer matches the reviewed stdout.")
    if expected_out_sha is not None and expected_out_sha != record["out_sha256"]:
        raise ReviewError(f"{key}: review.tsv out_sha256 does not match the generated output -- review it again.")
    if target.exists() or key in manifest_keys:
        raise ReviewError(f"{key} is already promoted.")
    return key, slug, name, record, data, target


def write_promotions(planned: list, reviewer: str):
    """Writes the .out files and the manifest rows; on any failure removes what it wrote and
    restores the manifest, so a promotion is applied completely or not at all."""
    manifest_before = MANIFEST.read_bytes()
    manifest_lines = manifest_before.decode("utf-8").splitlines()
    reviewed_at = datetime.now(timezone.utc).date().isoformat()
    written, rows = [], []
    try:
        for key, slug, name, record, data, target in planned:
            target.write_bytes(data)
            written.append(target)
            if target.read_bytes() != data:
                raise ReviewError(f"{key}: the written .out differs from the staged bytes.")
            note = "flags: " + ",".join(record["flags"]) if record["flags"] else ""
            rows.append("\t".join([slug, name, record["java_sha256"], sha256(data), record["jdk"]["image"],
                                   "generated", "approved", reviewer, reviewed_at, note]))
        MANIFEST.write_text("\n".join(manifest_lines + rows) + "\n", encoding="utf-8")
    except BaseException:
        for target in written:
            target.unlink(missing_ok=True)
        MANIFEST.write_bytes(manifest_before)
        raise
    for key, *_, target in planned:
        print(f"PROMOTED {key} -> {target.relative_to(ROOT)}")


def check_reviewer(reviewer: str):
    if not reviewer.strip() or "\t" in reviewer or "\n" in reviewer:
        raise ReviewError("--reviewer must be a non-empty name without tabs.")


def manifest_keys() -> set:
    return {"/".join(line.split("\t")[:2])
            for line in MANIFEST.read_text(encoding="utf-8").splitlines()[1:] if line.strip()}


def describe(spec: str) -> str:
    """One --dry-run line: what generate would do with this example, without running it."""
    slug, name = NAME_PATTERN.match(spec).groups()
    pre = precheck(slug, name)
    flags = pre.get("flags", [])
    blocking = [f for f in flags if f in BLOCKING_FLAGS]
    if pre["status"]:
        verdict = pre["status"] + (f" (needs {', '.join(pre['depends_on'])})" if pre.get("depends_on") else "")
    elif blocking:
        verdict = "WILL_BE_BLOCKED (" + ", ".join(blocking) + ")"
    else:
        verdict = "WILL_RUN"
    info = [f for f in flags if f not in BLOCKING_FLAGS]
    return f"{verdict:42} {spec}" + (f"  [review: {', '.join(info)}]" if info else "")


def cmd_generate(specs: list, topics: list = (), dry_run: bool = False):
    try:
        expanded = expand_specs(specs, list(topics))
        if not dry_run and (OUT_ROOT / "review.tsv").exists():
            read_review_sheet_lenient(OUT_ROOT / "review.tsv")
    except ReviewError as e:
        sys.exit(f"ABORT: {e}")
    if dry_run:
        lines = [describe(spec) for spec in expanded]
        print("\n".join(lines))
        verdicts = [line.split()[0] for line in lines]
        print("\n" + ", ".join(f"{v}: {verdicts.count(v)}" for v in dict.fromkeys(verdicts))
              + f" -- {len(lines)} examples, nothing was run or written.")
        return
    cleanup_leftover_containers()
    jdk_version = verify_image()
    records = []
    try:
        for spec in expanded:
            try:
                record = generate_one(spec, jdk_version)
            except Exception as e:  # one failing example never stops the others
                slug, name = NAME_PATTERN.match(spec).groups()
                record = {"slug": slug, "name": name, "java": spec, "status": "TOOL_ERROR", "error": repr(e)}
            records.append(record)
            print(f"{record['status']:18} {spec}")
    finally:
        cleanup_leftover_containers()
    results = save_results(records)
    write_report(results, jdk_version)
    write_review_sheet(results)
    print(f"report: {(OUT_ROOT / 'report.md').relative_to(ROOT)}")
    print(f"review: {(OUT_ROOT / 'review.tsv').relative_to(ROOT)}")


def read_review_sheet_lenient(path: Path):
    """Before a run overwrites review.tsv, make sure the existing one is a sheet this tool
    wrote (decisions may still be empty) -- a damaged sheet must not be silently replaced."""
    lines = path.read_text(encoding="utf-8").split("\n")
    if not lines or lines[0] != REVIEW_HEADER or any(len(l.split("\t")) != 5 for l in lines[1:] if l):
        raise ReviewError(f"{path} is not a valid review sheet; fix or remove it before generating.")


def cmd_promote(specs: list, reviewer: str):
    """Copies reviewed, staged outputs into src/ and records them as approved in the manifest.

    Only explicit entries, and all-or-nothing: every check runs before anything is written.
    """
    try:
        for spec in specs:
            if not NAME_PATTERN.match(spec):
                raise ReviewError(f"'{spec}' is not an explicit slug/ExampleName entry.")
        check_reviewer(reviewer)
        records = {record_key(r): r for r in load_results()}
        keys = manifest_keys()
        planned = [plan_promotion(spec, records.get(spec), keys) for spec in dict.fromkeys(specs)]
        write_promotions(planned, reviewer)
    except ReviewError as e:
        sys.exit(f"ABORT: {e}")


def cmd_promote_review(sheet: Path, reviewer: str):
    """Promotes the approve rows of a fully decided review sheet. The whole sheet is
    validated first (format, duplicates, unknown examples, decisions, hashes); any problem
    aborts before a single file is written. reject rows are only reported."""
    try:
        check_reviewer(reviewer)
        rows = read_review_sheet(sheet)
        records = {record_key(r): r for r in load_results()}
        keys = manifest_keys()
        problems, planned = [], []
        for row in rows:
            record = records.get(row["key"])
            if record is None or record.get("status") != "GENERATED":
                problems.append(f"{row['key']}: not a GENERATED example in results.json")
            elif row["out_sha256"] != record["out_sha256"]:
                problems.append(f"{row['key']}: review.tsv out_sha256 does not match the generated output "
                                f"-- review it again.")
            elif row["decision"] == "approve":
                try:
                    planned.append(plan_promotion(row["key"], record, keys, row["out_sha256"]))
                except ReviewError as e:
                    problems.append(str(e))
        if problems:
            raise ReviewError("\n".join(problems))
        rejected = [row for row in rows if row["decision"] == "reject"]
        if planned:
            write_promotions(planned, reviewer)
        else:
            print("Nothing approved -- nothing written.")
        for row in rejected:
            print(f"REJECTED {row['key']}" + (f" -- {row['note']}" if row["note"] else ""))
    except ReviewError as e:
        sys.exit(f"ABORT: {e}")


def cmd_selftest():
    """Runs probe programs under exactly the same container settings and checks each restriction."""
    cleanup_leftover_containers()
    verify_image()
    expectations = {
        "NetworkProbe": "network: blocked",
        "FilesystemProbe": "filesystem: ok",
        "IdentityProbe": "identity: ok",
        "ThreadLimitProbe": "threads: limited",
        "StdinProbe": "stdin: empty",
    }
    failures = 0
    try:
        for probe, expected in expectations.items():
            compiled = compile_example(SELFTEST_SOURCES / f"{probe}.java", WORK / f"selftest__{probe}")
            result = run_variant(probe, compiled["classes"], "2", [])
            text = result["stdout"].decode("utf-8", "replace").strip()
            ok = result["exit"] == 0 and text.endswith(expected)
            failures += not ok
            print(f"{'PASS' if ok else 'FAIL'} {probe}: {text}")
        for probe, check in [("InfiniteLoopProbe", lambda r: r["timed_out"]),
                             ("FloodProbe", lambda r: r["truncated"] and not r["timed_out"]),
                             ("MemoryProbe", lambda r: r["exit"] != 0 and not r["timed_out"])]:
            compiled = compile_example(SELFTEST_SOURCES / f"{probe}.java", WORK / f"selftest__{probe}")
            result = run_variant(probe, compiled["classes"], "2", [])
            ok = check(result)
            failures += not ok
            print(f"{'PASS' if ok else 'FAIL'} {probe}: exit={result['exit']} timed_out={result['timed_out']} "
                  f"truncated={result['truncated']} stdout_bytes={len(result['stdout'])}")
    finally:
        cleanup_leftover_containers()
    leftovers = subprocess.run(["docker", "ps", "-a", "--filter", f"name=^{CONTAINER_PREFIX}", "-q"],
                               capture_output=True, text=True).stdout.split()
    print(f"{'PASS' if not leftovers else 'FAIL'} no leftover containers ({len(leftovers)})")
    failures += bool(leftovers)
    sys.exit(1 if failures else 0)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    sub = parser.add_subparsers(dest="command", required=True)
    generate = sub.add_parser("generate", help="generate staged outputs for explicit slug/Name entries")
    generate.add_argument("examples", nargs="*")
    generate.add_argument("--topic", action="append", default=[],
                          help="add every .java example this lesson embeds (repeatable)")
    generate.add_argument("--dry-run", action="store_true", help="list what would run; run and write nothing")
    promote = sub.add_parser("promote", help="publish reviewed staged outputs")
    promote.add_argument("--reviewer", required=True)
    promote.add_argument("--review", type=Path, help="a fully decided review.tsv (instead of explicit entries)")
    promote.add_argument("examples", nargs="*")
    sub.add_parser("selftest", help="verify the sandbox restrictions with probe programs")
    args = parser.parse_args()
    if args.command == "generate":
        cmd_generate(args.examples, args.topic, args.dry_run)
    elif args.command == "promote":
        if bool(args.review) == bool(args.examples):
            parser.error("promote takes either --review FILE or explicit slug/Name entries, not both or neither")
        if args.review:
            cmd_promote_review(args.review, args.reviewer)
        else:
            cmd_promote(args.examples, args.reviewer)
    else:
        cmd_selftest()


if __name__ == "__main__":
    main()
