#!/bin/sh
# A complete feature branch workflow on a small Spring Boot project: branch,
# work, merge back, clean up.

git switch -c add-password-reset
# Output:
# Switched to a new branch 'add-password-reset'

# ... edit PasswordController.java and PasswordService.java ...
git add .
git commit -m "Add password reset endpoint"
# Output:
# [add-password-reset f7e1a92] Add password reset endpoint
#  2 files changed, 31 insertions(+)

git switch main
# Output:
# Switched to branch 'main'

git merge add-password-reset
# Output (fast-forward, since main hasn't moved since branching):
# Updating a1b2c3d..f7e1a92
# Fast-forward
#  PasswordController.java | 18 ++++++++++++++++++
#  PasswordService.java    | 13 +++++++++++++
#  2 files changed, 31 insertions(+)

git branch -d add-password-reset
# Output:
# Deleted branch add-password-reset (was f7e1a92).
