#!/bin/sh
# A typical day: check for remote changes, pull them in, push a new branch,
# and keep it up to date with main.

git fetch origin
# Output:
# From github.com:your-username/task-tracker
#    a1b2c3d..e5f6a7b  main       -> origin/main

# Two new commits exist on origin/main that we don't have locally yet.
git pull origin main
# Output:
# Updating a1b2c3d..e5f6a7b
# Fast-forward
#  TaskController.java | 9 +++++++++
#  1 file changed, 9 insertions(+)

# Start a new feature branch and push it for the first time.
git switch -c add-due-dates
# ... edit Task.java, TaskController.java ...
git add .
git commit -m "Add due date field to Task"
git push -u origin add-due-dates
# Output:
# * [new branch]      add-due-dates -> add-due-dates
# branch 'add-due-dates' set up to track 'origin/add-due-dates'.

# From now on, plain push/pull on this branch work without extra arguments.
git push
