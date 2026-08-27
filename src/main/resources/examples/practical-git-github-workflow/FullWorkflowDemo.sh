#!/bin/sh
# Rebasing a feature branch onto an updated main, hitting a conflict in
# Task.java, and resolving it -- the middle of the full end-to-end scenario.

git fetch origin
git rebase origin/main
# Output:
# Auto-merging Task.java
# CONFLICT (content): Merge conflict in Task.java
# error: could not apply 4f5a6b7... Add dueDate field to Task entity
# hint: Resolve all conflicts manually, mark them as resolved with
# hint: "git add/rm <conflicted_files>", then run "git rebase --continue".

# Task.java now contains conflict markers:
#
# public class Task {
#     private String title;
# <<<<<<< HEAD
#     private Priority priority;
# =======
#     private LocalDate dueDate;
# >>>>>>> 4f5a6b7 (Add dueDate field to Task entity)
#     // ...
# }
#
# Both fields are needed -- someone else added `priority` on main while this
# branch added `dueDate`. The correct resolution keeps both.

# ... edit the file to keep both fields, remove all three marker lines ...

git add Task.java
git rebase --continue
# Output:
# Successfully rebased and updated refs/heads/add-task-due-date.

git log --oneline -1
# Output:
# 9e8f7a6 Add dueDate field to Task entity
