#!/bin/sh
# "I committed too early. How do I undo the commit while keeping my changes
# staged?" -- git reset --soft HEAD~1.

git commit -m "Add password validation"
# Output:
# [main 3c9d1a2] Add password validation
#  1 file changed, 12 insertions(+)

# Realized the commit was premature -- want to add more before committing again.
git reset --soft HEAD~1

git status
# Output:
# On branch main
# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
#         modified:   PasswordValidator.java

# The commit is gone from history, but nothing was lost -- the exact same
# changes are sitting in the staging area, ready to be committed again
# (optionally combined with more work, or a better message).
