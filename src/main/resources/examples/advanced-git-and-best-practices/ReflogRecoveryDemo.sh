#!/bin/sh
# Recovering a commit that git reset --hard accidentally discarded.

git log --oneline -1
# Output:
# a9f3e21 Add password validation

# Meant to undo the LAST commit before this one -- typed one too many resets.
git reset --hard HEAD~2
# Output:
# HEAD is now at 3c9d1a2 Add UserService with findById stub

# "Add password validation" (a9f3e21) is nowhere in `git log` anymore.
git log --oneline -3
# Output:
# 3c9d1a2 Add UserService with findById stub
# ... (a9f3e21 is gone from this view)

# But it's not actually gone -- the reflog remembers every place HEAD has been.
git reflog
# Output:
# 3c9d1a2 HEAD@{0}: reset: moving to HEAD~2
# a9f3e21 HEAD@{1}: commit: Add password validation
# 8a1b2c3 HEAD@{2}: commit: Add UserService with findById method

# HEAD@{1} is exactly the commit we wanted back. Reset onto it directly.
git reset --hard a9f3e21

git log --oneline -1
# Output:
# a9f3e21 Add password validation
