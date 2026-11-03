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
without a main method (NO_MAIN) or with non-JDK imports (NON_JDK) are listed but never
run, and so are examples with a blocking contract flag (CONTRACT_BLOCKED, shown as
WILL_BE_BLOCKED in --dry-run): they are neither compiled nor run, so no container ever
starts for them.

An example that uses a type from another file of its lesson is compiled together with
that file (a companion, found transitively). A type must be declared in exactly one
file of the lesson; otherwise nothing is guessed and the example stays MULTI_FILE. The
companions count as part of the example: their non-JDK imports and contract flags apply
to it, report.md shows their source, and the manifest records their hashes so that
ExampleOutputManifestTest fails when one of them changes.

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
  * the working directory is the container's own /tmp tmpfs: fresh and EMPTY for every
    run (each variant is a new container), writable, and the only writable place; the
    classes are mounted read-only at /classes, outside it. A program that reads and
    writes files by relative name therefore always does so in a clean, isolated
    directory, and an output only ever shows that first run in an empty directory.
    Files outside it, temp-file names, listing order, file metadata and the optional
    java.nio.file exception types are blocked by contract flags (see CONTRACT_FLAGS);
    `selftest` (WorkdirProbe) checks the directory itself.

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
MANIFEST_HEADER = ("slug\texample\tjava_sha256\tout_sha256\tjdk_image\torigin\treview\treviewer"
                   "\treviewed_at\tnote\tcompanions")
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
    # Set by localized_scanner_decimal_read(): a Scanner reads numbers with its locale, which
    # starts as Locale.getDefault(Locale.Category.FORMAT); a decimal token like "5.6" fails
    # (InputMismatchException) or reads differently where the decimal separator is ",".
    ("scanner-locale", None),
    # Informational: useLocale(...) exempts that Scanner from scanner-locale; the reviewer
    # checks the locale is fixed (not the default) before the first decimal read.
    ("scanner-locale-set", r"\.\s*useLocale\s*\("),
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
    # Also set by array_identity_text(): an array printed as text.
    ("identity-text", r"hashCode\(\)|Object\.toString"),
    # The outside world: network, other processes, environment variables, host names.
    ("external-io", r"Socket|HttpClient|openConnection\(|openStream\(|System\.getenv|ProcessBuilder|ProcessHandle"
                    r"|Runtime\.getRuntime|\bInetAddress\b"),
    # Files are allowed, but ONLY files the program itself creates by relative name in its
    # working directory. Every run starts in a fresh, empty, writable working directory (the
    # container's own /tmp; the classes are a read-only mount outside it), so the panel shows a
    # first run in an empty directory. The flags below block what that assumption cannot fix.
    # Set by escaping_path_literal() too: an absolute, home-relative or ".." path literal.
    ("cwd-path", r"\.\s*(toAbsolutePath|toRealPath|getAbsolutePath|getAbsoluteFile|getCanonicalPath|getCanonicalFile)"
                 r"\s*\(|\b(listRoots|getRootDirectories|getFileStores)\s*\("),
    # Random names: createTempFile("x", ".txt") -> "x1234567890.txt".
    ("temp-file", r"\bcreateTemp(File|Directory)\s*\("),
    # Set by unsorted_directory_listing(): "The elements in the stream are not in any particular
    # order" (Files.list/walk/find, DirectoryStream, File.list/listFiles).
    ("directory-order", None),
    # Times, owner, permissions and file-system data describe the machine and the moment.
    ("file-metadata", r"\b(getLastModifiedTime|readAttributes|getAttribute|getOwner|getPosixFilePermissions"
                      r"|probeContentType|isHidden|lastModified|getFileStore|getTotalSpace|getFreeSpace"
                      r"|getUsableSpace|isReadable|isWritable|isExecutable|canRead|canWrite|canExecute)\s*\("),
    # The java.nio.file Javadoc lists these as "(optional specific exception)": a provider may
    # throw a plain IOException instead, so which catch branch runs is not fixed by the API.
    # (FileNotFoundException from FileReader/FileInputStream/FileOutputStream IS specified.)
    ("optional-file-exception", r"\b(NoSuchFileException|FileAlreadyExistsException|DirectoryNotEmptyException"
                                r"|NotDirectoryException|AccessDeniedException|NotLinkException"
                                r"|FileSystemLoopException)\b"),
    # Informational, on the code: relative-name file access, allowed by the assumption above.
    ("local-file", r"\bFiles\s*\.|\bPaths\s*\.\s*get\s*\(|\bPath\s*\.\s*of\s*\(|\bjava\.nio\.file\b|\bFileSystems\b"
                   r"|\bnew\s+(File|FileReader|FileWriter|FileInputStream|FileOutputStream|RandomAccessFile)\s*\("
                   r"|\bnew\s+(PrintWriter|PrintStream|Formatter)\s*\(\s*\"\""),
    # Informational, on the code: deletes, moves or replaces files.
    # Also set by deletes_java_io_file(): File.delete()/deleteOnExit() where the code uses File.
    ("deletes-files", r"\bFiles\s*\.\s*(delete|deleteIfExists|move)\s*\(|REPLACE_EXISTING"),
    # Informational: writes the platform line separator into text (BufferedWriter.newLine(),
    # Files.write(path, lines), System.lineSeparator()); the sandbox, and so every panel, is Linux
    # "\n". println/printf("%n") on stdout are the same for every panel and are not flagged.
    ("line-separator", r"\.\s*newLine\s*\(|lineSeparator\s*\(|\bFiles\s*\.\s*write\s*\("),
    # Set by object_identity_text(): an instance of a declared class with no toString() (own or
    # from a declared superclass) printed as text -- "Dog@1b6d3586". Types come from the example
    # and its companions; a class that overrides toString(), an enum, a record or a JDK type is
    # never flagged, and a variable is flagged only if EVERY class it can hold lacks toString.
    ("object-identity", None),
    # Set by lambda_identity_text(): a lambda, method reference or anonymous class (without its
    # own toString) printed as text -- "Main$$Lambda/0x0000...@1b6d3586".
    ("lambda-identity", None),
    # Set by optional_text(): Optional/OptionalInt/... printed as text. Javadoc: "The exact
    # presentation format is unspecified and may vary between implementations and versions."
    # get()/orElse(...)/isPresent() results are values, not Optional text, and are not flagged.
    ("optional-text", None),
    # Set by priority_queue_order(): a PriorityQueue printed, iterated, streamed or copied into a
    # list -- its iterator "is not guaranteed to traverse the elements ... in any particular order".
    # poll()/peek()/remove() order is fixed and is not flagged.
    ("priority-queue-order", None),
    # Set by count_skips_side_effects(): peek()/println in a pipeline that ends in count(), which
    # may skip the whole pipeline when the size is known from the source (Stream.count Javadoc).
    ("count-elision", None),
    # Informational, set by stream_side_effects(): printing from inside a stream pipeline.
    ("stream-side-effects", None),
    # Informational: the message text of an exception. Allowed only when the program itself
    # passes a string LITERAL to its own exception's constructor (see RISK_NOTES).
    ("exception-message", r"\.\s*get(?:Localized)?Message\s*\(\s*\)"),
    # Informational, set by caught_exception_text(): a caught exception printed as a whole
    # (println(e), "..." + e) -- class name + ": " + message.
    ("exception-text", None),
    # Informational: stderr. A run that writes anything to stderr (printStackTrace, System.err,
    # an uncaught exception's stack trace) is STDERR_NOT_EMPTY / RUN_ERROR and is never staged;
    # the panel only ever shows stdout.
    ("stderr", r"\bSystem\s*\.\s*err\b|\.\s*printStackTrace\s*\("),
]
BLOCKING_FLAGS = {"hash-order", "parallel", "concurrency", "time", "random", "stdin", "default-env",
                  "scanner-locale", "reflection-order", "identity-text", "external-io", "cwd-path",
                  "temp-file", "directory-order", "file-metadata", "optional-file-exception",
                  "object-identity", "lambda-identity", "optional-text", "priority-queue-order",
                  "count-elision"}
# Informational flags matched on the code (comments and string literals blanked) instead of
# the raw source: a file API named only in printed text or a comment is no file access.
CODE_INFO_FLAGS = {"local-file", "deletes-files", "stream-side-effects", "exception-message",
                   "exception-text", "stderr"}
# Informational, set by main_reads_args(): the run always passes no arguments (a fixed,
# repeatable input), so the reviewer checks the output is the branch the lesson shows.
MAIN_ARGS_FLAG = "main-args"
# Shown in report.md and pre-filled as the review.tsv note. A note is never a decision: the
# row's decision stays empty until the reviewer writes approve or reject.
RISK_NOTES = {
    "fail-fast": "RISK fail-fast: Java throws ConcurrentModificationException only on a best-effort basis "
                 "(not guaranteed by the API); approve only if the lesson presents it that way.",
    "scanner-locale-set": "NOTE scanner-locale-set: useLocale(...) exempts a Scanner from scanner-locale; check "
                          "every Scanner that reads decimals gets a fixed locale before its first read.",
    "local-file": "NOTE local-file: the output is a first run in a fresh, empty working directory; approve only "
                  "if the program creates every file it reads (or the lesson presents the missing file as the "
                  "point) and the output does not depend on what already exists in a reader's directory.",
    "deletes-files": "NOTE deletes-files: deletes, moves or replaces files; the sandbox only lets it touch its own "
                     "empty working directory, but a reader runs it in theirs -- check it only touches names the "
                     "program created itself.",
    "line-separator": "NOTE line-separator: writes the platform line separator; the panel shows Linux \"\\n\". "
                      "Reject if the output prints a length, byte count or other number derived from that text.",
    "stream-side-effects": "RISK stream-side-effects: prints from inside a stream pipeline; the API does not fix "
                           "the order of such side effects, and short-circuiting operations may visit fewer "
                           "elements. Approve only if the lesson presents the printed trace as typical, not "
                           "guaranteed, behaviour.",
    "exception-message": "RISK exception-message: approve ONLY if every printed message is a string literal the "
                         "program itself passes to its own exception's constructor. Reject JDK-generated messages "
                         "(\"/ by zero\", \"For input string: ...\", index messages) and messages built from "
                         "variables or runtime data unless each part is separately shown to be fixed.",
    "exception-text": "RISK exception-text: a caught exception printed as a whole is the class name + \": \" + "
                      "message; the exception-message rule applies to the message part.",
    "stderr": "NOTE stderr: anything on stderr (stack trace, System.err) makes the run STDERR_NOT_EMPTY / RUN_ERROR, "
              "so no panel is staged; the panel never shows stderr.",
}
TEXT_ONLY_SUFFIX = ":text-only"
RISK_NOTES.update({
    flag + TEXT_ONLY_SUFFIX: f"NOTE {flag}: matched only in a comment or string literal, not in the code; "
                             f"check the output and the lesson text do not depend on it."
    for flag in sorted(BLOCKING_FLAGS)
})


def blocking_flags(flags: list) -> list:
    """The flags that keep an example off the page whatever it prints (same order as flags)."""
    return [f for f in flags if f in BLOCKING_FLAGS]


# Arrays never override toString(): converting one to text always prints "[I@1b6d3586"-style
# type + identity-hash text. The variables come from declarations in the same file
# (int[] a, String... args, int[]... rows, int a[]); a type the file does not declare is not seen. An array
# is a + operand only in string concatenation (+ on an array does not compile otherwise).
# Arrays.toString(Object[]) prints each element with String.valueOf, so on an array of arrays
# (int[][], String[][][]) every element is identity text too; deepToString is the safe one.
ARRAY_DECLARATION = re.compile(
    r"\b([A-Za-z_][\w.]*)\s*(?:<[^;(){}=]*>)?\s*((?:\[\s*\]\s*)+(?:\.\.\.\s*)?|\.\.\.\s*)([A-Za-z_]\w*)\b(?!\s*\()")
C_STYLE_ARRAY_DECLARATION = re.compile(r"\b([A-Za-z_][\w.]*)\s+([A-Za-z_]\w*)\s*((?:\[\s*\]\s*)+)(?=[=;,)])")


NESTED_ARRAY_LITERAL_TO_STRING = re.compile(r"\bArrays\s*\.\s*toString\s*\(\s*new\s+[\w.]+\s*(?:\[[^\]]*\]\s*){2,}")


def array_variables(code: str) -> dict:
    """Array variable name -> (one_dim_char, dimensions). one_dim_char is True for a
    one-dimensional char[] (print/println/append/valueOf have char[] overloads that print the
    characters, not identity text); dimensions is the highest declared for that name."""
    found = {}
    declarations = [(t, d, n) for t, d, n in ARRAY_DECLARATION.findall(code)]
    declarations += [(t, d, n) for t, n, d in C_STYLE_ARRAY_DECLARATION.findall(code)]
    for type_name, dims, name in declarations:
        if type_name in ("new", "return"):
            continue
        count = dims.count("[") + dims.count("...")
        was_char, was_count = found.get(name, (False, 0))
        found[name] = (was_char or (type_name == "char" and count == 1), max(was_count, count))
    return found


def array_identity_text(code: str) -> bool:
    if NESTED_ARRAY_LITERAL_TO_STRING.search(code):
        return True
    for name, (one_dim_char, dimensions) in array_variables(code).items():
        n = re.escape(name)
        bare = rf"(?<![\w.]){n}(?!\s*[\w\[.(])"  # the array itself, not a[i], a.length, a(...)
        if (re.search(rf"\+=?\s*{bare}|{bare}\s*\+(?![+=])", code)
                or re.search(rf"(?<![\w.]){n}\s*\.\s*toString\s*\(\s*\)", code)
                or re.search(rf"\bObjects\s*\.\s*toString\s*\(\s*{n}\s*[,)]", code)
                or (not one_dim_char
                    and re.search(rf"\b(?:println|print|append|valueOf)\s*\(\s*{n}\s*\)", code))
                or (dimensions >= 2
                    and re.search(rf"\bArrays\s*\.\s*toString\s*\(\s*{n}\s*\)", code))):
            return True
    return False


# Scanner's decimal reads (next/hasNext + Double/Float/BigDecimal): the Javadoc grammar builds a
# decimal from LocalDecimalSeparator, so a fractional token depends on the locale. Integer reads
# are not flagged: a plain run of digits is a Numeral in every locale; only grouping separators
# or locale prefixes in the input would differ. Only Scanner receivers count -- Random and
# PrimitiveIterator.OfDouble have nextDouble() too.
SCANNER_DECIMAL_READ = r"\.\s*(?:next|hasNext)(?:Double|Float|BigDecimal)\s*\("
SCANNER_VARIABLE = re.compile(
    r"\b(?:java\.util\.)?Scanner\s+([A-Za-z_]\w*)\s*[=;,)]|\bvar\s+([A-Za-z_]\w*)\s*=\s*new\s+(?:java\.util\.)?Scanner\b")
INLINE_SCANNER_DECIMAL_READ = re.compile(
    r"\bnew\s+(?:java\.util\.)?Scanner\s*\((?:[^()]|\([^()]*\))*\)\s*" + SCANNER_DECIMAL_READ)
FIXED_LOCALE = r"\.\s*useLocale\s*\(\s*(?!Locale\s*\.\s*getDefault\b)"


def localized_scanner_decimal_read(code: str) -> bool:
    """A decimal read on a Scanner whose locale is still the default one."""
    if INLINE_SCANNER_DECIMAL_READ.search(code):
        return True
    names = {a or b for a, b in SCANNER_VARIABLE.findall(code)}
    for name in names:
        n = re.escape(name)
        if not re.search(rf"(?<![\w.]){n}\s*" + SCANNER_DECIMAL_READ, code):
            continue
        fixed = (re.search(rf"(?<![\w.]){n}\s*" + FIXED_LOCALE, code)
                 or re.search(rf"\b(?:Scanner|var)\s+{n}\s*=[^;]*" + FIXED_LOCALE, code))
        if not fixed:
            return True
    return False


# Directory listings: Files.list/walk/find and DirectoryStream promise no order, File.list() and
# listFiles() neither. A Files stream is accepted only when every chain that consumes it sorts
# it first (Files.walk(dir).sorted(...)..., or a variable whose every use starts with .sorted).
FILES_LISTING = re.compile(r"\bFiles\s*\.\s*(?:list|walk|find)\s*\(")
FILES_LISTING_VARIABLE = re.compile(r"\b([A-Za-z_]\w*)\s*=\s*Files\s*\.\s*(?:list|walk|find)\s*\(")
UNORDERED_LISTING = re.compile(r"\bnewDirectoryStream\s*\(|\.\s*listFiles\s*\(")
FILE_LIST_CALL = re.compile(r"\.\s*list\s*\(\s*\)")  # java.io.File.list(), only where the code uses File


def statement_from(code: str, start: int) -> str:
    """From start to the end of its statement: a ";" outside brackets, or the bracket that
    closes the one start sits in (a try-with-resources header)."""
    depth = 0
    for i in range(start, len(code)):
        ch = code[i]
        if ch in "({[":
            depth += 1
        elif ch in ")}]":
            depth -= 1
            if depth < 0:
                return code[start:i]
        elif ch == ";" and depth == 0:
            return code[start:i]
    return code[start:]


def sorted_first(chain: str) -> bool:
    """The chain's first stream operation after the call itself is .sorted(...)."""
    call_end = chain.find("(")
    depth = 0
    for i in range(call_end, len(chain)):
        if chain[i] == "(":
            depth += 1
        elif chain[i] == ")":
            depth -= 1
            if depth == 0:
                return re.match(r"\s*\.\s*sorted\s*\(", chain[i + 1:]) is not None
    return False


def unsorted_directory_listing(code: str) -> bool:
    if UNORDERED_LISTING.search(code) or (re.search(r"\bnew\s+File\s*\(", code) and FILE_LIST_CALL.search(code)):
        return True
    assigned = {m.start(0) + m.group(0).index("Files"): m.group(1) for m in FILES_LISTING_VARIABLE.finditer(code)}
    for match in FILES_LISTING.finditer(code):
        name = assigned.get(match.start())
        if name is None:
            if not sorted_first(statement_from(code, match.start())):
                return True
            continue
        uses = [u.start() for u in re.finditer(rf"(?<![\w.]){re.escape(name)}\s*\.", code) if u.start() > match.start()]
        if not uses or not all(re.match(rf"{re.escape(name)}\s*\.\s*sorted\s*\(", code[u:]) for u in uses):
            return True
    return False


def deletes_java_io_file(code: str) -> bool:
    """File.delete()/deleteOnExit(): only where the code uses java.io.File (a REST client's
    delete() is not a file)."""
    return bool(re.search(r"\bnew\s+File\s*\(", code)
                and re.search(r"\.\s*(?:delete\s*\(\s*\)|deleteOnExit\s*\()", code))


# --- values converted to text whose text the API does not fix --------------------------------
# "Printed as text" means: the whole argument of a .print/.println/.append call or of
# String.valueOf, a string-concatenation operand (+, +=), an argument of printf/format/formatted,
# or x.toString() / Objects.toString(x). Any other use (a method argument, an assignment, a
# method call on it) is not text. All analysis runs on code with comments and literals blanked.
TEXT_CALLS = {"print", "println", "append"}
FORMAT_CALLS = {"printf", "format", "formatted"}
OPENERS, CLOSERS = "([{", ")]}"


def matching_open(code: str, close: int) -> int:
    """Index of the bracket that opens the one closing at code[close], or -1."""
    depth = 0
    for i in range(close, -1, -1):
        if code[i] in CLOSERS:
            depth += 1
        elif code[i] in OPENERS:
            depth -= 1
            if depth == 0:
                return i
    return -1


def matching_close(code: str, open_: int) -> int:
    depth = 0
    for i in range(open_, len(code)):
        if code[i] in OPENERS:
            depth += 1
        elif code[i] in CLOSERS:
            depth -= 1
            if depth == 0:
                return i
    return -1


def enclosing_paren(code: str, pos: int) -> int:
    """The "(" of the innermost parenthesis around pos within its statement, or -1."""
    depth = 0
    for i in range(pos - 1, -1, -1):
        ch = code[i]
        if ch in CLOSERS:
            depth += 1
        elif ch in OPENERS:
            if depth == 0:
                return i if ch == "(" else -1
            depth -= 1
        elif ch == ";" and depth == 0:
            return -1
    return -1


def top_level_args(inner: str) -> list:
    """The comma-separated arguments of a call's argument text (nested brackets kept whole)."""
    args, depth, current = [], 0, []
    for ch in inner:
        if ch in OPENERS:
            depth += 1
        elif ch in CLOSERS:
            depth -= 1
        if ch == "," and depth == 0:
            args.append("".join(current))
            current = []
        else:
            current.append(ch)
    args.append("".join(current))
    return [] if len(args) == 1 and not args[0].strip() else args


def in_text_context(code: str, start: int, end: int) -> bool:
    """code[start:end] is a whole expression that is converted to text (see above)."""
    after = code[end:].lstrip()
    before = code[:start].rstrip()
    if after.startswith("+") and not after.startswith(("++", "+=")):
        return True
    if before.endswith("+=") or (before.endswith("+") and not before.endswith("++")):
        return True
    open_ = enclosing_paren(code, start)
    if open_ < 0:
        return False
    close = matching_close(code, open_)
    head = re.search(r"(\.?)\s*([A-Za-z_]\w*)\s*$", code[:open_])
    if close < 0 or not head:
        return False
    dotted, name = head.group(1) == ".", head.group(2)
    whole_arg = (re.search(r"[(,]\s*$", code[:start]) is not None
                 and re.match(r"\s*[,)]", code[end:]) is not None)
    if name in TEXT_CALLS and dotted:
        return not code[open_ + 1:start].strip() and not code[end:close].strip()
    if name == "valueOf" and re.search(r"\bString\s*\.\s*valueOf\s*$", code[:open_]):
        return not code[open_ + 1:start].strip() and not code[end:close].strip()
    return name in FORMAT_CALLS and dotted and whole_arg


def printed_as_text(code: str, name: str) -> bool:
    """The variable itself (not a.b, a[i], a(...)) is converted to text somewhere."""
    n = re.escape(name)
    if re.search(rf"(?<![\w.]){n}\s*\.\s*toString\s*\(\s*\)", code):
        return True
    if re.search(rf"\bObjects\s*\.\s*toString\s*\(\s*{n}\s*[,)]", code):
        return True
    for m in re.finditer(rf"(?<![\w.$]){n}\b(?!\s*[\[.(\w])", code):
        if in_text_context(code, m.start(), m.end()):
            return True
    return False


def chain_start(code: str, end: int) -> int:
    """Start of the method-call chain / new-expression that ends at code[end] (exclusive)."""
    i = end
    while True:
        j = i
        while j > 0 and code[j - 1].isspace():
            j -= 1
        if j > 0 and code[j - 1] == ")":
            j = matching_open(code, j - 1)
            if j < 0:
                return i
            head = re.search(r"[A-Za-z_]\w*\s*(?:<[^<>;]*(?:<[^<>;]*>[^<>;]*)*>)?\s*$", code[:j])
            if head:
                j = head.start()
        else:
            head = re.search(r"[A-Za-z_]\w*\s*$", code[:j])
            if not head:
                return i
            j = head.start()
        k = j
        while k > 0 and code[k - 1].isspace():
            k -= 1
        if k > 0 and code[k - 1] == ".":
            i = k - 1
            continue
        new = re.search(r"\bnew\s+$", code[:j])
        return new.start() if new else j


# Type declarations, for the object/lambda checks. Parsed from the example AND its companions.
TYPE_DECLARATION = re.compile(
    r"((?:\b(?:public|private|protected|static|final|abstract|sealed|non-sealed|strictfp)\s+)*)"
    r"\b(class|interface|record|enum)\s+([A-Za-z_]\w*)([^{;]*)\{")
VARIABLE_DECLARATION = re.compile(
    r"(?<![\w.])((?:[A-Za-z_]\w*\s*\.\s*)*[A-Z]\w*)\s*"
    r"(<(?:[^<>;(){}=]|<(?:[^<>;(){}=]|<[^<>;(){}=]*>)*>)*>)?\s*((?:\[\s*\]\s*)*)\s+([a-z_]\w*)\s*(?=[=;,):])")
JDK_CONTAINERS = {"List", "ArrayList", "LinkedList", "Set", "TreeSet", "LinkedHashSet", "SortedSet", "NavigableSet",
                  "Map", "TreeMap", "LinkedHashMap", "SortedMap", "NavigableMap", "Collection", "Queue", "Deque",
                  "ArrayDeque", "Stack", "Vector", "SequencedCollection", "SequencedSet", "SequencedMap",
                  "Entry", "CopyOnWriteArrayList"}
FUNCTIONAL_JDK = re.compile(
    r"^(?:Runnable|Callable|Comparator|(?:Bi|Int|Long|Double|Obj(?:Int|Long|Double)?|ToInt|ToLong|ToDouble"
    r"|(?:Int|Long|Double)To(?:Int|Long|Double))?(?:Supplier|Consumer|Function|Predicate|UnaryOperator"
    r"|BinaryOperator|Operator))$")


def parse_types(code: str) -> dict:
    """name -> {kind, abstract, supers, own_to_string} for every type declared in code."""
    found = []
    for m in TYPE_DECLARATION.finditer(code):
        brace = m.end() - 1
        found.append((m, brace, matching_close(code, brace)))
    types = {}
    for m, brace, close in found:
        if close < 0:
            continue
        body = code[brace + 1:close]
        for _, inner_brace, inner_close in found:  # blank nested types: their toString is theirs
            if brace < inner_brace and inner_close <= close:
                body = body.replace(code[inner_brace + 1:inner_close], " ")
        # Only the extends/implements clauses name supertypes (not record components or permits).
        header = re.sub(r"<[^{]*?>", " ", re.sub(r"\([^{]*?\)", " ", m.group(4)))
        header = re.split(r"\bpermits\b", header)[0]
        clauses = re.findall(r"\b(?:extends|implements)\b([^{]*?)(?=\b(?:extends|implements)\b|$)", header)
        supers = [s.split(".")[-1] for c in clauses for s in re.findall(r"[A-Za-z_][\w.]*", c)]
        extends = re.search(r"\bextends\s+([A-Za-z_][\w.]*)", header)
        types[m.group(3)] = {
            "kind": m.group(2), "abstract": "abstract" in m.group(1),
            "final": m.group(2) in ("record", "enum") or "final" in m.group(1),
            "supers": supers, "extends": extends.group(1).split(".")[-1] if extends else None,
            "body": body, "own_to_string": re.search(r"\bString\s+toString\s*\(\s*\)", body) is not None}
    return types


def has_to_string(types: dict, name: str, seen=()) -> bool:
    """Does an instance of this declared class print something other than identity text?
    Enums (name) and records (component text, judged separately) are not identity text; a
    superclass that is not declared here (a JDK class) is assumed to have its own toString."""
    t = types.get(name)
    if t is None or t["kind"] in ("enum", "record"):
        return True
    if t["kind"] == "interface" or t["own_to_string"]:
        return t["kind"] != "interface"
    parent = t["extends"]
    if parent is None or name in seen:
        return False
    return parent not in types or has_to_string(types, parent, seen + (name,))


def runtime_types(types: dict, name: str) -> set:
    """Declared, instantiable classes an expression of static type `name` can hold."""
    result, queue, seen = set(), [name], set()
    while queue:
        current = queue.pop()
        if current in seen:
            continue
        seen.add(current)
        t = types.get(current)
        if t and t["kind"] == "class" and not t["abstract"]:
            result.add(current)
        if t and t["final"]:
            continue  # records, enums and final classes have no subclasses
        queue.extend(sub for sub, info in types.items() if current in info["supers"])
    return result


def identity_type(types: dict, static_type: str, initializer: str = "") -> bool:
    """Every value of this static type prints Object.toString identity text."""
    created = re.match(r"\s*new\s+([A-Za-z_][\w.]*)\s*(?:<[^>]*>)?\s*\(", initializer)
    if created:
        exact = created.group(1).split(".")[-1]
        rest = initializer[created.end() - 1:]
        close = matching_close(rest, 0)
        if close >= 0 and rest[close + 1:].lstrip().startswith("{"):
            return False  # an anonymous class: judged by the lambda/anonymous check
        return exact in types and types[exact]["kind"] == "class" and not has_to_string(types, exact)
    if static_type not in types:
        return False
    candidates = runtime_types(types, static_type)
    return bool(candidates) and not any(has_to_string(types, c) for c in candidates)


def declared_variables(code: str) -> dict:
    """variable name -> list of (static type, type arguments, array dims, initializer)."""
    found = {}
    for m in VARIABLE_DECLARATION.finditer(code):
        type_name = m.group(1).replace(" ", "").split(".")[-1]
        if type_name in ("new", "return", "throw", "case", "else"):
            continue
        initializer = ""
        if code[m.end():].lstrip().startswith("=") and not code[m.end():].lstrip().startswith("=="):
            eq = code.index("=", m.end())
            initializer = statement_from(code, eq + 1)
        found.setdefault(m.group(4), []).append((type_name, m.group(2) or "", m.group(3).count("["), initializer))
    for m in re.finditer(r"\bvar\s+([a-z_]\w*)\s*=", code):
        initializer = statement_from(code, m.end())
        created = re.match(r"\s*new\s+([A-Za-z_][\w.]*)", initializer)
        found.setdefault(m.group(1), []).append(
            (created.group(1).split(".")[-1] if created else "var", "", 0, initializer))
    return found


def object_identity_text(code: str, context: str = None) -> bool:
    """An instance of a declared class without toString() (nor one inherited from a declared
    superclass) converted to text prints Object.toString: class name + "@" + identity hash.
    A class that overrides toString(), an enum, a record or an unknown (JDK) type is never flagged."""
    types = parse_types(strip_comments_and_strings(context) if context else code)
    if not any(t["kind"] == "class" and not has_to_string(types, n) for n, t in types.items()):
        return False
    for name, declarations in declared_variables(code).items():
        def element_identity(decl):
            type_name, type_args, dims, initializer = decl
            if dims:
                return identity_type(types, type_name)
            if type_name in JDK_CONTAINERS and type_args:
                return any(identity_type(types, arg) for arg in re.findall(r"[A-Za-z_]\w*", type_args))
            return identity_type(types, type_name, initializer)
        if all(element_identity(d) for d in declarations):
            n = re.escape(name)
            if printed_as_text(code, name) and not all(d[2] for d in declarations):
                return True
            if re.search(rf"\bArrays\s*\.\s*(?:toString|deepToString|asList)\s*\(\s*{n}\s*\)", code):
                return True
            if re.search(rf"(?<![\w.]){n}\s*\.\s*forEach\s*\(\s*System\s*\.\s*out\s*::\s*print", code):
                return True
    for m in re.finditer(r"\bnew\s+([A-Za-z_][\w.]*)\s*(?:<[^>]*>)?\s*\(", code):
        close = matching_close(code, m.end() - 1)
        cls = m.group(1).split(".")[-1]
        if close < 0 or code[close + 1:].lstrip().startswith(("{", ".")):
            continue
        if cls in types and identity_type(types, cls, code[m.start():]) and in_text_context(code, m.start(), close + 1):
            return True
    for name, t in types.items():  # `this` printed inside a class none of whose runtime types has toString
        if t["kind"] == "class" and identity_type(types, name) and printed_as_text(t["body"], "this"):
            return True
    return False


def lambda_identity_text(code: str, context: str = None) -> bool:
    """A lambda, method reference or anonymous class without toString() converted to text
    prints a synthetic class name + "@" + identity hash (Main$$Lambda/0x...@1b6d3586)."""
    types = parse_types(strip_comments_and_strings(context) if context else code)
    for name, declarations in declared_variables(code).items():
        def functional(decl):
            type_name, _, dims, initializer = decl
            if dims:
                return False
            init = initializer.strip()
            if re.match(r"(?:\([^()]*\)|[A-Za-z_]\w*)\s*->", init) or re.match(r"[\w.<>\[\]]+\s*::\s*\w+\s*$", init):
                return True
            anonymous = re.match(r"new\s+[A-Za-z_][\w.]*\s*(?:<[^>]*>)?\s*\(", init)
            if anonymous:
                close = matching_close(init, anonymous.end() - 1)
                rest = init[close + 1:].lstrip() if close >= 0 else ""
                if not rest.startswith("{"):
                    return False  # a named class: judged by object_identity_text
                body = rest[1:matching_close(rest, 0)] if matching_close(rest, 0) > 0 else rest
                return re.search(r"\bString\s+toString\s*\(\s*\)", body) is None
            return FUNCTIONAL_JDK.match(type_name) is not None and type_name not in types
        if declarations and all(functional(d) for d in declarations) and printed_as_text(code, name):
            return True
    return False


def optional_expression(code: str, end: int) -> bool:
    """The call ending at code[end-1] == ")" returns an Optional (or OptionalInt/Long/Double)."""
    open_ = matching_open(code, end - 1)
    head = re.search(r"(?:([A-Za-z_]\w*)|(\)))\s*\.\s*([A-Za-z_]\w*)\s*$", code[:open_]) if open_ > 0 else None
    if not head:
        return False
    receiver, chained, method = head.group(1), head.group(2), head.group(3)
    args = top_level_args(code[open_ + 1:end - 1])
    if receiver and re.fullmatch(r"Optional(?:Int|Long|Double)?", receiver):
        return method in ("of", "ofNullable", "empty")
    if not chained:
        return False
    if method in ("findFirst", "findAny", "average") and not args:
        return True
    if method in ("max", "min") and len(args) <= 1:
        return True
    return method == "reduce" and len(args) == 1


def optional_text(code: str) -> bool:
    """Optional.toString(): "The exact presentation format is unspecified and may vary between
    implementations and versions." Same for OptionalInt/Long/Double."""
    names = set()
    for name, declarations in declared_variables(code).items():
        if all(re.fullmatch(r"Optional(?:Int|Long|Double)?", t) or
               (t == "var" and init.rstrip().endswith(")") and optional_expression(init.rstrip(), len(init.rstrip())))
               for t, _, dims, init in declarations if not dims):
            if any(not d[2] for d in declarations):
                names.add(name)
    if any(printed_as_text(code, n) for n in names):
        return True
    for m in re.finditer(r"\)", code):
        if optional_expression(code, m.end()) and in_text_context(code, chain_start(code, m.end()), m.end()):
            return True
    return False


def priority_queue_order(code: str) -> bool:
    """PriorityQueue: "The Iterator provided in method iterator() ... [is] not guaranteed to
    traverse the elements of the priority queue in any particular order" -- and toString(),
    forEach, streams and copies into lists follow that iterator. poll()/peek() are fixed."""
    names = {name for name, declarations in declared_variables(code).items()
             if any(t == "PriorityQueue" or re.match(r"\s*new\s+(?:java\.util\.)?PriorityQueue\b", init)
                    for t, _, _, init in declarations)}
    for name in names:
        n = re.escape(name)
        if printed_as_text(code, name):
            return True
        if re.search(rf"(?<![\w.]){n}\s*\.\s*(?:forEach|stream|parallelStream|iterator|spliterator|toArray)\s*\(", code):
            return True
        if re.search(rf"\bfor\s*\([^;:()]*:\s*{n}\s*\)", code):
            return True
        if re.search(rf"\bnew\s+(?:ArrayList|LinkedList|ArrayDeque|Vector)\s*(?:<[^>]*>)?\s*\(\s*{n}\s*\)"
                     rf"|\b(?:List|Set)\s*\.\s*copyOf\s*\(\s*{n}\s*\)|\.\s*addAll\s*\(\s*{n}\s*\)", code):
            return True
    for m in re.finditer(r"\bnew\s+(?:java\.util\.)?PriorityQueue\s*(?:<[^>]*>)?\s*\(", code):
        close = matching_close(code, m.end() - 1)
        if close > 0 and in_text_context(code, m.start(), close + 1):
            return True
    return False


def statement_before(code: str, pos: int) -> str:
    """From the start of pos's statement up to pos (lambda bodies inside it included)."""
    depth = 0
    for i in range(pos - 1, -1, -1):
        ch = code[i]
        if ch in CLOSERS:
            depth += 1
        elif ch in OPENERS:
            if depth == 0:
                return code[i + 1:pos]
            depth -= 1
        elif ch == ";" and depth == 0:
            return code[i + 1:pos]
    return code[:pos]


SIDE_EFFECT = re.compile(r"\.\s*peek\s*\(\s*[^\s)]|\bSystem\s*\.\s*(?:out|err)\b")
STREAM_VARIABLE = re.compile(r"\b(?:Stream|IntStream|LongStream|DoubleStream)\s*(?:<[^;=]*>)?\s+([a-z_]\w*)\s*=")


def count_skips_side_effects(code: str) -> bool:
    """Stream.count(): "An implementation may choose to not execute the stream pipeline ... if
    it is capable of computing the count directly from the stream source. In such cases no
    source elements will be traversed and no intermediate operations will be evaluated." So
    peek()/println side effects in a pipeline ending in count() may or may not print."""
    noisy_streams = {m.group(1) for m in STREAM_VARIABLE.finditer(code)
                     if SIDE_EFFECT.search(statement_from(code, m.end()))}
    for m in re.finditer(r"\.\s*count\s*\(\s*\)", code):
        statement = statement_before(code, m.start())
        if SIDE_EFFECT.search(statement):
            return True
        if any(re.search(rf"(?<![\w.]){re.escape(s)}\b", statement) for s in noisy_streams):
            return True
    return False


INTERMEDIATE_OP = re.compile(r"\.\s*(?:map|mapToObj|mapToInt|mapToLong|mapToDouble|flatMap|filter|sorted|distinct"
                             r"|takeWhile|dropWhile|mapMulti)\s*\(")


def stream_side_effects(code: str) -> bool:
    """Printing from inside a stream pipeline (peek(), or println in an intermediate operation's
    lambda): the java.util.stream package docs say the order of such side effects "may be
    surprising" and short-circuiting operations may skip elements -- informational."""
    if re.search(r"\.\s*peek\s*\(\s*[^\s)]", code):
        return True
    for m in INTERMEDIATE_OP.finditer(code):
        close = matching_close(code, m.end() - 1)
        if close > 0 and re.search(r"\bSystem\s*\.\s*(?:out|err)\b", code[m.end():close]):
            return True
    return False


CATCH_PARAMETER = re.compile(r"\bcatch\s*\(\s*(?:final\s+)?[\w.|\s]+?\s+([a-z_]\w*)\s*\)")


def caught_exception_text(code: str) -> bool:
    """A caught exception printed as a whole: Throwable.toString() is the class name, ": " and
    getLocalizedMessage() -- so the message rules apply to it too."""
    return any(printed_as_text(code, name) for name in set(CATCH_PARAMETER.findall(code)))


DETECTORS = {"identity-text": array_identity_text, "scanner-locale": localized_scanner_decimal_read,
             "directory-order": unsorted_directory_listing, "deletes-files": deletes_java_io_file,
             "object-identity": object_identity_text, "lambda-identity": lambda_identity_text,
             "optional-text": optional_text, "priority-queue-order": priority_queue_order,
             "count-elision": count_skips_side_effects, "stream-side-effects": stream_side_effects,
             "exception-text": caught_exception_text}
# Detectors that also read the type declarations of the example's companions.
CONTEXT_DETECTORS = {"object-identity", "lambda-identity"}
# Structural detectors (types, variables, call chains): run on raw text, prose in comments parses
# as code ("a class implementing the interface ... {"), so they give no ":text-only" note.
STRUCTURAL_FLAGS = {"object-identity", "lambda-identity", "optional-text", "priority-queue-order", "count-elision"}

# A path literal that leaves the working directory: absolute ("/data", "C:\\x", "\\\\host"),
# home-relative ("~/x") or with a ".." segment. Checked on the code with only the comments
# removed, and only when the code uses files at all ("/en/topics" printed by a web example is text).
STRING_LITERAL = re.compile(r'"""([\s\S]*?)"""|"((?:\\.|[^"\\\n])*)"')
ESCAPING_PATH = re.compile(r'^(?:/|~|[A-Za-z]:[\\/]|\\\\)|(?:^|[\\/])\.\.(?:[\\/]|$)')


def escaping_path_literal(code: str, code_with_literals: str) -> bool:
    if not re.search(dict(CONTRACT_FLAGS)["local-file"], code):
        return False
    for block, literal in STRING_LITERAL.findall(code_with_literals):
        value = (block or literal).replace("\\\\", "\\")
        if ESCAPING_PATH.search(value):
            return True
    return False


# Detectors that need the string literals themselves (run on the code with comments removed).
LITERAL_DETECTORS = {"cwd-path": escaping_path_literal}


def flag_matches(flag: str, pattern, text: str, context: str = None) -> bool:
    if pattern and re.search(pattern, text):
        return True
    detector = DETECTORS.get(flag)
    if detector and flag in CONTEXT_DETECTORS:
        return bool(detector(text, context))
    return bool(detector and detector(text))


def contract_flags(source: str, context: str = None) -> list:
    """context: the example plus its companions, read for type declarations (object/lambda
    checks); without it only this source's own declarations are known."""
    code = strip_comments_and_strings(source)
    code_with_literals = strip_comments(source)
    flags = []
    for flag, pattern in CONTRACT_FLAGS:
        literal_detector = LITERAL_DETECTORS.get(flag)
        if flag in CODE_INFO_FLAGS:
            if flag_matches(flag, pattern, code, context):
                flags.append(flag)
        elif flag not in BLOCKING_FLAGS:
            if re.search(pattern, source):
                flags.append(flag)
        elif flag_matches(flag, pattern, code, context) or (literal_detector and literal_detector(code, code_with_literals)):
            flags.append(flag)
        elif flag not in STRUCTURAL_FLAGS and flag_matches(flag, pattern, source, context):
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
    return LEXICAL_TOKEN.sub(lambda m: " " if not m.group().startswith(('"', "'")) else '""', source)


def strip_comments(source: str) -> str:
    """Blanks out comments only; string and char literals stay as written."""
    return LEXICAL_TOKEN.sub(lambda m: m.group() if m.group().startswith(('"', "'")) else " ", source)


LEXICAL_TOKEN = re.compile(r'"""[\s\S]*?"""|"(?:\\.|[^"\\\n])*"|\'(?:\\.|[^\'\\\n])*\'|//[^\n]*|/\*[\s\S]*?\*/')


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


def declaring_files(folder: Path, type_name: str) -> list:
    """The .java files of a lesson folder that declare this top-level type."""
    return [f for f in sorted(folder.glob("*.java"))
            if type_name in TOP_LEVEL_TYPE.findall(strip_comments_and_strings(f.read_text(encoding="utf-8")))]


def resolve_companions(java_file: Path) -> tuple:
    """(companion files, unresolved type names). Follows dependencies transitively; a type
    declared in several files is left unresolved rather than guessed."""
    selected, unresolved = [java_file], []
    queue = [java_file]
    while queue:
        for type_name in sibling_dependencies(queue.pop(0)):
            declared_in = declaring_files(java_file.parent, type_name)
            if any(f in selected for f in declared_in):
                continue
            if len(declared_in) == 1:
                selected.append(declared_in[0])
                queue.append(declared_in[0])
            elif type_name not in unresolved:
                unresolved.append(type_name)
    return sorted(selected[1:]), unresolved


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
        companions, unresolved = resolve_companions(java_file)
        companion_sources = [c.read_text(encoding="utf-8") for c in companions]
        if unresolved:
            result["status"] = "MULTI_FILE"
            result["depends_on"] = unresolved
        elif companions:
            result["companions"] = [c.name for c in companions]
            context = "\n".join([source] + companion_sources)
            result["flags"] = list(dict.fromkeys(
                contract_flags(source, context)
                + [f for text in companion_sources for f in contract_flags(text, context)]))
            if any(NON_JDK_IMPORT.search(text) for text in companion_sources):
                result["status"] = "NON_JDK"
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


def compile_example(java_file: Path, work_dir: Path, companions: list = ()) -> dict:
    src = work_dir / "src"
    classes = work_dir / "classes"
    if work_dir.exists():
        shutil.rmtree(work_dir)
    src.mkdir(parents=True)
    classes.mkdir()
    classes.chmod(0o777)  # writable by the container's "nobody" user
    sources = [java_file, *companions]
    for source in sources:
        shutil.copy2(source, src / source.name)
    name = f"{CONTAINER_PREFIX}{uuid.uuid4().hex[:12]}-compile"
    result = run_container(
        docker_args(name, cpus="2", mounts=[(src, "/src", "ro"), (classes, "/classes", "rw")]),
        ["javac", "-J-Xmx256m", "-J-XX:-UsePerfData", "-encoding", "UTF-8", "-d", "/classes",
         *["/src/" + source.name for source in sources]],
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
    if pre.get("companions"):
        record["companions"] = {c: sha256((java_file.parent / c).read_bytes()) for c in pre["companions"]}
    if pre["status"]:  # NO_MAIN / NON_JDK / MULTI_FILE: listed, never compiled or run
        record["status"] = pre["status"]
        if "depends_on" in pre:
            record["depends_on"] = pre["depends_on"]
        return record
    if blocking_flags(record["flags"]):  # CONTRACT_BLOCKED: listed, never compiled or run
        record["status"] = "CONTRACT_BLOCKED"
        return record

    compiled = compile_example(java_file, WORK / f"{slug}__{name}",
                               [java_file.parent / c for c in record.get("companions", {})])
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
             "command-line arguments, an empty stdin and a fresh, empty working directory. Decide per",
             "example in `review.tsv`.", ""]
    slugs = list(dict.fromkeys(r["slug"] for r in records))
    for slug in slugs:
        lesson = [r for r in records if r["slug"] == slug]
        generated = [r for r in lesson if r["status"] == "GENERATED"]
        others = [r for r in lesson if r["status"] != "GENERATED"]
        lines += [f"## {slug} -- {len(generated)} generated, {len(others)} blocked or not run", ""]
        for r in generated:
            source = (ROOT / r["java"]).read_text(encoding="utf-8") if (ROOT / r["java"]).is_file() else ""
            for companion in r.get("companions", {}):
                companion_file = (ROOT / r["java"]).parent / companion
                if companion_file.is_file():
                    source += f"\n// --- companion: {companion} ---\n" + companion_file.read_text(encoding="utf-8")
            opening, closing = fence_for(source, "java")
            lines += [f"### {r['name']} -- GENERATED", "",
                      f"Source: `{r['java']}` (sha256 `{r['java_sha256']}`)"]
            lines += [f"Companion: `{c}` (sha256 `{digest}`)" for c, digest in r.get("companions", {}).items()]
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
            notes = [RISK_NOTES[f] for f in r.get("flags", []) if f in RISK_NOTES]
            if r.get("companions"):
                notes.append("compiled with: " + ", ".join(r["companions"]))
            risk = " ".join(notes)
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
    for companion, digest in record.get("companions", {}).items():
        companion_file = EXAMPLES / slug / companion
        if not companion_file.is_file() or sha256(companion_file.read_bytes()) != digest:
            raise ReviewError(f"{key}: the companion {companion} changed after generation -- "
                              f"regenerate and review again.")
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
    if not manifest_lines or manifest_lines[0] != MANIFEST_HEADER:
        raise ReviewError(f"{MANIFEST.name}: the first line must be exactly the header {MANIFEST_HEADER!r}.")
    reviewed_at = datetime.now(timezone.utc).date().isoformat()
    written, rows = [], []
    try:
        for key, slug, name, record, data, target in planned:
            target.write_bytes(data)
            written.append(target)
            if target.read_bytes() != data:
                raise ReviewError(f"{key}: the written .out differs from the staged bytes.")
            note = "flags: " + ",".join(record["flags"]) if record["flags"] else ""
            companions = ",".join(f"{c}:{digest}" for c, digest in sorted(record.get("companions", {}).items()))
            rows.append("\t".join([slug, name, record["java_sha256"], sha256(data), record["jdk"]["image"],
                                   "generated", "approved", reviewer, reviewed_at, note, companions]))
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
    blocking = blocking_flags(flags)
    if pre["status"]:
        verdict = pre["status"] + (f" (needs {', '.join(pre['depends_on'])})" if pre.get("depends_on") else "")
    elif blocking:
        verdict = "WILL_BE_BLOCKED (" + ", ".join(blocking) + ")"
    else:
        verdict = "WILL_RUN"
    info = [f for f in flags if f not in BLOCKING_FLAGS]
    return (f"{verdict:42} {spec}" + (f"  [review: {', '.join(info)}]" if info else "")
            + (f"  [compiled with: {', '.join(pre['companions'])}]" if pre.get("companions") else ""))


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
        # Exactly like generate: one compile, then every variant in its own container, in order.
        compiled = compile_example(SELFTEST_SOURCES / "WorkdirProbe.java", WORK / "selftest__WorkdirProbe")
        for label, cpus, extra in VARIANTS:
            result = run_variant("WorkdirProbe", compiled["classes"], cpus, extra)
            text = result["stdout"].decode("utf-8", "replace").strip()
            ok = result["exit"] == 0 and text == "workdir: ok"
            failures += not ok
            print(f"{'PASS' if ok else 'FAIL'} WorkdirProbe [{label}]: {text}")
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
