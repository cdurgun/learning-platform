#!/bin/sh
# Turning a plain folder into a Git repository, then confirming it worked.

mkdir task-tracker
cd task-tracker
git init

# Output:
# Initialized empty Git repository in /home/ada/task-tracker/.git/

ls -la

# Output (trimmed):
# drwxr-xr-x  3 ada  staff   96 Aug 24 10:00 .
# drwxr-xr-x  4 ada  staff  128 Aug 24 10:00 ..
# drwxr-xr-x  9 ada  staff  288 Aug 24 10:00 .git

# The .git folder is the repository itself -- it did not exist a moment ago,
# and the "task-tracker" folder had no history until git init created it.
