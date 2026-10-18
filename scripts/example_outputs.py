#!/usr/bin/env python3
"""
"Expected Output" generator for Java examples -- STAGING ONLY.

Compiles and runs an EXPLICIT list of examples (never "all of them") inside
throwaway, isolated Docker containers and writes each example's raw stdout to
target/example-outputs/staging/{slug}/{Name}.out, together with a JSON
metadata file and a human review report (target/example-outputs/report.md).

`generate` never writes to src/: an output only reaches a lesson page after a
human has reviewed it against the Java source and the TR/EN lesson text and it
has been promoted with `promote`, which copies the staged bytes next to the
.java file and records the hashes in scripts/example-outputs/manifest.tsv.

Usage:
    scripts/example_outputs.py generate primitive-parallel-streams/IntStreamCreationExample ...
    scripts/example_outputs.py promote --reviewer NAME primitive-parallel-streams/IntStreamCreationExample ...
    scripts/example_outputs.py selftest      # proves the sandbox restrictions hold

Isolation (every example, two containers: compile, then run):
  * image pinned by digest (IMAGE below); the local RepoDigests must match it
    before anything runs, otherwise the script aborts
  * --network none, --read-only root filesystem, small --tmpfs /tmp
  * the ONLY host mounts are one per-example scratch directory under
    target/example-outputs/work/: the source dir (read-only) and, for the
    compile step only, an empty classes dir (read-write); the run step mounts
    the classes dir read-only
  * --user 65534:65534 (nobody), --cap-drop ALL, no-new-privileges,
    --pids-limit, --memory/--memory-swap, --cpus
  * separate wall-clock timeouts for compile and run; on timeout the
    container is killed, and it is always force-removed afterwards
  * stdout is capped; the host environment is never passed in

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
OUT_ROOT = ROOT / "target/example-outputs"
WORK = OUT_ROOT / "work"
STAGING = OUT_ROOT / "staging"
SELFTEST_SOURCES = Path(__file__).resolve().parent / "example-outputs/selftest"
MANIFEST = Path(__file__).resolve().parent / "example-outputs/manifest.tsv"

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
CONTRACT_FLAGS = [
    ("hash-order", r"\bHash(Map|Set)\b|Collectors\.(toSet|groupingBy|toMap|partitioningBy)\b|\b(Set|Map)\.of\("),
    ("parallel", r"parallel\(|parallelStream\("),
    ("concurrency", r"\bThread\b|Executor|CompletableFuture"),
    ("time", r"\.now\(|currentTimeMillis|nanoTime"),
    ("random", r"\bRandom\b|Math\.random|UUID\.randomUUID"),
    ("locale-format", r"String\.format|\.printf\(|\.formatted\(|toUpperCase\(\)|toLowerCase\(\)"),
    ("floating-point-text", r"\bdouble\b|\bfloat\b|Double|average\(\)"),
    ("identity-text", r"hashCode\(\)|Object\.toString"),
    ("io-or-env", r"\bFiles\.|new File\(|Socket|HttpClient|System\.getenv|ProcessBuilder|Runtime\.getRuntime"),
]
BLOCKING_FLAGS = {"hash-order", "parallel", "concurrency", "time", "random", "identity-text", "io-or-env"}


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
    process = subprocess.Popen(args_before_image + [IMAGE] + command,
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
    if not java_file.is_file():
        record.update(status="MISSING_SOURCE")
        return record

    source_bytes = java_file.read_bytes()
    source = source_bytes.decode("utf-8")
    record["java_sha256"] = sha256(source_bytes)
    record["flags"] = [flag for flag, pattern in CONTRACT_FLAGS if re.search(pattern, source)]
    record["context"] = lesson_context(slug, name)

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


def write_report(records: list, jdk_version: str):
    lines = ["# Expected Output -- staging review report", "",
             f"Generated: {datetime.now(timezone.utc).isoformat(timespec='seconds')}",
             f"Image: `{IMAGE}`", "", "```", jdk_version, "```", "",
             "**Nothing in this report is reviewed or published.** A GENERATED output only means the",
             "code printed the same bytes in every variant run.", ""]
    for r in records:
        lines += [f"## {r['slug']}/{r['name']} -- {r['status']}", "", f"Source: `{r['java']}`"]
        if "java_sha256" in r:
            lines.append(f"java sha256: `{r['java_sha256']}`")
        if r.get("flags"):
            lines.append("Contract review flags: " + ", ".join(
                f"`{f}`" + (" (blocking)" if f in BLOCKING_FLAGS else "") for f in r["flags"]))
        if "compile" in r:
            lines.append(f"Compile: exit {r['compile']['exit']}"
                         + (" (TIMEOUT)" if r["compile"]["timed_out"] else ""))
            if r["compile"]["stderr"]:
                lines += ["```", r["compile"]["stderr"].rstrip(), "```"]
        for run in r.get("runs", []):
            lines.append(f"- run `{run['variant']}`: exit {run['exit']}, stdout sha256 `{run['stdout_sha256'][:16]}`"
                         + (", TIMEOUT" if run["timed_out"] else "")
                         + (", TRUNCATED" if run["truncated"] else "")
                         + (", stderr: " + run["stderr"].strip()[:200] if run["stderr"] else ""))
        if r["status"] in ("NONDETERMINISTIC", "CONTRACT_BLOCKED"):
            for run in r["runs"]:
                lines += [f"`{run['variant']}` stdout:", "```", run["stdout"].rstrip("\n"), "```"]
        if r["status"] == "GENERATED":
            lines += ["", f"Staged: `{r['out']}` (sha256 `{r['out_sha256']}`, "
                      f"bytes equal raw stdout: {r['out_matches_raw_stdout']})", "",
                      "Raw stdout (`⏎` = end of line, `·` = trailing space):", "```"]
            stdout = r["runs"][0]["stdout"]
            for out_line in stdout.split("\n"):
                stripped = out_line.rstrip(" ")
                lines.append(stripped + "·" * (len(out_line) - len(stripped)) + "⏎")
            if stdout.endswith("\n"):
                lines.pop()  # the last "⏎" already marks the final line terminator
            else:
                lines[-1] = lines[-1][:-1] + "  (no final line terminator)"
            lines.append("```")
        for lang in ("tr", "en"):
            c = r.get("context", {}).get(lang)
            if c:
                lines += ["", f"**{lang.upper()}** `{c['file']}:{c['line']}` -- before:", "",
                          "> " + c["before"].replace("\n", "\n> "), "", "after:", "",
                          "> " + c["after"].replace("\n", "\n> ")]
        lines.append("")
    (OUT_ROOT / "report.md").write_text("\n".join(lines), encoding="utf-8")


def cmd_generate(specs: list):
    for spec in specs:
        if not NAME_PATTERN.match(spec):
            sys.exit(f"ABORT: '{spec}' is not an explicit slug/ExampleName entry.")
    cleanup_leftover_containers()
    jdk_version = verify_image()
    records = []
    try:
        for spec in specs:
            try:
                record = generate_one(spec, jdk_version)
            except Exception as e:  # one failing example never stops the others
                slug, name = NAME_PATTERN.match(spec).groups()
                record = {"slug": slug, "name": name, "java": spec, "status": "TOOL_ERROR", "error": repr(e)}
            records.append(record)
            print(f"{record['status']:18} {spec}")
    finally:
        cleanup_leftover_containers()
    OUT_ROOT.mkdir(parents=True, exist_ok=True)
    (OUT_ROOT / "results.json").write_text(json.dumps(records, indent=2, ensure_ascii=False), encoding="utf-8")
    write_report(records, jdk_version)
    print(f"report: {(OUT_ROOT / 'report.md').relative_to(ROOT)}")


def cmd_promote(specs: list, reviewer: str):
    """Copies reviewed, staged outputs into src/ and records them as approved in the manifest.

    Only explicit entries, and all-or-nothing: every check runs before anything is written.
    """
    for spec in specs:
        if not NAME_PATTERN.match(spec):
            sys.exit(f"ABORT: '{spec}' is not an explicit slug/ExampleName entry.")
    if not reviewer.strip() or "\t" in reviewer:
        sys.exit("ABORT: --reviewer must be a non-empty name without tabs.")
    records = {f"{r['slug']}/{r['name']}": r
               for r in json.loads((OUT_ROOT / "results.json").read_text(encoding="utf-8"))}
    manifest_lines = MANIFEST.read_text(encoding="utf-8").splitlines()
    existing = {"/".join(line.split("\t")[:2]) for line in manifest_lines[1:] if line.strip()}

    planned = []
    for spec in specs:
        slug, name = NAME_PATTERN.match(spec).groups()
        record = records.get(spec)
        java_file = EXAMPLES / slug / f"{name}.java"
        staged = STAGING / slug / f"{name}.out"
        target = EXAMPLES / slug / f"{name}.out"
        if record is None or record.get("status") != "GENERATED":
            sys.exit(f"ABORT: {spec} is not GENERATED in results.json "
                     f"(status = {record.get('status') if record else 'missing'}).")
        if sha256(java_file.read_bytes()) != record["java_sha256"]:
            sys.exit(f"ABORT: {spec}: the .java changed after generation -- regenerate and review again.")
        data = staged.read_bytes()
        if sha256(data) != record["out_sha256"] or sha256(data) != record["runs"][0]["stdout_sha256"]:
            sys.exit(f"ABORT: {spec}: the staged .out no longer matches the reviewed stdout.")
        if target.exists() or spec in existing:
            sys.exit(f"ABORT: {spec} is already promoted.")
        planned.append((spec, slug, name, record, data, target))

    reviewed_at = datetime.now(timezone.utc).date().isoformat()
    rows = []
    for spec, slug, name, record, data, target in planned:
        target.write_bytes(data)
        if target.read_bytes() != data:
            sys.exit(f"ABORT: {spec}: the written .out differs from the staged bytes.")
        note = "flags: " + ",".join(record["flags"]) if record["flags"] else ""
        rows.append("\t".join([slug, name, record["java_sha256"], sha256(data), record["jdk"]["image"],
                               "generated", "approved", reviewer, reviewed_at, note]))
        print(f"PROMOTED {spec} -> {target.relative_to(ROOT)}")
    MANIFEST.write_text("\n".join(manifest_lines + rows) + "\n", encoding="utf-8")


def cmd_selftest():
    """Runs probe programs under exactly the same container settings and checks each restriction."""
    cleanup_leftover_containers()
    verify_image()
    expectations = {
        "NetworkProbe": "network: blocked",
        "FilesystemProbe": "filesystem: ok",
        "IdentityProbe": "identity: ok",
        "ThreadLimitProbe": "threads: limited",
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
    generate.add_argument("examples", nargs="+")
    promote = sub.add_parser("promote", help="publish reviewed staged outputs for explicit slug/Name entries")
    promote.add_argument("--reviewer", required=True)
    promote.add_argument("examples", nargs="+")
    sub.add_parser("selftest", help="verify the sandbox restrictions with probe programs")
    args = parser.parse_args()
    if args.command == "generate":
        cmd_generate(args.examples)
    elif args.command == "promote":
        cmd_promote(args.examples, args.reviewer)
    else:
        cmd_selftest()


if __name__ == "__main__":
    main()
