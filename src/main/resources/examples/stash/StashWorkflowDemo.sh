#!/bin/sh
# A developer is mid-way through a Java feature (code doesn't even compile yet)
# when an urgent production bug needs attention on a different branch.

git status
# Output:
# On branch add-password-reset
# Changes not staged for commit:
#         modified:   PasswordValidator.java
#         modified:   PasswordController.java

# Not ready to commit -- the code doesn't compile yet. Stash it aside.
git stash push -m "half-finished password strength validator"
# Output:
# Saved working directory and index state On add-password-reset: half-finished password strength validator

git status
# Output:
# On branch add-password-reset
# nothing to commit, working tree clean

# Switch to main and fix the urgent bug.
git switch main
git switch -c fix-login-crash
# ... fix the bug ...
git commit -am "Fix NullPointerException on login when session expired"
git switch main
git merge fix-login-crash
git branch -d fix-login-crash

# Back to the feature -- restore exactly where we left off.
git switch add-password-reset
git stash list
# Output:
# stash@{0}: On add-password-reset: half-finished password strength validator

git stash pop
# Output:
# On branch add-password-reset
# Changes not staged for commit:
#         modified:   PasswordValidator.java
#         modified:   PasswordController.java
# Dropped stash@{0} (a1b2c3d4e5f6...)

# Exactly the same uncommitted state as before the interruption.
