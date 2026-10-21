"""Unit tests for scripts/example_outputs.py -- no Docker, no network, temp directories only.

    python3 -B -m unittest discover -s scripts/example-outputs -p 'test_*.py'

The sandbox itself (network, filesystem, stdin, limits) is tested by `example_outputs.py
selftest`, which needs Docker and the pinned image.
"""
import hashlib
import io
import json
import subprocess
import sys
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest import mock

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import example_outputs as eo  # noqa: E402

MANIFEST_HEADER = "slug\texample\tjava_sha256\tout_sha256\tjdk_image\torigin\treview\treviewer\treviewed_at\tnote"
HELLO = 'class {name} {{\n    public static void main(String[] args) {{\n        System.out.println("{text}");\n    }}\n}}\n'


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def flags_of(source: str) -> list:
    return eo.contract_flags(source)


def snapshot(root: Path) -> dict:
    return {str(p.relative_to(root)): p.read_bytes() for p in sorted(root.rglob("*")) if p.is_file()}


class Sandbox(unittest.TestCase):
    """Points every path in the module at a throwaway project tree."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        paths = {
            "ROOT": self.root,
            "EXAMPLES": self.root / "src/main/resources/examples",
            "CONTENT": self.root / "src/main/resources/content",
            "OUT_ROOT": self.root / ".example-outputs",
            "WORK": self.root / ".example-outputs/work",
            "STAGING": self.root / ".example-outputs/staging",
            "MANIFEST": self.root / "scripts/example-outputs/manifest.tsv",
        }
        for name, value in paths.items():
            patcher = mock.patch.object(eo, name, value)
            patcher.start()
            self.addCleanup(patcher.stop)
        self.addCleanup(self.tmp.cleanup)
        eo.MANIFEST.parent.mkdir(parents=True)
        eo.MANIFEST.write_text(MANIFEST_HEADER + "\n", encoding="utf-8")
        eo.OUT_ROOT.mkdir(parents=True)

    def java(self, slug, name, source=None, text="hi"):
        path = eo.EXAMPLES / slug / f"{name}.java"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(source if source is not None else HELLO.format(name=name, text=text), encoding="utf-8")
        return path

    def lesson(self, slug, tr=None, en=None):
        for lang, body in (("tr", tr), ("en", en)):
            if body is not None:
                path = eo.CONTENT / lang / f"{slug}.md"
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(body, encoding="utf-8")

    def generated(self, slug, name, stdout: bytes):
        """A GENERATED record plus its staged .out, as generate_one would leave them."""
        java = self.java(slug, name) if not (eo.EXAMPLES / slug / f"{name}.java").exists() \
            else eo.EXAMPLES / slug / f"{name}.java"
        staged = eo.STAGING / slug / f"{name}.out"
        staged.parent.mkdir(parents=True, exist_ok=True)
        staged.write_bytes(stdout)
        return {"slug": slug, "name": name, "java": str(java.relative_to(self.root)),
                "java_sha256": sha(java.read_bytes()), "flags": [], "status": "GENERATED",
                "runs": [{"variant": "base-1", "exit": 0, "timed_out": False, "truncated": False,
                          "stdout_sha256": sha(stdout), "stdout": stdout.decode(), "stderr": ""}],
                "out": str(staged.relative_to(self.root)), "out_sha256": sha(stdout),
                "out_matches_raw_stdout": True, "jdk": {"image": eo.IMAGE, "version": "test"}}

    def results(self, *records):
        (eo.OUT_ROOT / "results.json").write_text(json.dumps(list(records)), encoding="utf-8")

    def sheet(self, *rows, header=eo.REVIEW_HEADER):
        path = eo.OUT_ROOT / "review.tsv"
        path.write_text("\n".join([header, *rows]) + "\n", encoding="utf-8")
        return path

    def abort(self, func, *args):
        """Runs a command expected to abort; returns its message."""
        with self.assertRaises(SystemExit) as ctx, redirect_stdout(io.StringIO()):
            func(*args)
        return str(ctx.exception.code)


# --- contract flags -------------------------------------------------------------------

class ContractFlagTest(unittest.TestCase):

    def test_stdin_is_blocking_but_in_memory_scanner_is_not(self):
        self.assertIn("stdin", flags_of("Scanner sc = new Scanner(System.in);"))
        self.assertIn("stdin", flags_of("var line = System.console().readLine();"))
        self.assertIn("stdin", flags_of("new BufferedReader(new InputStreamReader(System.in))"))
        self.assertNotIn("stdin", flags_of('Scanner sc = new Scanner("1,2,3").useDelimiter(",");'))
        self.assertNotIn("stdin", flags_of("System.out.println(x); System.err.println(y);"))
        self.assertIn("stdin", eo.BLOCKING_FLAGS)

    def test_file_io_is_blocking(self):
        for source in ['new FileWriter("a.txt")', 'new FileReader("a.txt")', 'new FileInputStream(f)',
                       'new FileOutputStream("x")', 'new RandomAccessFile("x", "r")', 'new File("x")',
                       'Files.readAllLines(p)', 'Path.of("a.txt")', 'Paths.get("a")',
                       'import java.nio.file.Path;', 'FileSystems.getDefault()']:
            self.assertIn("io-or-env", flags_of(source), source)
        for source in ['new StringReader("x")', 'new StringWriter()', 'new PrintWriter(System.out)',
                       'Profile profile = new Profile();', 'String fileName = "a.txt";']:
            self.assertNotIn("io-or-env", flags_of(source), source)

    def test_reflection_member_order_is_blocking_single_lookups_are_not(self):
        for call in ["getDeclaredFields()", "getFields()", "getDeclaredMethods()", "getMethods()",
                     "getDeclaredConstructors()", "getConstructors()", "getAnnotations()",
                     "getDeclaredAnnotations()", "getDeclaredClasses()"]:
            self.assertIn("reflection-order", flags_of(f"for (var m : type.{call}) {{}}"), call)
        for call in ['getDeclaredField("name")', 'getMethod("run")', "getRecordComponents()",
                     "getEnumConstants()", "getSimpleName()", "getInterfaces()"]:
            self.assertNotIn("reflection-order", flags_of(f"type.{call};"), call)

    def test_default_locale_zone_and_environment_are_blocking(self):
        for source in ["ZoneId.systemDefault()", "TimeZone.getDefault()", "Locale.getDefault()",
                       "Clock.systemDefaultZone()", "Charset.defaultCharset()", 'System.getProperty("user.dir")',
                       "Runtime.version()", "DateTimeFormatter.ofLocalizedDate(FormatStyle.LONG)"]:
            self.assertIn("default-env", flags_of(source), source)
        for source in ['ZoneId.of("Europe/Istanbul")', "Locale.US", 'DateTimeFormatter.ofPattern("yyyy")',
                       "LocalDate.of(2024, 1, 1)"]:
            self.assertNotIn("default-env", flags_of(source), source)

    def test_main_args_is_informational_and_only_for_mains_own_parameter(self):
        reads = "class A { public static void main(String[] args) { String n = args.length > 0 ? args[0] : \"x\"; } }"
        self.assertIn(eo.MAIN_ARGS_FLAG, flags_of(reads))
        self.assertNotIn(eo.MAIN_ARGS_FLAG, eo.BLOCKING_FLAGS)
        varargs = "class A { static void main(String... input) { System.out.println(input.length); } }"
        self.assertIn(eo.MAIN_ARGS_FLAG, flags_of(varargs))
        # A local variable called args in another method (reflection/SimpleContainer.java).
        other_method = ("class A { public static void main(String[] args) { System.out.println(1); }\n"
                        "  Object make() { Object[] args = new Object[2]; args[0] = 1; return args; } }")
        self.assertNotIn(eo.MAIN_ARGS_FLAG, flags_of(other_method))
        in_comment = 'class A { public static void main(String[] args) { // args[0] would fail\n System.out.println("args"); } }'
        self.assertNotIn(eo.MAIN_ARGS_FLAG, flags_of(in_comment))

    def test_fail_fast_is_informational(self):
        self.assertIn("fail-fast", flags_of("} catch (ConcurrentModificationException e) {"))
        self.assertNotIn("fail-fast", eo.BLOCKING_FLAGS)
        self.assertNotIn("fail-fast", flags_of("for (String s : list) { System.out.println(s); }"))
        self.assertIn("best-effort", eo.RISK_NOTES["fail-fast"])

    def test_the_four_published_examples_hit_no_new_flag(self):
        examples = Path(__file__).resolve().parents[2] / "src/main/resources/examples"
        for spec in ["primitive-parallel-streams/IntStreamCreationExample",
                     "primitive-parallel-streams/BoxingMapToIntExample",
                     "built-in-functional-interfaces/FunctionExample", "collectors/JoiningExample"]:
            flags = flags_of((examples / f"{spec}.java").read_text(encoding="utf-8"))
            self.assertFalse(eo.BLOCKING_FLAGS.intersection(flags), spec)


class TextOnlyFlagTest(unittest.TestCase):
    """Blocking flags come from the code; a match only in a comment or string is informational."""

    def assertBlocked(self, flag, source):
        flags = flags_of(source)
        self.assertIn(flag, flags, source)
        self.assertIn(flag, eo.BLOCKING_FLAGS)

    def assertTextOnly(self, flag, source):
        flags = flags_of(source)
        self.assertNotIn(flag, flags, source)
        self.assertIn(flag + eo.TEXT_ONLY_SUFFIX, flags, source)
        self.assertNotIn(flag + eo.TEXT_ONLY_SUFFIX, eo.BLOCKING_FLAGS)
        self.assertIn("comment or string", eo.RISK_NOTES[flag + eo.TEXT_ONLY_SUFFIX])

    def test_system_in_only_in_a_comment_with_an_in_memory_scanner(self):
        self.assertTextOnly("stdin", '// works the same with new Scanner(System.in)\n'
                                     'Scanner sc = new Scanner("25\\nAda\\n");')
        self.assertTextOnly("stdin", '/* System.console() */ Scanner sc = new Scanner(text);')

    def test_real_system_in_is_blocked(self):
        self.assertBlocked("stdin", "Scanner sc = new Scanner(System.in);")
        self.assertBlocked("stdin", '// reads a line\nString s = System.console().readLine();')

    def test_random_in_a_comment_does_not_hide_real_stdin(self):
        flags = flags_of("// the secret could come from new Random()\nint secret = 42;\n"
                         "Scanner sc = new Scanner(System.in);")
        self.assertIn("stdin", flags)
        self.assertIn("random" + eo.TEXT_ONLY_SUFFIX, flags)
        self.assertNotIn("random", flags)

    def test_hashmap_only_in_a_string_or_comment_does_not_block(self):
        self.assertTextOnly("hash-order", 'System.out.println("unlike a HashMap, a TreeMap is sorted");')
        self.assertTextOnly("hash-order", 'Map<String, Integer> m = new TreeMap<>(); // not a HashMap')

    def test_real_hashmap_is_blocked(self):
        self.assertBlocked("hash-order", "Map<String, Integer> m = new HashMap<>();")
        self.assertBlocked("hash-order", 'var s = Set.of("a", "b");')

    def test_literals_that_look_like_comments_or_quotes_do_not_hide_real_calls(self):
        # Each literal is followed by a real call on the same line: blanking must stop at the
        # literal's end, not swallow the code after it.
        for prefix in ['String s = "// not a comment"; ', 'String s = "/* not a comment"; ',
                       "char q = '\"'; ", "char q = '\\''; ", 'String e = "a\\"b"; ', 'String e = "\\\\"; ',
                       '/* block */ ', 'String t = """\n  "quoted" // and /* this\n  """; ']:
            self.assertBlocked("stdin", prefix + "Scanner sc = new Scanner(System.in);")
            self.assertBlocked("hash-order", prefix + "Map<String, Integer> m = new HashMap<>();")

    def test_informational_flags_still_see_the_raw_source(self):
        self.assertIn("fail-fast", flags_of("// may throw ConcurrentModificationException\nlist.remove(0);"))
        self.assertIn("locale-format", flags_of('String s = "x"; // or String.format'))

    def test_the_lessons_affected_examples(self):
        def pre(spec):
            return eo.precheck(*spec.split("/"))

        for spec in ["scanner/ScannerBasicsExample", "scanner/ScannerNextIntNextLinePitfallExample"]:
            result = pre(spec)
            self.assertIsNone(result["status"], spec)
            self.assertNotIn("stdin", result["flags"], spec)
            self.assertIn("stdin" + eo.TEXT_ONLY_SUFFIX, result["flags"], spec)
        # ScannerBasicsExample is blocked, but by its nextDouble() (scanner-locale), not by stdin.
        self.assertEqual(eo.blocking_flags(pre("scanner/ScannerBasicsExample")["flags"]), ["scanner-locale"])
        self.assertFalse(eo.BLOCKING_FLAGS.intersection(pre("scanner/ScannerNextIntNextLinePitfallExample")["flags"]))
        self.assertRegex(eo.describe("scanner/ScannerNextIntNextLinePitfallExample"), r"^WILL_RUN\s.*stdin:text-only")
        for spec in ["maps/TreeMapExample", "sets/TreeSetExample"]:
            result = pre(spec)
            self.assertFalse(eo.BLOCKING_FLAGS.intersection(result["flags"]), spec)
            self.assertIn("hash-order" + eo.TEXT_ONLY_SUFFIX, result["flags"], spec)
        guessing = pre("while-do-while/NumberGuessingGameExample")
        self.assertIn("stdin", guessing["flags"])
        self.assertIn("random" + eo.TEXT_ONLY_SUFFIX, guessing["flags"])
        self.assertRegex(eo.describe("while-do-while/NumberGuessingGameExample"), r"^WILL_BE_BLOCKED \(stdin\)")
        self.assertEqual(pre("dynamic-queries-with-specifications/SingleSpecificationExample")["status"], "NON_JDK")


class ScannerLocaleFlagTest(unittest.TestCase):
    """Scanner reads numbers with Locale.getDefault(FORMAT); "5.6" fails where "," is the decimal separator."""

    def assertBlocked(self, source):
        self.assertIn("scanner-locale", flags_of(source), source)

    def assertNotBlocked(self, source):
        self.assertNotIn("scanner-locale", flags_of(source), source)

    def test_decimal_reads_on_a_default_locale_scanner(self):
        for call in ["nextDouble()", "nextFloat()", "nextBigDecimal()", "hasNextDouble()", "hasNextFloat()",
                     "hasNextBigDecimal()"]:
            self.assertBlocked(f'Scanner sc = new Scanner("5.6");\nvar x = sc.{call};')
        self.assertBlocked('var in = new Scanner("1.5 2.5");\ndouble d = in.nextDouble();')
        self.assertBlocked('java.util.Scanner in = new java.util.Scanner("1.5");\ndouble d = in.nextDouble();')
        self.assertBlocked('try (Scanner sc = new Scanner(text)) { double d = sc.nextDouble(); }')
        self.assertBlocked("static double read(Scanner in) { return in.nextDouble(); }")
        self.assertBlocked('double d = new Scanner("1.5").nextDouble();')
        self.assertBlocked('double d = new Scanner(String.valueOf(x)).nextDouble();')

    def test_a_fixed_locale_exempts_that_scanner_and_leaves_a_note(self):
        for source in ['Scanner sc = new Scanner("5.6");\nsc.useLocale(Locale.ROOT);\ndouble d = sc.nextDouble();',
                       'Scanner sc = new Scanner("5.6").useLocale(Locale.US);\ndouble d = sc.nextDouble();',
                       'var sc = new Scanner("5,6").useLocale(Locale.of("tr", "TR"));\ndouble d = sc.nextDouble();']:
            flags = flags_of(source)
            self.assertNotIn("scanner-locale", flags, source)
            self.assertIn("scanner-locale-set", flags, source)
            self.assertNotIn("scanner-locale-set", eo.BLOCKING_FLAGS)
            self.assertIn("useLocale", eo.RISK_NOTES["scanner-locale-set"])

    def test_the_default_locale_or_another_scanners_locale_does_not_exempt(self):
        self.assertBlocked('Scanner sc = new Scanner("5.6");\nsc.useLocale(Locale.getDefault());\n'
                           "double d = sc.nextDouble();")
        self.assertBlocked('Scanner a = new Scanner("1").useLocale(Locale.ROOT);\nScanner b = new Scanner("5.6");\n'
                           "int i = a.nextInt();\ndouble d = b.nextDouble();")

    def test_integer_and_text_reads_and_other_next_double_receivers_are_not_flagged(self):
        self.assertNotBlocked('Scanner sc = new Scanner("42 7");\nint a = sc.nextInt();\nlong b = sc.nextLong();\n'
                              "boolean ok = sc.hasNextInt();\nString w = sc.next();\nString l = sc.nextLine();")
        self.assertNotBlocked("Random r = new Random(1);\ndouble d = r.nextDouble();")
        self.assertNotBlocked("PrimitiveIterator.OfDouble it = DoubleStream.of(1.5).iterator();\n"
                              "double d = it.nextDouble();")

    def test_a_decimal_read_only_in_a_comment_or_string_does_not_block(self):
        source = ('Scanner sc = new Scanner("42");\n// sc.nextDouble() would read "5.6" with the default locale\n'
                  'System.out.println("call sc.nextDouble() for decimals");\nint n = sc.nextInt();')
        flags = flags_of(source)
        self.assertNotIn("scanner-locale", flags)
        self.assertIn("scanner-locale" + eo.TEXT_ONLY_SUFFIX, flags)

    def test_the_lessons_affected_examples(self):
        self.assertRegex(eo.describe("scanner/ScannerBasicsExample"), r"^WILL_BE_BLOCKED \(scanner-locale\)")
        for name in ["ScannerNextIntNextLinePitfallExample", "ScannerDelimiterExample", "ScannerExceptionHandlingExample"]:
            self.assertRegex(eo.describe(f"scanner/{name}"), r"^WILL_RUN\s", name)

    def test_no_published_example_reads_decimals_with_the_default_locale(self):
        manifest = Path(__file__).resolve().parent / "manifest.tsv"
        for line in manifest.read_text(encoding="utf-8").splitlines()[1:]:
            if line.strip():
                spec = "/".join(line.split("\t")[:2])
                self.assertNotIn("scanner-locale", eo.precheck(*spec.split("/"))["flags"], spec)


class IdentityTextFlagTest(unittest.TestCase):
    """An array converted to text prints type + identity hash ("[I@1b6d3586"), never its contents."""

    def assertIdentity(self, source):
        self.assertIn("identity-text", flags_of(source), source)

    def assertNoIdentity(self, source):
        flags = flags_of(source)
        self.assertNotIn("identity-text", flags, source)
        self.assertNotIn("identity-text" + eo.TEXT_ONLY_SUFFIX, flags, source)

    def test_an_array_in_string_concatenation(self):
        self.assertIdentity('int[] numbers = {1, 2};\nSystem.out.println("numbers: " + numbers);')
        self.assertIdentity('String[] names = {"a"};\nString s = names + " are names";')
        self.assertIdentity('int[][] grid = new int[2][2];\nString s = "";\ns += grid;')
        self.assertIdentity('int values[] = {1};\nSystem.out.println("v=" + values);')
        self.assertIdentity('static void show(String... items) { System.out.println("items " + items); }')

    def test_an_array_printed_directly_or_converted_explicitly(self):
        self.assertIdentity("int[] numbers = {1, 2};\nSystem.out.println(numbers);")
        self.assertIdentity("Integer[] boxed = {1};\nSystem.out.print(boxed);")
        self.assertIdentity("double[] d = {1.0};\nnew StringBuilder().append(d);")
        self.assertIdentity("int[] a = {1};\nString s = String.valueOf(a);")
        self.assertIdentity("int[] a = {1};\nString s = a.toString();")
        self.assertIdentity("int[] a = {1};\nString s = Objects.toString(a);")
        self.assertIdentity("char[][] rows = {{'a'}};\nSystem.out.println(rows);")
        self.assertIdentity("char[] letters = {'a'};\nSystem.out.println(\"letters: \" + letters);")

    def test_direct_hash_code_or_object_to_string(self):
        self.assertIdentity("System.out.println(new Object().hashCode());")
        self.assertIdentity("String s = Object.toString(x);")

    def test_the_pattern_only_in_a_comment_or_string_does_not_block(self):
        source = ('int[] numbers = {1, 2};\n// System.out.println("numbers: " + numbers);\n'
                  'System.out.println("print numbers or numbers.toString() directly");')
        flags = flags_of(source)
        self.assertNotIn("identity-text", flags)
        self.assertIn("identity-text" + eo.TEXT_ONLY_SUFFIX, flags)
        only_in_string = flags_of('System.out.println("int[] numbers + numbers");')
        self.assertNotIn("identity-text", only_in_string)
        self.assertEqual(only_in_string, ["identity-text" + eo.TEXT_ONLY_SUFFIX])

    def test_array_contents_lengths_and_elements_are_not_identity_text(self):
        self.assertNoIdentity('int[] numbers = {1, 2};\nSystem.out.println("all: " + Arrays.toString(numbers));')
        self.assertNoIdentity('int[] numbers = {1, 2};\nSystem.out.println("len " + numbers.length + numbers[0]);')
        self.assertNoIdentity('int[][] g = new int[2][2];\nSystem.out.println(Arrays.deepToString(g) + g[0][1]);')
        self.assertNoIdentity("char[] letters = {'a', 'b'};\nSystem.out.println(letters);\n"
                              "String s = String.valueOf(letters);")
        self.assertNoIdentity("int[] a = {1};\nint count = 0;\nSystem.out.println(\"count \" + count);\n"
                              "System.out.println(count + a.length);\na[0]++;")
        self.assertNoIdentity("static int[] build() { return new int[0]; }\n"
                              "int total = 1;\nSystem.out.println(\"total \" + total);")
        self.assertNoIdentity('List<String> names = List.of("a");\nSystem.out.println("names " + names);')

    def test_declared_dimensions(self):
        code = eo.strip_comments_and_strings(
            "int[][] grid = new int[2][2];\nint cells[][] = new int[1][1];\nint[] values = {1};\n"
            "static void rows(int[]... rows) {}\nstatic void items(String... items) {}\n"
            "char[] letters = {'a'};\nchar[]... lines;\nstatic int[] build() { return new int[0]; }")
        self.assertEqual(eo.array_variables(code), {
            "grid": (False, 2), "cells": (False, 2), "values": (False, 1), "rows": (False, 2),
            "items": (False, 1), "letters": (True, 1), "lines": (False, 2)})

    def test_varargs_of_arrays_is_an_array_of_arrays(self):
        self.assertIdentity("static void show(int[]... rows) { System.out.println(\"rows \" + rows); }")
        self.assertIdentity("static void show(int[]... rows) { System.out.println(rows); }")
        self.assertNoIdentity("static void show(int[]... rows) {\n"
                              "    System.out.println(Arrays.deepToString(rows) + Arrays.toString(rows[0]));\n}")

    def test_arrays_to_string_on_an_array_of_arrays(self):
        self.assertIdentity('int[][] grid = {{1, 2}, {3, 4}};\n'
                            'System.out.println("rows: " + Arrays.toString(grid));')
        self.assertIdentity("int grid[][] = new int[2][2];\nString s = Arrays.toString(grid);")
        self.assertIdentity('String[][] names = {{"a"}};\nSystem.out.println(Arrays.toString(names));')
        self.assertIdentity("int[][][] cube = new int[2][2][2];\nString s = Arrays.toString(cube);")
        self.assertIdentity("int[][] grid = new int[2][2];\nString s = java.util.Arrays.toString(grid);")
        self.assertIdentity("static void show(int[]... rows) { System.out.println(Arrays.toString(rows)); }")

    def test_arrays_to_string_on_an_inline_nested_array(self):
        self.assertIdentity("String s = Arrays.toString(new int[][]{{1}, {2}});")
        self.assertIdentity("String s = Arrays.toString(new int[2][3]);")
        self.assertNoIdentity("String s = Arrays.toString(new int[]{1, 2});")

    def test_deep_to_string_rows_and_one_dimensional_arrays_are_not_identity_text(self):
        self.assertNoIdentity('int[][] grid = {{1, 2}, {3, 4}};\n'
                              'System.out.println("deep: " + Arrays.deepToString(grid));\n'
                              'System.out.println("row: " + Arrays.toString(grid[1]));\n'
                              "System.out.println(grid[1][0] + grid.length);")
        self.assertNoIdentity('int[] numbers = {3, 1};\nSystem.out.println("sorted " + Arrays.toString(numbers));')
        self.assertNoIdentity('System.out.println("origins: " + Arrays.toString(annotation.origins()));')

    def test_nested_arrays_to_string_only_in_a_comment_or_string_does_not_block(self):
        source = ('int[][] grid = {{1}};\n// Arrays.toString(grid) would print [[I@...]\n'
                  'System.out.println("not Arrays.toString(grid) but " + Arrays.deepToString(grid));')
        flags = flags_of(source)
        self.assertNotIn("identity-text", flags)
        self.assertIn("identity-text" + eo.TEXT_ONLY_SUFFIX, flags)

    def test_the_lessons_affected_examples(self):
        for name in ["ArrayBasicsExample", "MultiDimensionalArrayExample"]:
            self.assertIn("identity-text", eo.precheck("arrays", name)["flags"], name)
            self.assertRegex(eo.describe(f"arrays/{name}"), r"^WILL_BE_BLOCKED \(identity-text\)", name)
        for name in ["ArraysUtilityExample", "ArrayCovarianceExample", "ArraysVsCollectionsExample",
                     "VarargsExample"]:
            self.assertRegex(eo.describe(f"arrays/{name}"), r"^WILL_RUN\s", name)

    def test_no_published_example_is_identity_text(self):
        manifest = Path(__file__).resolve().parent / "manifest.tsv"
        specs = ["/".join(line.split("\t")[:2])
                 for line in manifest.read_text(encoding="utf-8").splitlines()[1:] if line.strip()]
        self.assertTrue(specs)
        for spec in specs:
            self.assertNotIn("identity-text", eo.precheck(*spec.split("/"))["flags"], spec)


# --- pre-checks: main, imports, multi-file -------------------------------------------

class PrecheckTest(Sandbox):

    def test_snippet_without_main_is_not_run(self):
        self.java("demo", "Snippet", "record Point(int x, int y) {}\n")
        self.assertEqual(eo.precheck("demo", "Snippet")["status"], "NO_MAIN")

    def test_non_jdk_import_is_not_run(self):
        self.java("demo", "Spring", "import org.springframework.stereotype.Service;\n" + HELLO.format(name="Spring", text="x"))
        self.assertEqual(eo.precheck("demo", "Spring")["status"], "NON_JDK")
        self.java("demo", "Jdk", "import java.util.List;\nimport javax.crypto.Cipher;\n" + HELLO.format(name="Jdk", text="x"))
        self.assertIsNone(eo.precheck("demo", "Jdk")["status"])

    def test_example_using_a_type_from_a_sibling_file_is_multi_file(self):
        self.java("demo", "Point", "public record Point(int x, int y) {}\n")
        self.java("demo", "PointUsage", "class PointUsage {\n  public static void main(String[] a) {\n"
                                        "    Point p = new Point(1, 2);\n    System.out.println(p);\n  }\n}\n")
        result = eo.precheck("demo", "PointUsage")
        self.assertEqual(result["status"], "MULTI_FILE")
        self.assertEqual(result["depends_on"], ["Point"])

    def test_sibling_names_in_comments_strings_or_redeclared_do_not_count(self):
        self.java("demo", "Book", "class Book { String title; }\n")
        self.java("demo", "Owns", "class Owns {\n  record Book(String t) {}\n  public static void main(String[] a) {\n"
                                  "    // unlike Book.java\n    System.out.println(\"Book\" + new Book(\"x\"));\n  }\n}\n")
        self.assertIsNone(eo.precheck("demo", "Owns")["status"])

    def test_missing_source(self):
        self.assertEqual(eo.precheck("demo", "Nope")["status"], "MISSING_SOURCE")


# --- generate: blocked examples never reach Docker ------------------------------------

TIMED = ('class Timed {\n    public static void main(String[] args) {\n'
         '        long start = System.nanoTime();\n        System.out.println(System.nanoTime() - start);\n    }\n}\n')


class GenerateBlockingTest(Sandbox):
    """generate with the container layer replaced by fakes: every compile and run is recorded,
    and any real docker call (subprocess) fails the test."""

    def setUp(self):
        super().setUp()
        self.compiled, self.ran = [], []

        def fake_compile(java_file, work_dir):
            self.compiled.append(java_file.stem)
            return {"exit": 0, "timed_out": False, "stdout": b"", "stderr": b"", "classes": work_dir / "classes"}

        def fake_run(main_class, classes, cpus, extra_props):
            self.ran.append(main_class)
            return {"exit": 0, "timed_out": False, "stdout": b"hi\n", "stderr": b"", "truncated": False}

        for name, value in {"compile_example": fake_compile, "run_variant": fake_run,
                            "verify_image": lambda: "test-jdk",
                            "cleanup_leftover_containers": lambda: None}.items():
            patcher = mock.patch.object(eo, name, value)
            patcher.start()
            self.addCleanup(patcher.stop)
        for name in ("run", "Popen"):
            patcher = mock.patch.object(subprocess, name, side_effect=AssertionError("docker called"))
            patcher.start()
            self.addCleanup(patcher.stop)
        self.lesson("loops", tr="{{Hello.java}}\n\n{{Timed.java}}", en="{{Hello.java}}\n\n{{Timed.java}}")
        self.java("loops", "Hello")
        self.java("loops", "Timed", TIMED)

    def generate(self, *specs):
        with redirect_stdout(io.StringIO()) as out:
            eo.cmd_generate(list(specs))
        return out.getvalue()

    def record(self, key):
        return next(r for r in eo.load_results() if eo.record_key(r) == key)

    def test_a_blocked_example_is_neither_compiled_nor_run(self):
        self.assertRegex(eo.describe("loops/Timed"), r"^WILL_BE_BLOCKED \(time\)")
        out = self.generate("loops/Timed")
        self.assertEqual(self.compiled, [])
        self.assertEqual(self.ran, [])
        self.assertRegex(out, r"CONTRACT_BLOCKED\s+loops/Timed")
        record = self.record("loops/Timed")
        self.assertEqual(record["status"], "CONTRACT_BLOCKED")
        self.assertNotIn("compile", record)
        self.assertNotIn("runs", record)

    def test_the_reason_and_status_are_kept_in_results_and_report_and_off_the_sheet(self):
        self.generate("loops/Timed")
        self.assertIn("time", self.record("loops/Timed")["flags"])
        report = (eo.OUT_ROOT / "report.md").read_text(encoding="utf-8")
        self.assertRegex(report, r"- \*\*Timed\*\* -- CONTRACT_BLOCKED; flags: `time` \(blocking\)")
        self.assertIn("0 generated, 1 blocked or not run", report)
        rows = eo.read_review_sheet_unchecked(eo.OUT_ROOT / "review.tsv")
        self.assertEqual(rows, [])

    def test_no_out_is_staged_or_published_and_an_existing_one_is_untouched(self):
        published = eo.EXAMPLES / "loops/Timed.out"
        published.write_bytes(b"published bytes\n")
        stale = eo.STAGING / "loops/Timed.out"
        stale.parent.mkdir(parents=True)
        stale.write_bytes(b"staged by an older run\n")
        manifest = eo.MANIFEST.read_bytes()

        self.generate("loops/Timed")

        self.assertEqual(published.read_bytes(), b"published bytes\n")
        self.assertFalse(stale.exists())
        self.assertEqual(eo.MANIFEST.read_bytes(), manifest)
        with self.assertRaisesRegex(eo.ReviewError, "not GENERATED"):
            eo.plan_promotion("loops/Timed", self.record("loops/Timed"), set())

    def test_a_runnable_example_still_compiles_once_and_runs_every_variant(self):
        self.generate("loops/Hello", "loops/Timed")
        self.assertEqual(self.compiled, ["Hello"])
        self.assertEqual(self.ran, ["Hello"] * len(eo.VARIANTS))
        record = self.record("loops/Hello")
        self.assertEqual(record["status"], "GENERATED")
        self.assertEqual([r["variant"] for r in record["runs"]], [v[0] for v in eo.VARIANTS])
        self.assertEqual((eo.STAGING / "loops/Hello.out").read_bytes(), b"hi\n")
        self.assertEqual([r["key"] for r in eo.read_review_sheet_unchecked(eo.OUT_ROOT / "review.tsv")],
                         ["loops/Hello"])
        self.assertEqual(self.record("loops/Timed")["status"], "CONTRACT_BLOCKED")

    def test_an_array_printed_as_text_is_neither_compiled_nor_run(self):
        self.java("loops", "Arr", "class Arr {\n    public static void main(String[] args) {\n"
                                  "        int[] numbers = {1, 2};\n"
                                  "        System.out.println(\"numbers: \" + numbers);\n    }\n}\n")
        self.generate("loops/Arr", "loops/Hello")
        self.assertEqual(self.compiled, ["Hello"])
        self.assertEqual(self.ran, ["Hello"] * len(eo.VARIANTS))
        record = self.record("loops/Arr")
        self.assertEqual(record["status"], "CONTRACT_BLOCKED")
        self.assertIn("identity-text", record["flags"])
        self.assertFalse((eo.STAGING / "loops/Arr.out").exists())

    def test_a_nested_array_printed_with_arrays_to_string_is_neither_compiled_nor_run(self):
        self.java("loops", "Grid", "import java.util.Arrays;\nclass Grid {\n"
                                   "    public static void main(String[] args) {\n"
                                   "        int[][] grid = {{1, 2}, {3, 4}};\n"
                                   "        System.out.println(Arrays.toString(grid));\n    }\n}\n")
        self.generate("loops/Grid", "loops/Hello")
        self.assertEqual(self.compiled, ["Hello"])
        self.assertEqual(self.ran, ["Hello"] * len(eo.VARIANTS))
        record = self.record("loops/Grid")
        self.assertEqual(record["status"], "CONTRACT_BLOCKED")
        self.assertIn("identity-text", record["flags"])
        self.assertFalse((eo.STAGING / "loops/Grid.out").exists())

    def test_a_default_locale_decimal_scanner_read_is_neither_compiled_nor_run(self):
        self.java("loops", "Height", "import java.util.Scanner;\nclass Height {\n"
                                     "    public static void main(String[] args) {\n"
                                     "        Scanner sc = new Scanner(\"5.6\");\n"
                                     "        System.out.println(sc.nextDouble());\n    }\n}\n")
        self.generate("loops/Height", "loops/Hello")
        self.assertEqual(self.compiled, ["Hello"])
        self.assertEqual(self.ran, ["Hello"] * len(eo.VARIANTS))
        record = self.record("loops/Height")
        self.assertEqual(record["status"], "CONTRACT_BLOCKED")
        self.assertIn("scanner-locale", record["flags"])
        self.assertFalse((eo.STAGING / "loops/Height.out").exists())

    def test_a_blocking_pattern_only_in_a_comment_still_runs(self):
        self.java("loops", "Hello", HELLO.format(name="Hello", text="hi").replace(
            "class Hello", "// System.nanoTime() would differ per run\nclass Hello"))
        self.generate("loops/Hello")
        self.assertEqual(self.compiled, ["Hello"])
        self.assertEqual(self.record("loops/Hello")["status"], "GENERATED")


# --- --topic and --dry-run ------------------------------------------------------------

class TopicAndDryRunTest(Sandbox):

    def setUp(self):
        super().setUp()
        self.lesson("loops", tr="{{A.java}}\n\n{{B.java}}\n\n{{A.java}}\n\n{{Shell.sh}}",
                    en="{{B.java}}\n\n{{C.java}}\n\n{{A.java}}")
        self.lesson("other", tr="{{D.java}}", en="{{D.java}}")
        for name in "ABCD":
            self.java("loops" if name != "D" else "other", name)

    def test_topic_expands_to_java_embeds_tr_order_first_without_duplicates(self):
        self.assertEqual(eo.topic_specs("loops"), ["loops/A", "loops/B", "loops/C"])

    def test_multiple_topics_and_explicit_entries_are_merged_in_order(self):
        self.assertEqual(eo.expand_specs(["other/D", "loops/C"], ["loops", "other"]),
                         ["other/D", "loops/C", "loops/A", "loops/B"])

    def test_unknown_or_malformed_topic_and_empty_selection_abort(self):
        with self.assertRaises(eo.ReviewError):
            eo.expand_specs([], ["no-such-lesson"])
        with self.assertRaises(eo.ReviewError):
            eo.expand_specs([], ["../etc"])
        with self.assertRaises(eo.ReviewError):
            eo.expand_specs([], [])
        with self.assertRaises(eo.ReviewError):
            eo.expand_specs(["loops"], [])
        self.assertIn("unknown lesson", self.abort(eo.cmd_generate, [], ["no-such-lesson"], True))

    def test_dry_run_lists_without_running_or_writing_anything(self):
        self.java("loops", "B", 'class B { public static void main(String[] a) { new java.util.Scanner(System.in); } }')
        self.java("loops", "C", "record C(int x) {}")
        before = snapshot(self.root)
        out = io.StringIO()
        with mock.patch.object(subprocess, "run", side_effect=AssertionError("docker called")), \
                mock.patch.object(subprocess, "Popen", side_effect=AssertionError("docker called")), \
                redirect_stdout(out):
            eo.cmd_generate([], ["loops"], True)
        self.assertEqual(snapshot(self.root), before)
        text = out.getvalue()
        self.assertRegex(text, r"WILL_RUN\s+loops/A")
        self.assertRegex(text, r"WILL_BE_BLOCKED \(stdin\)\s+loops/B")
        self.assertRegex(text, r"NO_MAIN\s+loops/C")
        self.assertIn("nothing was run or written", text)

    def test_generate_refuses_to_overwrite_a_damaged_review_sheet(self):
        (eo.OUT_ROOT / "review.tsv").write_text("not a sheet\n", encoding="utf-8")
        with mock.patch.object(subprocess, "run", side_effect=AssertionError("docker called")):
            self.assertIn("not a valid review sheet", self.abort(eo.cmd_generate, [], ["loops"], False))


# --- results merging ------------------------------------------------------------------

class SaveResultsTest(Sandbox):

    def test_another_lessons_staged_results_and_decisions_are_kept(self):
        first = self.generated("loops", "A", b"a\n")
        eo.write_review_sheet(eo.save_results([first]))
        sheet = eo.OUT_ROOT / "review.tsv"
        sheet.write_text(sheet.read_text().replace(f"{first['out_sha256']}\t\t", f"{first['out_sha256']}\tapprove\t"))

        second = self.generated("other", "D", b"d\n")
        results = eo.save_results([second])
        eo.write_review_sheet(results)

        self.assertEqual([eo.record_key(r) for r in results], ["loops/A", "other/D"])
        self.assertTrue((eo.STAGING / "loops/A.out").exists())
        rows = {r["key"]: r for r in eo.read_review_sheet_unchecked(sheet)}
        self.assertEqual(rows["loops/A"]["decision"], "approve")
        self.assertEqual(rows["other/D"]["decision"], "")

    def test_rerun_replaces_in_place_and_drops_a_no_longer_generated_staged_file(self):
        eo.save_results([self.generated("loops", "A", b"a\n"), self.generated("loops", "B", b"b\n")])
        results = eo.save_results([{"slug": "loops", "name": "A", "java": "x", "status": "NONDETERMINISTIC"}])
        self.assertEqual([(eo.record_key(r), r["status"]) for r in results],
                         [("loops/A", "NONDETERMINISTIC"), ("loops/B", "GENERATED")])
        self.assertFalse((eo.STAGING / "loops/A.out").exists())
        self.assertTrue((eo.STAGING / "loops/B.out").exists())

    def test_a_regenerated_output_needs_a_new_decision(self):
        record = self.generated("loops", "A", b"a\n")
        eo.write_review_sheet(eo.save_results([record]))
        sheet = eo.OUT_ROOT / "review.tsv"
        sheet.write_text(sheet.read_text().replace("\t\t\n", "\tapprove\t\n"))
        eo.write_review_sheet(eo.save_results([self.generated("loops", "A", b"changed\n")]))
        self.assertEqual(eo.read_review_sheet_unchecked(sheet)[0]["decision"], "")


class RiskNoteTest(Sandbox):

    def test_risk_note_is_shown_but_never_a_decision(self):
        record = self.generated("loops", "M", b"Caught: ConcurrentModificationException\n")
        record["flags"] = ["fail-fast"]
        self.results(record)
        results = eo.save_results([record])
        eo.write_review_sheet(results)
        eo.write_report(results, "test")

        row = eo.read_review_sheet_unchecked(eo.OUT_ROOT / "review.tsv")[0]
        self.assertEqual(row["decision"], "")
        self.assertIn("best-effort", row["note"])
        self.assertIn("best-effort", (eo.OUT_ROOT / "report.md").read_text(encoding="utf-8"))
        self.assertIn("no decision", self.abort(eo.cmd_promote_review, eo.OUT_ROOT / "review.tsv", "cdurgun"))
        self.assertFalse((eo.EXAMPLES / "loops/M.out").exists())

    def test_a_reviewers_own_note_is_kept_on_regeneration(self):
        record = self.generated("loops", "M", b"x\n")
        record["flags"] = ["fail-fast"]
        eo.write_review_sheet(eo.save_results([record]))
        sheet = eo.OUT_ROOT / "review.tsv"
        cols = sheet.read_text(encoding="utf-8").splitlines()[1].split("\t")
        cols[3], cols[4] = "reject", "lesson text says it always throws"
        sheet.write_text(eo.REVIEW_HEADER + "\n" + "\t".join(cols) + "\n", encoding="utf-8")
        eo.write_review_sheet(eo.save_results([record]))
        row = eo.read_review_sheet_unchecked(sheet)[0]
        self.assertEqual((row["decision"], row["note"]), ("reject", "lesson text says it always throws"))


# --- promote --review -----------------------------------------------------------------

class PromoteReviewTest(Sandbox):

    def setUp(self):
        super().setUp()
        self.a = self.generated("loops", "A", b"1 2 3 \n")
        self.b = self.generated("loops", "B", b"b\n\n")
        self.results(self.a, self.b)

    def row(self, record, decision, note="", out_sha=None):
        return "\t".join([record["slug"], record["name"], out_sha or record["out_sha256"], decision, note])

    def assert_aborts_without_writing(self, sheet, expected):
        before = snapshot(self.root)
        message = self.abort(eo.cmd_promote_review, sheet, "cdurgun")
        self.assertIn(expected, message)
        self.assertEqual(snapshot(self.root), before)

    def test_approve_and_reject_rows(self):
        sheet = self.sheet(self.row(self.a, "approve"), self.row(self.b, "reject", "not what the lesson shows"))
        out = io.StringIO()
        with redirect_stdout(out):
            eo.cmd_promote_review(sheet, "cdurgun")
        self.assertEqual((eo.EXAMPLES / "loops/A.out").read_bytes(), b"1 2 3 \n")
        self.assertFalse((eo.EXAMPLES / "loops/B.out").exists())
        manifest = eo.MANIFEST.read_text().splitlines()
        self.assertEqual(len(manifest), 2)
        self.assertTrue(manifest[1].startswith(f"loops\tA\t{self.a['java_sha256']}\t{self.a['out_sha256']}\t"))
        self.assertIn("\tapproved\tcdurgun\t", manifest[1])
        self.assertIn("REJECTED loops/B -- not what the lesson shows", out.getvalue())

    def test_all_rejected_writes_nothing(self):
        sheet = self.sheet(self.row(self.a, "reject"), self.row(self.b, "reject"))
        before = snapshot(self.root)
        with redirect_stdout(io.StringIO()):
            eo.cmd_promote_review(sheet, "cdurgun")
        self.assertEqual(snapshot(self.root), before)

    def test_missing_decision(self):
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(self.b, "")),
                                           "loops/B: no decision")

    def test_invalid_decision(self):
        for bad in ("Approve", "ok", "approve ", "yes"):
            self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(self.b, bad)),
                                               "invalid decision")

    def test_duplicate_row(self):
        self.assert_aborts_without_writing(
            self.sheet(self.row(self.a, "approve"), self.row(self.b, "reject"), self.row(self.a, "reject")),
            "appears more than once")

    def test_unknown_example(self):
        ghost = dict(self.a, name="Ghost")
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(ghost, "approve")),
                                           "loops/Ghost: not a GENERATED example")

    def test_example_that_is_no_longer_generated(self):
        self.results(self.a, dict(self.b, status="NONDETERMINISTIC"))
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(self.b, "reject")),
                                           "loops/B: not a GENERATED example")

    def test_malformed_tsv(self):
        for broken in ([self.row(self.a, "approve").replace("\t", " ", 1)],          # 4 columns
                       [self.row(self.a, "approve") + "\textra"],                     # 6 columns
                       ["", self.row(self.a, "approve")],                             # blank line
                       [self.row(self.a, "approve").replace(self.a["out_sha256"], "abc")]):
            self.assert_aborts_without_writing(self.sheet(*broken), "line ")
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), header="slug\texample"),
                                           "header")
        missing = eo.OUT_ROOT / "missing.tsv"
        self.assertIn("does not exist", self.abort(eo.cmd_promote_review, missing, "cdurgun"))

    def test_sheet_hash_differs_from_generated_output(self):
        self.assert_aborts_without_writing(
            self.sheet(self.row(self.a, "approve", out_sha=sha(b"something else\n")), self.row(self.b, "reject")),
            "review.tsv out_sha256 does not match")

    def test_staged_file_changed_after_review(self):
        (eo.STAGING / "loops/A.out").write_bytes(b"1 2 3\n")
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(self.b, "reject")),
                                           "staged .out no longer matches")

    def test_java_changed_after_generation(self):
        (eo.EXAMPLES / "loops/A.java").write_text("class A {}\n")
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(self.b, "reject")),
                                           "the .java changed")

    def test_already_promoted(self):
        (eo.EXAMPLES / "loops/A.out").write_bytes(b"1 2 3 \n")
        self.assert_aborts_without_writing(self.sheet(self.row(self.a, "approve"), self.row(self.b, "reject")),
                                           "already promoted")

    def test_every_problem_is_reported_and_one_bad_row_blocks_the_good_ones(self):
        self.assert_aborts_without_writing(
            self.sheet(self.row(self.a, "approve"), self.row(self.b, "maybe"), self.row(dict(self.a, name="X"), "")),
            "invalid decision")
        message = self.abort(eo.cmd_promote_review,
                             self.sheet(self.row(self.a, "approve"), self.row(self.b, "maybe"),
                                        self.row(dict(self.a, name="X"), "")), "cdurgun")
        self.assertIn("loops/B", message)
        self.assertIn("loops/X", message)
        self.assertFalse((eo.EXAMPLES / "loops/A.out").exists())

    def test_reviewer_is_required(self):
        message = self.abort(eo.cmd_promote_review, self.sheet(self.row(self.a, "approve")), " ")
        self.assertIn("--reviewer", message)

    def test_a_failed_write_is_rolled_back(self):
        sheet = self.sheet(self.row(self.a, "approve"), self.row(self.b, "approve"))
        before = snapshot(self.root)
        real_write = Path.write_bytes

        def fail_on_b(path, data):
            if path.name == "B.out":
                raise OSError("disk full")
            return real_write(path, data)

        with mock.patch.object(Path, "write_bytes", fail_on_b), self.assertRaises(OSError):
            eo.cmd_promote_review(sheet, "cdurgun")
        self.assertEqual(snapshot(self.root), before)


# --- the explicit promote form keeps working ------------------------------------------

class LegacyPromoteTest(Sandbox):

    def test_explicit_entries_still_promote_byte_for_byte(self):
        record = self.generated("loops", "A", b"1 2 3 4 \n")
        self.results(record)
        with redirect_stdout(io.StringIO()):
            eo.cmd_promote(["loops/A"], "cdurgun")
        self.assertEqual((eo.EXAMPLES / "loops/A.out").read_bytes(), b"1 2 3 4 \n")
        self.assertEqual(len(eo.MANIFEST.read_text().splitlines()), 2)

    def test_explicit_entries_are_all_or_nothing(self):
        self.results(self.generated("loops", "A", b"a\n"))
        before = snapshot(self.root)
        self.assertIn("loops/B is not GENERATED", self.abort(eo.cmd_promote, ["loops/A", "loops/B"], "cdurgun"))
        self.assertEqual(snapshot(self.root), before)

    def test_results_written_before_this_change_still_load(self):
        # Pilot-era records: no depends_on, no new statuses.
        record = self.generated("loops", "A", b"a\n")
        record.pop("out_matches_raw_stdout")
        self.results(record)
        with redirect_stdout(io.StringIO()):
            eo.cmd_promote(["loops/A"], "cdurgun")
        self.assertTrue((eo.EXAMPLES / "loops/A.out").exists())


class StagingLocationTest(unittest.TestCase):
    """Staged, not yet promoted outputs must survive `mvn clean` and never be committed."""

    def test_staging_is_outside_the_maven_build_directory(self):
        target = (eo.ROOT / "target").resolve()
        for path in (eo.OUT_ROOT, eo.WORK, eo.STAGING):
            self.assertNotIn(target, path.resolve().parents, path)
            self.assertNotEqual(target, path.resolve(), path)
        self.assertEqual(eo.OUT_ROOT, eo.WORK.parent)
        self.assertEqual(eo.OUT_ROOT, eo.STAGING.parent)

    def test_maven_clean_is_not_configured_to_delete_staging(self):
        # maven-clean-plugin deletes target/ plus any configured <filesets>.
        pom = (eo.ROOT / "pom.xml").read_text(encoding="utf-8")
        self.assertNotIn(eo.OUT_ROOT.name, pom)

    def test_staging_is_git_ignored(self):
        probe = eo.STAGING / "some-topic" / "Example.out"
        result = subprocess.run(["git", "-C", str(eo.ROOT), "check-ignore", "-q", "--no-index", str(probe)],
                                capture_output=True)
        if result.returncode == 128:
            self.skipTest("not a git checkout")
        self.assertEqual(0, result.returncode, "staging must be listed in .gitignore")


if __name__ == "__main__":
    unittest.main()
