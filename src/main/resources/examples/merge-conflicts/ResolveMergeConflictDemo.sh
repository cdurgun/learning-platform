#!/bin/sh
# Merging a branch, hitting a conflict, resolving it, and completing the merge.

git merge add-loyalty-discount
# Output:
# Auto-merging DiscountCalculator.java
# CONFLICT (content): Merge conflict in DiscountCalculator.java
# Automatic merge failed; fix conflicts and then commit the result.

git status
# Output:
# On branch main
# You have unmerged paths.
#   (fix conflicts and run "git commit")
# Unmerged paths:
#   (use "git add <file>..." to mark resolution)
#         both modified:   DiscountCalculator.java

# DiscountCalculator.java now contains conflict markers:
#
# public int calculateDiscount(Order order) {
# <<<<<<< HEAD
#     return order.getTotal() > 100 ? 10 : 0;
# =======
#     return order.getTotal() > 100 ? 15 : 5;
# >>>>>>> add-loyalty-discount
# }
#
# ... edit the file, keep the correct logic, remove all three marker lines ...

git add DiscountCalculator.java
git commit
# Output:
# [main 3f4a5b6] Merge branch 'add-loyalty-discount'

git status
# Output:
# nothing to commit, working tree clean
