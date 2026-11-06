import json
import os
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import check_claude_md as c

SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "check_claude_md.py")
U = "GÜNCELLEME"


class Measure(unittest.TestCase):
    def test_bytes_are_utf8_not_chars(self):
        r = c.measure("ğüş")  # 3 chars, 6 bytes
        self.assertEqual(r["bytes"], 6)

    def test_lines_and_tokens(self):
        r = c.measure("a\nb\nc")
        self.assertEqual(r["lines"], 3)
        self.assertEqual(r["est_tokens"], round(5 / c.BYTES_PER_TOKEN))

    def test_sections(self):
        r = c.measure("intro\n## A\nxx\n## B\nyyyy\n")
        titles = [s[0] for s in r["sections"]]
        self.assertEqual(titles, ["(preamble)", "A", "B"])
        self.assertEqual(sum(s[2] for s in r["sections"]), r["bytes"])

    def test_h2_inside_fence_ignored(self):
        r = c.measure("## A\n```\n## not\n```\n")
        self.assertEqual([s[0] for s in r["sections"]], ["A"])

    def test_markers_line_label_block(self):
        text = "x\n\n- **%s (Faz 96):** a\n  continues\n\nother\n- **%s (Faz 160/161):** z\n" % (U, U)
        r = c.measure(text)
        self.assertEqual([(m[0], m[1]) for m in r["markers"]], [(3, "Faz 96"), (7, "Faz 160/161")])
        self.assertEqual(r["markers"][0][2], len(("- **%s (Faz 96):** a\n  continues" % U).encode("utf-8")))
        self.assertEqual(r["lines"], 7)

    def test_ascii_spelling_and_non_markers(self):
        r = c.measure("GUNCELLEME (Faz 5) ok\nGÜNCELLEME without faz\nGÜNCELLEME (Faz)\n")
        self.assertEqual(len(r["markers"]), 1)

    def test_two_markers_one_paragraph(self):
        r = c.measure("%s (Faz 1) a\n%s (Faz 2) b\n" % (U, U))
        self.assertEqual([m[2] for m in r["markers"]], [len(("%s (Faz 1) a" % U).encode()), len(("%s (Faz 2) b" % U).encode())])

    def test_empty(self):
        r = c.measure("")
        self.assertEqual(r["bytes"], 0)
        self.assertEqual(r["markers"], [])


class Thresholds(unittest.TestCase):
    def fake(self, b, n):
        return {"bytes": b, "markers": [(1, "Faz 1", 1)] * n}

    def test_at_limits_no_warning(self):
        self.assertEqual(c.warnings(self.fake(80_000, 12)), [])

    def test_bytes_over(self):
        w = c.warnings(self.fake(80_001, 0))
        self.assertEqual(len(w), 1)
        self.assertIn("80,001", w[0])

    def test_markers_over(self):
        w = c.warnings(self.fake(1, 13))
        self.assertEqual(len(w), 1)
        self.assertIn("13", w[0])

    def test_both(self):
        self.assertEqual(len(c.warnings(self.fake(90_000, 20))), 2)

    def test_report_mentions_warning(self):
        r = c.measure("x")
        self.assertIn("OK", c.report(r, []))
        self.assertIn("WARNING: boom", c.report(r, ["boom"]))


class HookDecision(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        self.root = os.path.realpath(self.tmp)
        self.md = os.path.join(self.root, "CLAUDE.md")

    def payload(self, tool, path):
        return {"tool_name": tool, "tool_input": {"file_path": path}}

    def test_root_claude_md_tools(self):
        for t in ("Edit", "Write", "MultiEdit"):
            self.assertTrue(c.hook_decision(self.payload(t, self.md), self.root))

    def test_other_tools_and_files(self):
        self.assertFalse(c.hook_decision(self.payload("Read", self.md), self.root))
        self.assertFalse(c.hook_decision(self.payload("Edit", os.path.join(self.root, "README.md")), self.root))
        self.assertFalse(c.hook_decision(self.payload("Edit", os.path.join(self.root, "docs", "CLAUDE.md")), self.root))
        self.assertFalse(c.hook_decision(self.payload("Edit", self.md + ".bak"), self.root))

    def test_malformed_payloads(self):
        for p in (None, [], {}, {"tool_name": "Edit"}, {"tool_name": "Edit", "tool_input": "x"},
                  {"tool_name": "Edit", "tool_input": {}}):
            self.assertFalse(c.hook_decision(p, self.root))


class RunHook(unittest.TestCase):
    def setUp(self):
        self.root = os.path.realpath(tempfile.mkdtemp())
        self.md = os.path.join(self.root, "CLAUDE.md")

    def write(self, text):
        with open(self.md, "w", encoding="utf-8") as fh:
            fh.write(text)

    def stdin(self, path=None, tool="Edit"):
        return json.dumps({"tool_name": tool, "tool_input": {"file_path": path or self.md}})

    def test_silent_under_threshold(self):
        self.write("small\n")
        self.assertEqual(c.run_hook(self.stdin(), self.root), (0, "", ""))

    def test_silent_for_other_file_even_when_claude_md_is_huge(self):
        self.write("x" * 90_000)
        self.assertEqual(c.run_hook(self.stdin(os.path.join(self.root, "a.md")), self.root), (0, "", ""))

    def test_warns_over_threshold_exit_zero_with_json(self):
        self.write("x" * 90_000)
        code, out, err = c.run_hook(self.stdin(), self.root)
        self.assertEqual(code, 0)
        self.assertEqual(err, "")
        data = json.loads(out)
        self.assertIn("90,000", data["systemMessage"])
        self.assertEqual(data["hookSpecificOutput"]["hookEventName"], "PostToolUse")
        self.assertIn("90,000", data["hookSpecificOutput"]["additionalContext"])

    def test_bad_stdin_is_visible_but_never_blocking(self):
        code, out, err = c.run_hook("not json", self.root)
        self.assertEqual(code, 1)
        self.assertIn("unreadable", err)

    def test_missing_file_is_visible_not_blocking(self):
        code, out, err = c.run_hook(self.stdin(), self.root)  # CLAUDE.md not created
        self.assertEqual(code, 1)
        self.assertIn("internal error", err)

    def test_never_exit_two(self):
        for s in ("", "{", "[]", self.stdin()):
            self.assertNotEqual(c.run_hook(s, self.root)[0], 2)


class Cli(unittest.TestCase):
    def run_cli(self, text, *extra):
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "CLAUDE.md")
            with open(p, "w", encoding="utf-8") as fh:
                fh.write(text)
            return subprocess.run([sys.executable, "-I", SCRIPT, "--path", p, *extra],
                                  capture_output=True, text=True)

    def test_warn_only_exit_zero(self):
        r = self.run_cli("x" * 90_000)
        self.assertEqual(r.returncode, 0)
        self.assertIn("WARNING", r.stdout)

    def test_strict_exits_one_only_when_over(self):
        self.assertEqual(self.run_cli("x" * 90_000, "--strict").returncode, 1)
        self.assertEqual(self.run_cli("ok", "--strict").returncode, 0)

    def test_github_annotation(self):
        r = self.run_cli("x" * 90_000, "--github")
        self.assertIn("::warning file=CLAUDE.md::", r.stdout)

    def test_missing_file_nonstrict_zero(self):
        r = subprocess.run([sys.executable, "-I", SCRIPT, "--path", "/nonexistent/CLAUDE.md"],
                           capture_output=True, text=True)
        self.assertEqual(r.returncode, 0)
        self.assertIn("cannot read", r.stderr)

    def test_hook_cli_other_file_silent(self):
        r = subprocess.run([sys.executable, "-I", SCRIPT, "--hook"], input=json.dumps(
            {"tool_name": "Edit", "tool_input": {"file_path": "/tmp/x.md"}}),
            capture_output=True, text=True)
        self.assertEqual((r.returncode, r.stdout, r.stderr), (0, "", ""))


class RealFile(unittest.TestCase):
    def test_real_claude_md_parses(self):
        root = c.repo_root()
        with open(os.path.join(root, "CLAUDE.md"), encoding="utf-8") as fh:
            r = c.measure(fh.read())
        self.assertGreater(r["bytes"], 0)
        self.assertTrue(r["sections"])


if __name__ == "__main__":
    unittest.main()
