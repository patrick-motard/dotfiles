---
description: Commit changes logically with meaningful messages and push to remote
---

Review all changes in the current branch and commit them into one or more logical commits with meaningful commit messages.

Steps:
1. Run `git status` and `git diff` to see all changes
2. Analyze the changes and group them logically (e.g., separate feature additions from documentation updates, group related changes together)
3. For each logical group:
   - Stage the relevant files using `git add`
   - Create a commit with a message that explains WHAT changed and WHY
   - The commit message should be clear and descriptive, not generic
4. After all commits are created, push to the remote repository
5. Confirm the push was successful

Commit message guidelines:
- Be specific about what changed
- Explain the reason or context for the change
- Use imperative mood (e.g., "Add" not "Added")
- Keep the first line concise, add details in the body if needed
