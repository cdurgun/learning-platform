#!/usr/bin/env python3
"""Tests for check_deploy.py's deployment lookup (no network, no Railway/GitHub calls):

    python3 -B -m unittest discover -s .claude/skills/deploy-check -p 'test_*.py'

Railway is the source of truth for "is this commit live"; the GitHub deployment record is only
diagnostics. Anything that cannot be confirmed from Railway must never count as success.
"""
import io
import json
import subprocess
import sys
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest import mock

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import check_deploy as cd  # noqa: E402

HEAD = "e8b3d1b132a95fc6519c038d1020e362b37fcc2a"
OLD = "93c469374b2a297333e5d96ca80fa3525c9c3151"


def row(status, sha=HEAD, created="2026-10-20T13:35:12.220Z", repo=cd.REPO, deployment_id=None):
    meta = {"repo": repo, "branch": "main"}
    if sha is not None:
        meta["commitHash"] = sha
    return {"id": deployment_id or f"{status.lower()}-{created}", "status": status, "createdAt": created, "meta": meta}


def cli(rows=None, stdout=None, returncode=0, stderr=""):
    out = stdout if stdout is not None else json.dumps(rows or [])
    return subprocess.CompletedProcess(["railway"], returncode, stdout=out, stderr=stderr)


def railway(*results):
    """Patches subprocess.run for the Railway CLI; each call returns the next result."""
    return mock.patch.object(cd.subprocess, "run", side_effect=list(results))


def git_at(head=HEAD, local=None):
    return mock.patch.object(cd, "git", side_effect=lambda *args: head if args[-1] == "origin/main" else (local or head))


# --- railway deployment list ---------------------------------------------------------

class RailwayDeploymentsTest(unittest.TestCase):

    def test_reads_this_service_from_the_repo_root_newest_first(self):
        rows = [row("REMOVED", OLD, "2026-10-20T10:48:19.205Z"), row("SUCCESS", HEAD, "2026-10-20T13:35:12.220Z")]
        with railway(cli(rows)) as run:
            result, problem = cd.railway_deployments()
        self.assertIsNone(problem)
        self.assertEqual([r["meta"]["commitHash"] for r in result], [HEAD, OLD])
        command, kwargs = run.call_args.args[0], run.call_args.kwargs
        self.assertEqual(command[:3], ["railway", "deployment", "list"])
        self.assertIn("--json", command)
        self.assertEqual(command[command.index("--service") + 1], "learning-platform")
        self.assertEqual(command[command.index("--environment") + 1], "production")
        self.assertEqual(kwargs["cwd"], cd.ROOT)
        self.assertIn("timeout", kwargs)

    def test_cli_failures_are_never_success(self):
        cases = {
            "exit code": cli(returncode=1, stdout="", stderr="No linked project found"),
            "bad json": cli(stdout="not json"),
            "not a list": cli(stdout=json.dumps({"deployments": []})),
            "missing field": cli(stdout=json.dumps([{"id": "x", "status": "SUCCESS"}])),
            "bad date": cli(stdout=json.dumps([row("SUCCESS", created="yesterday")])),
        }
        for label, result in cases.items():
            with railway(result):
                rows, problem = cd.railway_deployments()
            self.assertIsNone(rows, label)
            self.assertTrue(problem, label)

    def test_missing_cli_and_timeout_are_never_success(self):
        for error in (FileNotFoundError("railway"), subprocess.TimeoutExpired("railway", 30)):
            with railway(error):
                rows, problem = cd.railway_deployments()
            self.assertIsNone(rows)
            self.assertIn(type(error).__name__, problem)


# --- the state of origin/main's deployment -------------------------------------------

class DeploymentStateTest(unittest.TestCase):

    def state(self, rows):
        with git_at(), railway(cli(rows)):
            return cd.deployment_state()[1]

    def test_status_mapping(self):
        expected = {"SUCCESS": "success", "FAILED": "failure", "CRASHED": "failure", "SKIPPED": "skipped",
                    "REMOVED": "removed", "WAITING": "in_progress", "INITIALIZING": "in_progress",
                    "BUILDING": "in_progress", "DEPLOYING": "in_progress",
                    "COMPLETED": "unknown", "SLEEPING": "unknown", "SOMETHING_NEW": "unknown"}
        for status, state in expected.items():
            self.assertEqual(self.state([row(status)]), state, status)

    def test_newest_deployment_of_the_commit_wins(self):
        redeployed = [row("SUCCESS", created="2026-10-20T13:35:12Z"), row("BUILDING", created="2026-10-20T14:00:00Z")]
        self.assertEqual(self.state(redeployed), "in_progress")
        failed_again = [row("FAILED", created="2026-10-20T14:00:00Z"), row("SUCCESS", created="2026-10-20T13:35:12Z")]
        self.assertEqual(self.state(failed_again), "failure")

    def test_rows_of_another_commit_repo_or_service_do_not_match(self):
        others = [row("SUCCESS", OLD), row("SUCCESS", HEAD, repo="someone/else"),
                  row("SUCCESS", sha=None)]  # the Postgres service: SUCCESS without a commit
        self.assertIsNone(self.state(others))

    def test_unreadable_railway(self):
        with git_at(), railway(cli(returncode=1, stdout="", stderr="Unauthorized")):
            head, state, detail = cd.deployment_state()
        self.assertEqual((head, state), (HEAD, "unreadable"))
        self.assertIn("Unauthorized", detail)


# --- which commit is live ------------------------------------------------------------

class LiveDeploymentTest(unittest.TestCase):

    def live(self, rows):
        with railway(cli(rows)):
            return cd.live_deployment()

    def test_single_newest_success_is_live(self):
        sha, problem = self.live([row("SUCCESS", HEAD, "2026-10-20T13:35:12Z"),
                                  row("REMOVED", OLD, "2026-10-20T10:48:19Z")])
        self.assertEqual((sha, problem), (HEAD, None))

    def test_an_older_success_behind_a_newer_deployment_is_not_live(self):
        for newer in ("FAILED", "CRASHED", "SKIPPED", "WAITING", "BUILDING", "DEPLOYING", "COMPLETED", "NEW_STATE"):
            sha, problem = self.live([row(newer, HEAD, "2026-10-20T13:35:12Z"),
                                      row("SUCCESS", OLD, "2026-10-20T10:48:19Z")])
            self.assertIsNone(sha, newer)
            self.assertIn(newer, problem)

    def test_two_successes_at_once_are_ambiguous(self):
        sha, problem = self.live([row("SUCCESS", HEAD, "2026-10-20T13:39:30Z"),
                                  row("SUCCESS", OLD, "2026-10-20T10:48:19Z")])
        self.assertIsNone(sha)
        self.assertIn("belirsiz", problem)

    def test_success_without_a_commit_of_this_repo_is_not_live(self):
        for newest in (row("SUCCESS", sha=None), row("SUCCESS", HEAD, repo="someone/else")):
            sha, problem = self.live([newest])
            self.assertIsNone(sha)
            self.assertTrue(problem)

    def test_no_rows_or_unreadable(self):
        self.assertIsNone(self.live([])[0])
        with railway(cli(stdout="{broken")):
            self.assertIsNone(cd.live_deployment()[0])


# --- --wait ------------------------------------------------------------------------------

class WaitTest(unittest.TestCase):

    def wait(self, *results, timeout=900):
        with git_at(), railway(*results), mock.patch.object(cd.time, "sleep"), redirect_stdout(io.StringIO()) as out:
            return cd.wait_for_deployment(timeout), out.getvalue()

    def test_waiting_then_building_then_success(self):
        ok, out = self.wait(cli([]), cli([row("WAITING")]), cli([row("BUILDING")]), cli([row("DEPLOYING")]),
                            cli([row("SUCCESS")]))
        self.assertTrue(ok)
        for step in ("henüz başlamadı", "WAITING", "BUILDING", "DEPLOYING", "SUCCESS"):
            self.assertIn(step, out)

    def test_terminal_non_success_stops_waiting(self):
        for status in ("SKIPPED", "FAILED", "CRASHED", "REMOVED"):
            ok, _ = self.wait(cli([row("WAITING")]), cli([row(status)]))
            self.assertFalse(ok, status)

    def test_unreadable_railway_is_retried_not_trusted(self):
        ok, out = self.wait(cli(returncode=1, stdout="", stderr="timeout"), cli([row("SUCCESS")]))
        self.assertTrue(ok)
        self.assertIn("Railway okunamadı", out)

    def test_unknown_state_never_succeeds(self):
        clock = iter(range(0, 10_000, 100))
        with mock.patch.object(cd.time, "time", side_effect=lambda: next(clock)):
            ok, _ = self.wait(*[cli([row("COMPLETED")])] * 20, timeout=900)
        self.assertFalse(ok)


# --- main(): deployment section and the Expected Output gate --------------------------

class MainTest(unittest.TestCase):

    def main(self, argv, railway_rows=None, railway_result=None, github="success", local=None):
        calls = []
        results = railway_result if railway_result is not None else cli(railway_rows)

        def fake_run(*args, **kwargs):
            calls.append(args[0])
            return results

        with mock.patch.object(sys, "argv", ["check_deploy.py", *argv]), git_at(local=local), \
                mock.patch.object(cd.subprocess, "run", side_effect=fake_run), \
                mock.patch.object(cd, "github_state", return_value=github) as github_state, \
                mock.patch.object(cd, "run_checks") as run_checks, mock.patch.object(cd.time, "sleep"), \
                redirect_stdout(io.StringIO()) as out:
            code = cd.main()
        gate = run_checks.call_args.args[2:] if run_checks.called else None
        return code, gate, out.getvalue(), calls, github_state

    def test_railway_success_with_stale_github_record_runs_the_output_check_and_notes_it(self):
        code, gate, out, _, _ = self.main([], [row("SUCCESS")], github="in_progress")
        self.assertEqual(code, 0)
        self.assertEqual(gate, (HEAD, None))
        self.assertIn("[TAMAM] e8b3d1b yayında", out)
        self.assertIn("[BİLGİ] GitHub deployment kaydı 'in_progress'", out)
        self.assertIn("0 hata, 1 bilgi notu", out)

    def test_matching_github_record_adds_no_note(self):
        code, gate, out, _, _ = self.main([], [row("SUCCESS")], github="success")
        self.assertEqual((code, gate), (0, (HEAD, None)))
        self.assertIn("0 hata, 0 bilgi notu", out)

    def test_live_commit_other_than_head_skips_the_output_check(self):
        rows = [row("SUCCESS", OLD, "2026-10-20T10:48:19Z")]
        _, gate, _, _, _ = self.main([], rows, local=HEAD)
        self.assertIsNone(gate[0])
        self.assertIn("aynı commit değil", gate[1])

    def test_newer_failed_deployment_skips_the_output_check(self):
        rows = [row("FAILED", HEAD, "2026-10-20T13:35:12Z"), row("SUCCESS", OLD, "2026-10-20T10:48:19Z")]
        _, gate, _, _, _ = self.main([], rows)
        self.assertIsNone(gate[0])
        self.assertIn("FAILED", gate[1])

    def test_unreadable_railway_fails_closed_even_if_github_says_success(self):
        _, gate, out, _, _ = self.main([], railway_result=cli(returncode=1, stdout="", stderr="Unauthorized"),
                                       github="success")
        self.assertIsNone(gate[0])
        self.assertIn("doğrulanamadı", gate[1])
        self.assertNotIn("[TAMAM] e8b3d1b yayında", out)

    def test_wait_reports_a_skipped_deployment(self):
        code, gate, out, _, _ = self.main(["--wait"], [row("SKIPPED")])
        self.assertEqual(code, 2)
        self.assertIsNone(gate)
        self.assertIn("atladı", out)

    def test_no_github_reads_no_deployment_records(self):
        code, gate, out, calls, github_state = self.main(["--no-github", "--base", "http://localhost:8091"])
        self.assertEqual(code, 0)
        self.assertEqual(gate, (None, None))
        self.assertEqual(calls, [])
        github_state.assert_not_called()
        self.assertNotIn("Deployment\n", out)


if __name__ == "__main__":
    unittest.main()
