# Claude Code CLI: Commands and Workflows

"AI-Assisted Software Development with Claude Code" was the start-to-finish
narrative of one real session -- analyze, plan, implement, test, review, git.
This lesson serves a different purpose: now that you know the workflow, it's
a quick reference for the practical moments that come up in daily use --
closing the terminal and coming back, knowing what to do when context fills
up, switching between permission modes.

> ⚠️ Warning
> The command behavior described in this lesson comes from two sources: the
> official Claude Code documentation (code.claude.com/docs), and a live check
> in this platform's developer's real CLI session -- on August 22, 2026, with
> Claude Code v2.1.238, on a Claude Pro plan. The CLI changes between
> versions, and even between account/plan types; the one thing to treat as
> durable here is the purpose behind each command and the workflow it serves,
> not the exact wording of any screen. If your own environment shows
> something different, check your version with `claude --version` and check
> the official docs.

## What We'll Learn

1. How to start the CLI, and the difference between interactive mode and
   `-p` (print mode).
2. How to keep a session going, close it and come back, or reset it cleanly
   -- session management.
3. What to do when context fills up -- the real difference between
   `/compact` and `/clear`.
4. How to control permission modes and Plan Mode.
5. How to discover a command you need without memorizing it.
6. A handful of CLI options that are actually useful in daily driving.

The point of this lesson isn't to memorize a command list end to end -- it's
to answer a narrower, more durable question: "when I need it, how do I find
the right Claude Code command, and which situation calls for which one?"

## Getting Started With the CLI

As we saw in "AI-Assisted Software Development with Claude Code", the tool
starts with the `claude` command inside a project directory. In practice,
three starting shapes come up most:

```bash
claude                        # interactive session, empty
claude "describe the task"    # interactive session, with an initial task
claude -p "describe the task" # one-shot, non-interactive -- prints and exits
```

This lesson focuses on the first two -- the interactive terminal workflow.
`-p` (print mode) runs without opening an interactive session -- it's built
for scripts and automation, a check step in a CI pipeline, for example.
Non-interactive doesn't mean there's no permission mechanism at all, though:
options like `--permission-prompt-tool` let you define how permission
requests get handled even in print mode. We won't go deep into it here --
just know it exists and what it's for.

When a session starts, a banner appears at the top of the terminal, and a
status line at the bottom shows the current permission mode. Here's the
exact screen from a real session run on this platform's project (August 22,
2026, v2.1.238, Claude Pro):

```text
Claude Code v2.1.238
Sonnet 5 with medium effort · Claude Pro
~/javaProjects/learning-platform

» auto mode on (shift+tab to cycle)
```

That bottom line matters: it tells you which permission mode the session is
in (`auto`, `plan`, `manual`, and so on) and that `shift+tab` cycles between
them. We'll come back to this mode in "Planning and Control: Permission
Modes and Plan Mode".

## Session Management

When you close the terminal and reopen it, or move on to something
completely different, the answer to "what do I do now" depends on the goal:

- **Continuing the same task, in the same terminal, without interruption:**
  nothing to do -- the conversation is already going.
- **I closed the terminal and want the most recent conversation in this
  directory:** `claude --continue` (short form `-c`). The exact definition
  from the real `--help` output: "Continue the most recent conversation in
  the current directory." It takes no argument and shows no picker -- it
  goes straight to the most recent one.
- **I want to return to a specific session whose name or ID I know:** `claude
  --resume <id>` (short form `-r`). From `--help`: "Resume a conversation by
  session ID, or open interactive picker with optional search term." Run
  without an argument (`claude --resume`), it opens a picker; given an ID or
  name, it jumps straight to that session.
- **I'm inside a session and want to jump back to an earlier conversation:**
  `/resume` (a slash command) -- opens the same picker as `--resume` with no
  argument, the only difference being that it's called from inside a
  running session, not from the terminal.
- **I want to start a new, unrelated task with an empty context, in the same
  project:** `/clear` (aliases `/reset`, `/new`) -- its official definition
  is "Start a new conversation with empty context." It doesn't destroy the
  previous conversation, it just clears the current context and starts a
  new one; you can still get back to the earlier conversation with `/resume`
  if you need to.
- **I want to find a session easily later:** give it a name -- the
  `-n`/`--name` option exists exactly for this: "Set a display name for this
  session (shown in the prompt box, /resume picker, and terminal title)." A
  named session means you're not guessing "which session was which task"
  months later in the `/resume` list.

## A Real Example: Returning to an Interrupted Session

During the Quiz session in "AI-Assisted Software Development with Claude
Code", the terminal had to be closed partway through. When it was reopened
and `claude` was run with no argument, Claude Code printed this hint:

```text
➜ learning-platform git:(master) ✗ claude

Resume this session with:
claude --resume <session-id>
```

Run with no argument, `claude` noticed there was an unfinished session in
this directory and suggested the exact command to continue it. Running that
suggested command:

```text
➜ learning-platform git:(master) ✗ claude --resume <session-id>

Resume this session with:
claude --resume <session-id>
```

-- and the session picked up exactly where it left off, plan file and all
(see the plan previewed with `/plan` in "Step 2 -- Plan Mode: Planning Before
Writing Code"). Notice that no picker appeared here, because an ID was
supplied -- run with no argument, `claude --resume` would have opened a
picker similar to the one you'll see below for `/resume`.

Here's what the real screen looks like when `/resume` is called from inside a
running session:

```text
Resume session

  Search...

  learning-platform

> enum-quiz-feature
  15 hours ago · master · 911.2KB

Ctrl+A to show all projects · Ctrl+B to only show current branch ·
Space to preview · Ctrl+R to rename · Type to search · Esc to cancel
```

Two things stand out on this screen. First, sessions are grouped by project
(`learning-platform`), and there's a named session (`enum-quiz-feature`)
inside it -- the naming habit mentioned in "Session Management" genuinely
pays off. Second, there's search/filter and branch-scoped filtering built in
-- the key to using this screen efficiently once you're juggling several
projects.

## Context Management

What you should do once the context window starts filling up also depends on
the goal:

- **The conversation got long, responses slowed down or got more expensive,
  but I'm continuing the same task:** `/compact` -- summarizes the
  conversation and keeps going in the same one. You can give it optional
  instructions, too: `/compact Focus on code samples and API usage`, for
  example.
- **I'm switching to a completely unrelated task:** not `/compact`, `/clear`.
  The distinction the official documentation draws is this: `/compact` is
  itself a large, expensive request, because it has to read the entire
  history before summarizing it; `/clear` is free, because it starts from
  nothing. There's no reason to summarize when the next task is unrelated --
  starting clean is both cheaper and carries none of the previous task's
  leftovers.
- **I want to see how full context is:** `/context` (`/context all` gives a
  more detailed breakdown) -- shows what's taking up space.
- **When automatic summarization kicks in:** as context approaches a
  session's "auto-compact" threshold, Claude Code summarizes on its own; you
  can add a "Compact instructions" section to `CLAUDE.md` to specify, on a
  per-project basis, what should be preserved during summarization -- a
  small extension of the automatically-read context file from "Project
  Context: The Role of CLAUDE.md".

The decision rule is simple: **unrelated task -> `/clear`; same task but
context is filling up -> `/compact`.**

> 💡 Tip
> `/compact` is itself a large request that reads the entire conversation --
> running it when context still comfortably fits can cost more than it
> saves; the real payoff shows up once context is genuinely getting close to
> full. And remember that switching to an unrelated task calls for `/clear`,
> not `/compact`, in the first place.

## Planning and Control: Permission Modes and Plan Mode

The Plan Mode narrative in "AI-Assisted Software Development with Claude
Code" followed one session's flow; here we look more closely at the
mechanics themselves -- how you switch between permission modes, and how you
enter Plan Mode.

Claude Code has several permission modes: the most cautious one asks before
every non-read action, one auto-approves file changes, Plan Mode only
explores without changing anything, and an "auto" mode has a classifier
review actions on your behalf. `shift+tab`, while inside a session, cycles
through these modes; the status line -- the `» auto mode on` we saw in
"Getting Started With the CLI" -- always shows which one you're in. The cycle
itself isn't fixed: per the official documentation, if your starting mode is
`auto`, the first `shift+tab` takes you back to `manual` (the default), and
from there the cycle continues as `manual -> acceptEdits -> plan -> ...`,
with `auto` and any optional modes (`bypassPermissions`, `dontAsk`, and so
on) folded in if they're enabled on your account. The short version:
`shift+tab` cycles through whichever permission modes are available to you,
but which modes appear, and in what order, can depend on your version,
account, and settings -- the status line is always the reliable source.

> ⚠️ Warning
> On this platform's developer's real account (Claude Pro, v2.1.238, with no
> permission-mode setting in `~/.claude/settings.json`), a new session
> started with "auto mode on" -- consistent with the official documentation's
> claim that the built-in default on Pro/Max/Team plans is now auto. That can
> look like it contradicts the file-by-file manual approval experience in
> "AI-Assisted Software Development with Claude Code" -- it doesn't. Those
> are two separate checkpoints: the session-wide permission mode is one
> thing; the execution style you pick while approving a plan (the "manually
> approve edits" option on the "Ready to code?" screen) is another. That
> lesson deliberately picked the second one. In your own environment, check
> the status line instead of assuming which mode you're in, especially on a
> risky task.

The official documentation describes two ways into Plan Mode: cycling to
`plan` in the session with `shift+tab`, or typing `/plan [task description]`
directly (for example, `/plan add a quiz to the enum topic`), which enters
the mode and states the task in one step. Interactive details like exactly
how these two behave are among the parts of the CLI that change most often
between versions, so verifying them with `/help`, or by trying them, in your
own environment is the most reliable approach.

The migration-number bug from "Reading a Plan Before Approving It: A Real
Bug" is the proof that Plan Mode is more than an approval screen -- it's a
genuine verification opportunity. Saying "Yes" without reading the plan
would have missed that bug entirely.

## Discovering Commands

You don't need to have a command memorized when you need it -- you just need
to know how to find it:

- Typing an empty `/` inside a session opens a filterable command list --
  it narrows as you keep typing.
- `/help` shows a summary of the built-in commands.
- Running `claude --help` from the terminal, outside a session, lists every
  CLI flag and subcommand (`claude mcp`, `claude doctor`, `claude auth`, and
  so on).

For a complete and current reference, the first stop should always be the
official Claude Code documentation (code.claude.com/docs) -- command lists,
as this lesson itself demonstrates, are among the fastest-changing parts of
the CLI across versions.

## Useful CLI Options

`claude --help` is a genuinely good starting point, but it isn't **the
complete reference**. While preparing this lesson, we compared the real
`--help` output (over 60 flags) against the official CLI reference page:
several more specialized flags appear in the official docs but not in
`--help` -- things like an option to load the system prompt from a file, or
options specific to agent-team behavior. The right mental model is:
**`--help` is a basic discovery tool for everyday use; the official CLI
reference is the complete, current one.**

A handful of options that are genuinely useful day to day (quoted verbatim
from the real `--help` output):

- `--model <model>` -- "Model for the current session. Provide an alias for
  the latest model (e.g. 'fable', 'opus', or 'sonnet') or a model's full
  name." Can also be changed mid-session with `/model`.
- `--add-dir <directories...>` -- "Additional directories to allow tool
  access to." How you extend context when working across more than one
  project or module at once.
- `-n, --name <name>` -- "Set a display name for this session (shown in the
  prompt box, /resume picker, and terminal title)." The `enum-quiz-feature`
  name in "A Real Example: Returning to an Interrupted Session" was given
  exactly this way.
- `-v, --version` -- prints the version number. As this lesson keeps
  stressing, that's the first step in knowing which version a given
  behavior is actually true for.
- `claude doctor` (a subcommand, not a flag) -- checks the health of your
  installation.

One last note: `git status`, `git diff`, `mvn`, and `npm` are **not** Claude
Code's own commands -- they're ordinary terminal commands. Claude Code can
run them on your behalf (as in "Step 6 -- Git: Reviewing Changes and
Committing"), but that doesn't make them Claude Code commands -- which is
exactly why they never show up in `claude --help`'s output.

## Best Practices

- Use `claude --continue` to return to the same task after closing the
  terminal, and `claude --resume` or `/resume` for a specific, named session
  -- see "Session Management".
- Name a session early if you'll likely return to it, so you're not
  guessing in the `/resume` list months later -- see "A Real Example:
  Returning to an Interrupted Session".
- Use `/clear` when switching to an unrelated task and `/compact` when
  context is filling up on the same task -- don't substitute one for the
  other -- see "Context Management".
- Check the status line instead of assuming which permission mode a session
  is in, especially on a risky task -- see "Planning and Control: Permission
  Modes and Plan Mode".
- Discover a command with `/help` or an empty `/` instead of trying to
  memorize it -- see "Discovering Commands".
- Make checking `claude --version` a habit whenever a behavior might be
  version-dependent -- see "Useful CLI Options".

## Common Mistakes

- **Confusing `--continue` with `--resume`.** `--continue` takes no argument
  and only returns to the most recent conversation in that directory; to
  return to a specific or named session, you need `--resume` (with an ID or
  name if necessary) -- see "Session Management".
- **Running `/compact` when switching to an unrelated task.** That triggers
  an unnecessarily expensive request (summarizing the entire history) --
  the right command for an unrelated task is the free one, `/clear` -- see
  "Context Management".
- **Treating `claude --help`'s output as the CLI's complete reference.** For
  this lesson, the real `--help` output didn't include some (more
  specialized) flags that appear in the official CLI reference page --
  `--help` is a discovery tool, and the complete list lives in the official
  docs -- see "Useful CLI Options".
- **Assuming a session's permission mode.** "Auto mode" can be the default
  on one account and something else on another account or version -- walking
  into a risky task without checking the status line undermines the same
  safety discipline taught in "AI-Assisted Software Development with Claude
  Code" -- see "Planning and Control: Permission Modes and Plan Mode".

## Summary, Cheat Sheet, and Glossary

**Summary**

- This lesson serves a different purpose than the single-session narrative
  in "AI-Assisted Software Development with Claude Code": not memorizing
  commands, but answering "when I need it, how do I find the right command,
  and which situation calls for which one?"
- Session management depends on the goal: `--continue` for the most recent
  conversation in the same directory, `--resume` or `/resume` for a
  specific or named session, `/clear` to start a new conversation with
  empty context.
- `/compact` and `/clear` aren't interchangeable: `/clear` (free) for an
  unrelated task, `/compact` (summarizes history, and is itself a cost) when
  context is filling up on the same task.
- The permission mode (auto/manual/plan) cycles with `shift+tab` and shows
  on the status line; that's a separate checkpoint from the execution style
  you pick while approving a plan on the "Ready to code?" screen.
- `claude --help` is a basic discovery tool, not the CLI's complete and
  current reference -- that's the official Claude Code documentation.
- `git status`, `git diff`, `mvn`, and `npm` aren't Claude Code's own
  commands -- Claude Code can run them on your behalf, but they're ordinary
  terminal commands.

**Cheat Sheet**

- Start: `claude` (interactive) / `claude "task"` (with a task) / `claude -p
  "task"` (one-shot, non-interactive).
- Return to the most recent conversation in this directory: `claude
  --continue` (`-c`).
- Return to a specific/named session: `claude --resume <id>` (`-r`), or
  `/resume` inside a session.
- Start clean (new conversation, empty context): `/clear` (`/reset`, `/new`).
- Name a session: `-n`/`--name <name>`.
- Summarize context (same task): `/compact [instructions]`.
- Check context usage: `/context` (`/context all`).
- Switch permission mode: `shift+tab` -- cycles, but not in a fixed order;
  which modes appear, and in what order, depends on your starting mode and
  your account/version settings (check the status line).
- Enter Plan Mode directly: `/plan [task description]`.
- Discover a command: empty `/`, or `/help`.
- Discover basic CLI options: `claude --help` (official docs for the
  complete reference).
- Check the version: `claude --version` (`-v`).

**Glossary**

- **Session:** one conversation, with its own history and context, running
  from when a `claude` invocation starts to when it ends (or is reset with
  `/clear`).
- **Context window:** the portion of a session's message/tool history that
  gets sent to the model with every request -- as it fills up, response
  quality and cost are both affected.
- **Compaction:** summarizing past conversation to free up space, either
  automatically or by hand with `/compact`, once context is approaching
  full -- the conversation isn't reset, only summarized.
- **Permission mode:** the session-wide setting that determines how much
  automatic approval is given to proposed file changes/commands (`manual`,
  `acceptEdits`, `plan`, `auto`, and so on) -- cycles with `shift+tab`, shown
  on the status line.
- **Plan Mode:** one of the permission modes; the mode where Claude Code
  produces a plan and waits for approval before changing any file.
- **Print mode (`-p`):** a way of running Claude Code that answers a single
  request and exits without opening an interactive session, built for
  scripts and automation.
