#!/bin/sh
# Rebasing a feature branch onto the latest main, then resolving a straightforward
# conflict during the replay.

git switch add-password-reset
git rebase main
# Output:
# Auto-merging PasswordService.java
# CONFLICT (content): Merge conflict in PasswordService.java
# error: could not apply e4f5a6b... Add password validation
# hint: Resolve all conflicts manually, mark them as resolved with
# hint: "git add/rm <conflicted_files>", then run "git rebase --continue".

# ... open PasswordService.java, resolve the conflict markers ...
git add PasswordService.java
git rebase --continue
# Output:
# Successfully rebased and updated refs/heads/add-password-reset.

# The branch's commits now sit on top of main's latest commit, with new hashes.
git log --oneline -3
# Output:
# 9d8e7f6 Add password validation
# 8c7d6e5 Add password field to User entity
# a1b2c3d Add rate limiting to login endpoint   (main's latest, now the base)

# The branch was already pushed once before this rebase, so a normal push is
# rejected -- the rebased commits don't match what's on the remote.
git push
# Output:
# ! [rejected]        add-password-reset -> add-password-reset (non-fast-forward)
# error: failed to push some refs

# force-with-lease pushes the rebased history, but would refuse if origin had
# changed unexpectedly since our last fetch.
git push --force-with-lease
# Output:
# + e4f5a6b...9d8e7f6 add-password-reset -> add-password-reset (forced update)
