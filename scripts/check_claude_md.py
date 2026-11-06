#!/usr/bin/env python3
"""CLAUDE.md size/history budget report (warn-only).

Checks ONLY the repository-root CLAUDE.md. Python stdlib only.

Measures:
  * size in UTF-8 bytes (the primary measure), lines, estimated tokens;
  * per-H2-section bytes (informational);
  * "GUNCELLEME (Faz N)" history markers, with line number and the byte size of the
    paragraph/bullet block that contains each one (informational).

Thresholds are PROVISIONAL (Stage 7 of the CLAUDE.md trim) and never fail the run:
the exit code is 0 unless --strict is passed. --strict exists for later stages and
is not used by the hook or CI today. To be re-evaluated after the Stage 8 /context
measurement.

Modes:
  default   human readable report (all details), exit 0
  --github  also emit GitHub Actions ::warning:: annotations
  --hook    read a Claude Code PostToolUse JSON from stdin; react only to
            Edit/Write/MultiEdit on the root CLAUDE.md; silent under thresholds
"""
import argparse
import json
import os
import re
import subprocess
import sys

# --- Provisional thresholds (Stage 7). Single source for the hook and CI. -------------
MAX_BYTES = 80_000
MAX_UPDATE_MARKERS = 12
# Calibration: 89,126 B measured as ~45k tokens via /context (2026-11) => 1.98 B/token.
BYTES_PER_TOKEN = 1.98
HOOK_TOOLS = ("Edit", "Write", "MultiEdit")

# The marker is spelled with a Turkish capital U-umlaut; also accept the ASCII spelling.
MARKER_RE = re.compile(r"G(?:Ü|U)NCELLEME \(Faz ([^)]*)\)")
H2_RE = re.compile(r"^## (.+)$")


def measure(text):
    """Return a dict of measurements for the given CLAUDE.md text."""
    raw = text.encode("utf-8")
    lines = _split_lines(text)
    sections = _sections(lines)
    markers = _markers(lines)
    return {
        "bytes": len(raw),
        "lines": len(lines),
        "est_tokens": round(len(raw) / BYTES_PER_TOKEN),
        "sections": sections,
        "markers": markers,
        "faz_mentions": len(re.findall(r"\bFaz \d+", text)),
        "v_numbers": len(re.findall(r"\bV\d+\b", text)),
    }


def _split_lines(text):
    """Lines WITH their trailing newline (only \\n splits), so sizes add up to the file."""
    return re.findall(r"[^\n]*\n|[^\n]+", text)


def _sections(lines):
    """List of (title, start_line, bytes). Text before the first H2 is '(preamble)'."""
    out = []
    title, start, size = "(preamble)", 1, 0
    in_fence = False
    for no, raw_line in enumerate(lines, 1):
        line = raw_line.rstrip("\n")
        if line.startswith("```"):
            in_fence = not in_fence
        m = None if in_fence else H2_RE.match(line)
        if m:
            out.append((title, start, size))
            title, start, size = m.group(1).strip(), no, 0
        size += len(raw_line.encode("utf-8"))
    out.append((title, start, size))
    return [s for s in out if s[2] > 0]


def _markers(lines):
    """List of (line_no, label, block_bytes). Block = from the marker line up to the
    line before the next blank line or the next marker (the text that belongs to it)."""
    found = []
    for idx, line in enumerate(lines):
        m = MARKER_RE.search(line)
        if not m:
            continue
        hi = idx
        while (hi + 1 < len(lines) and lines[hi + 1].strip() != ""
               and not MARKER_RE.search(lines[hi + 1])):
            hi += 1
        block = "".join(lines[idx:hi + 1]).rstrip("\n")
        found.append((idx + 1, "Faz " + m.group(1), len(block.encode("utf-8"))))
    return found


def warnings(result, max_bytes=MAX_BYTES, max_markers=MAX_UPDATE_MARKERS):
    """Provisional warnings. Never errors."""
    out = []
    if result["bytes"] > max_bytes:
        out.append("CLAUDE.md is %s B (> %s B provisional limit); every session pays for it."
                   % (f"{result['bytes']:,}", f"{max_bytes:,}"))
    n = len(result["markers"])
    if n > max_markers:
        out.append("CLAUDE.md has %d 'GUNCELLEME (Faz N)' history paragraphs "
                   "(> %d); history belongs in docs/phase-log.md."
                   % (n, max_markers))
    return out


def report(result, warns):
    lines = [
        "CLAUDE.md: %s B, %d lines, ~%s tokens (est. at %.2f B/token)"
        % (f"{result['bytes']:,}", result["lines"], f"{result['est_tokens']:,}", BYTES_PER_TOKEN),
        "Provisional limits: %s B, %d update markers (warn-only)"
        % (f"{MAX_BYTES:,}", MAX_UPDATE_MARKERS),
        "",
        "Sections (H2, bytes):",
    ]
    for title, start, size in result["sections"]:
        lines.append("  %6s  L%-4d %s" % (f"{size:,}", start, title))
    lines.append("")
    lines.append("GUNCELLEME markers: %d" % len(result["markers"]))
    for no, label, size in result["markers"]:
        lines.append("  L%-4d %-14s block %s B" % (no, label, f"{size:,}"))
    lines.append("")
    lines.append("Info: 'Faz N' mentions=%d, V-number tokens=%d"
                 % (result["faz_mentions"], result["v_numbers"]))
    for w in warns:
        lines.append("WARNING: " + w)
    if not warns:
        lines.append("OK: under the provisional limits.")
    return "\n".join(lines)


def repo_root(start=None):
    """Git top-level directory (fallback: parent of scripts/)."""
    try:
        out = subprocess.run(["git", "rev-parse", "--show-toplevel"], cwd=start or None,
                             capture_output=True, text=True, timeout=10, check=True)
        return out.stdout.strip()
    except Exception:
        return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def is_root_claude_md(file_path, root):
    """True only for <root>/CLAUDE.md (symlink/relative safe)."""
    if not file_path:
        return False
    target = os.path.realpath(os.path.join(root, "CLAUDE.md"))
    return os.path.realpath(file_path) == target


def hook_decision(payload, root):
    """Pure helper for --hook: True when the payload is an edit of root CLAUDE.md."""
    if not isinstance(payload, dict) or payload.get("tool_name") not in HOOK_TOOLS:
        return False
    tool_input = payload.get("tool_input")
    if not isinstance(tool_input, dict):
        return False
    return is_root_claude_md(tool_input.get("file_path"), root)


def run_hook(stdin_text, root):
    """Return (exit_code, stdout_text, stderr_text). Fail-open: never exit 2.

    Silent (0, "", "") for other files and for CLAUDE.md under the thresholds.
    Over a threshold: exit 0 with a JSON systemMessage (shown to the user) and
    additionalContext (shown to Claude). Internal errors: a short visible stderr
    note with exit 1 (non-blocking), never 2.
    """
    try:
        payload = json.loads(stdin_text)
    except Exception as exc:
        return 1, "", "check_claude_md hook: unreadable stdin JSON (%s); skipped." % exc
    try:
        if not hook_decision(payload, root):
            return 0, "", ""
        with open(os.path.join(root, "CLAUDE.md"), encoding="utf-8") as fh:
            result = measure(fh.read())
        warns = warnings(result)
        if not warns:
            return 0, "", ""
        msg = ("CLAUDE.md budget warning (non-blocking): " + " ".join(warns)
               + " [%s B, %d markers]" % (f"{result['bytes']:,}", len(result["markers"])))
        out = {
            "systemMessage": msg,
            "hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": msg},
        }
        return 0, json.dumps(out, ensure_ascii=False), ""
    except Exception as exc:
        return 1, "", "check_claude_md hook: internal error (%s); skipped." % exc


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--path", help="override CLAUDE.md path (tests); default: <git root>/CLAUDE.md")
    ap.add_argument("--github", action="store_true", help="emit ::warning:: annotations")
    ap.add_argument("--hook", action="store_true", help="Claude Code PostToolUse mode (stdin JSON)")
    ap.add_argument("--strict", action="store_true",
                    help="exit 1 when a threshold is exceeded (NOT used by hook/CI at this stage)")
    args = ap.parse_args(argv)

    root = repo_root()
    if args.hook:
        code, out, err = run_hook(sys.stdin.read(), root)
        if out:
            print(out)
        if err:
            print(err, file=sys.stderr)
        return code

    path = args.path or os.path.join(root, "CLAUDE.md")
    try:
        with open(path, encoding="utf-8") as fh:
            result = measure(fh.read())
    except OSError as exc:
        print("cannot read %s: %s" % (path, exc), file=sys.stderr)
        return 1 if args.strict else 0
    warns = warnings(result)
    print(report(result, warns))
    if args.github:
        for w in warns:
            print("::warning file=CLAUDE.md::" + w)
    return 1 if (args.strict and warns) else 0


if __name__ == "__main__":
    sys.exit(main())
