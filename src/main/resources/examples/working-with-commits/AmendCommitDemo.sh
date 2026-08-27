#!/bin/sh
# Committing, noticing a forgotten file, and amending instead of creating a
# second "oops" commit.

git commit -m "Add UserService with findById method"
# Output:
# [main 8a1b2c3] Add UserService with findById method
#  1 file changed, 8 insertions(+)

# Oops -- forgot the matching test file.
git add UserServiceTest.java
git commit --amend --no-edit

# Output:
# [main a9f3e21] Add UserService with findById method
#  2 files changed, 24 insertions(+)

# Note the new commit hash (a9f3e21) -- it REPLACED 8a1b2c3, it did not edit
# it in place. `git log --oneline -1` now shows only the new commit.
git log --oneline -1
# Output:
# a9f3e21 Add UserService with findById method
