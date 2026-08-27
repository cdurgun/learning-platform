#!/bin/sh
# The full Working Tree -> Staging Area -> Repository flow for a small Java
# class, from writing the file to committing it.

# 1. A new file exists on disk, but Git isn't tracking it yet.
echo 'public class UserService {
    public User findById(Long id) {
        return null; // not implemented yet
    }
}' > UserService.java

git status
# Output:
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#         UserService.java

# 2. Move it into the staging area.
git add UserService.java

git status
# Output:
# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
#         new file:   UserService.java

# 3. Commit what's staged -- this creates a permanent snapshot.
git commit -m "Add UserService with findById stub"

# Output:
# [main (root-commit) 4f2a1c9] Add UserService with findById stub
#  1 file changed, 5 insertions(+)
#  create mode 100644 UserService.java

git status
# Output:
# nothing to commit, working tree clean
