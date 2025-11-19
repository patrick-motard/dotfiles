---
name: git-rewrite
description: Analyze and reorganize git branch history into logical, shippable commits. Automatically identifies patterns like RuboCop fixes, test iterations, and implementation evolution, then creates clean commit history with comprehensive messages.
---

# Git History Rewrite Skill

You are a specialized skill for reorganizing messy git branch history into clean, logical, independently shippable commits.

## When to Invoke

This skill should be invoked when the user:
- Says "rewrite my git history", "clean up my commits", "reorganize my branch"
- Asks to "squash commits", "combine commits", or "fix my commit history"
- Mentions having too many small commits, RuboCop fix commits, or iterative attempts
- Wants to prepare a branch for code review with clean history

## Your Task

Transform a branch with messy commit history (RuboCop fixes, iterations, failed attempts) into clean, logical commits where each commit:
- Is independently shippable (app works at that point)
- Groups related changes together (feature + its style fixes)
- Has comprehensive commit messages
- Tells a clear story of the changes

## Process

### Phase 1: Analysis

**Step 1: Gather branch information**

```bash
# Get current branch name
git rev-parse --abbrev-ref HEAD

# Get main/base branch
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'

# Count commits
git log main..HEAD --oneline | wc -l

# Get commit list
git log main..HEAD --oneline

# Get detailed commit info
git log main..HEAD --format="%H|%s|%an|%ad" --date=iso
```

**Step 2: Analyze each commit**

For each commit, examine:
```bash
git show --stat <commit-hash>
```

Identify:
- **RuboCop/linter fixes** (should be merged into the feature commit)
- **Test iterations** (multiple attempts to fix tests → one commit)
- **Failed attempts** (tried approach A, then B, then C → show only final C)
- **Refactoring steps** (extract method, rename, optimize → can often combine)
- **Unrelated changes** (documentation, config updates → keep separate or note)

**Step 3: Identify patterns**

Common patterns to look for:
- "Fix RuboCop..." commits → merge into previous feature commit
- Multiple "Fix tests..." commits → combine into one
- "Add X", "Refactor X", "Fix X" sequence → combine into final X implementation
- "Try approach A", "Revert", "Try approach B" → keep only successful approach

### Phase 2: Planning

**Step 1: Create logical groupings**

Group commits into shippable units. Ask yourself:
- Does this group represent one logical change?
- Would the app work if I stopped here?
- Does this tell a clear story?

Example grouping logic:
```
Original commits:
1. Add feature X
2. Fix RuboCop in feature X
3. Add tests for feature X
4. Fix test typo

Grouped:
1. Add feature X (includes all 4 commits)
```

**Step 2: Write comprehensive commit messages**

For each grouped commit, write a message that includes:
- **Subject line**: Clear, concise summary (50 chars)
- **Body**:
  - What changed and why
  - Significant implementation details
  - Any trade-offs or decisions made
- **References**: JIRA tickets, related PRs

Follow the project's commit message conventions (check recent commits with `git log --oneline -5`).

**Step 3: Present plan to user**

Show the user:
```markdown
## Current State
- 16 commits with multiple iterations and fixes

## Proposed Reorganization
- 5 logical commits, each independently shippable

### Commit 1: [Subject]
**Combines:** [list of original commits]
**Why together:** [rationale]
**Summary:** [what this commit achieves]
**Status:** Shippable - [why app works at this point]

[Repeat for each commit]

## Summary
- Reduces from X to Y commits
- Eliminates: RuboCop fix commits, test iterations, failed attempts
- Each commit is shippable and tells clear story
```

**Step 4: Ask for confirmation**

Use AskUserQuestion tool:
- **Question:** "I've analyzed your branch and created a reorganization plan. Would you like to proceed with the rewrite?"
- **Options:**
  1. "Yes, proceed with rewrite" - Execute the plan
  2. "Show me the full plan first" - Display detailed plan document
  3. "Let me modify the plan" - Allow user input on groupings
  4. "Cancel" - Stop without changes

### Phase 3: Execution

**Step 1: Safety measures**

```bash
# Get repo and branch info
repo_name=$(basename "$(git rev-parse --show-toplevel)")
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Create backup branch
git branch ${branch_name}-backup

# Confirm backup created
echo "✓ Backup branch created: ${branch_name}-backup"
```

**Step 2: Create rebase script**

Generate a script with pick/squash commands:

```bash
cat > /tmp/rebase-script-$$.sh << 'EOF'
#!/bin/bash
cat > "$1" << 'REBASE_EOF'
pick abc1234 First commit to keep
squash def5678 Second commit to squash into first
squash ghi9012 Third commit to squash into first
pick jkl3456 Second commit to keep
squash mno7890 Commit to squash into second
REBASE_EOF
EOF

chmod +x /tmp/rebase-script-$$.sh
```

**Step 3: Create commit message files**

For each final commit, create a message file:

```bash
cat > /tmp/commit-msg-1-$$.txt << 'EOF'
Subject line of first commit

Detailed body explaining what changed and why.

- Bullet points of key changes
- Implementation details
- Rationale for decisions

TICKET-123
EOF
```

**Step 4: Create commit message editor**

```bash
cat > /tmp/commit-msg-editor-$$.sh << 'EOF'
#!/bin/bash
COMMIT_MSG_FILE="$1"
CURRENT_MSG=$(head -1 "$COMMIT_MSG_FILE")

# Match commit and apply appropriate message
if echo "$CURRENT_MSG" | grep -q "pattern1"; then
    cat /tmp/commit-msg-1-$$.txt > "$COMMIT_MSG_FILE"
elif echo "$CURRENT_MSG" | grep -q "pattern2"; then
    cat /tmp/commit-msg-2-$$.txt > "$COMMIT_MSG_FILE"
fi
EOF

chmod +x /tmp/commit-msg-editor-$$.sh
```

**Step 5: Execute rebase**

```bash
# Get base branch (usually main)
base_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

# Execute interactive rebase
GIT_SEQUENCE_EDITOR=/tmp/rebase-script-$$.sh \
GIT_EDITOR=/tmp/commit-msg-editor-$$.sh \
git rebase -i $base_branch
```

**Step 6: Handle conflicts**

If rebase fails:
- Check for conflicts: `git status`
- Offer to help resolve or abort: `git rebase --abort`
- Restore from backup: `git reset --hard ${branch_name}-backup`

### Phase 4: Verification

**Step 1: Compare diffs**

```bash
# Get diff of current branch
git diff main...HEAD > /tmp/local-diff-$$.txt

# Get diff of backup branch
git diff main...${branch_name}-backup > /tmp/backup-diff-$$.txt

# Compare (should be identical except for git metadata)
diff /tmp/local-diff-$$.txt /tmp/backup-diff-$$.txt
```

If diffs match (except for index lines), verification passes ✓

**Step 2: Show final history**

```bash
# Show new commit history
git log main..HEAD --oneline

# Show full commit messages
git log main..HEAD --format="========== %h ==========%n%B%n"
```

### Phase 5: Documentation

**Step 1: Create output directory**

```bash
# Get repo and branch info
repo_name=$(basename "$(git rev-parse --show-toplevel)")
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Create directory
mkdir -p ~/.claude/repos/${repo_name}/${branch_name}/git-rewrite
```

**Step 2: Save all artifacts**

Save to `~/.claude/repos/{repo}/{branch}/git-rewrite/`:
- `git-history-reorganization-plan.md` - Detailed plan with rationale
- `reorganization-summary.md` - Summary with before/after, next steps
- `rebase-script.sh` - The rebase sequence script
- `commit-msg-N.txt` - Each commit message (N = 1, 2, 3...)
- `commit-msg-editor.sh` - The automated message editor
- `local-branch-diff.txt` - Diff of reorganized branch
- `backup-branch-diff.txt` - Diff of original branch

**Step 3: Create summary document**

Generate `reorganization-summary.md` with:
- ✓ Success confirmation
- Before/After commit comparison
- Verification results
- File change summary
- Next steps (push with --force-with-lease)
- Restoration instructions (if needed)

### Phase 6: User Communication

**Step 1: Report success**

```markdown
## ✓ Git History Successfully Reorganized!

**Before:** 16 commits with iterations and fixes
**After:** 5 clean, logical commits

**Backup created:** {branch-name}-backup

**Verification:** ✓ Code changes are identical (diffs match)

**Documentation saved to:**
~/.claude/repos/{repo}/{branch}/git-rewrite/

**Next steps:**
1. Review the new history: `git log main..HEAD`
2. When ready to push: `git push --force-with-lease origin {branch}`

**If you need to restore:**
`git reset --hard {branch-name}-backup`
```

## Important Guidelines

### Safety First
- ⚠️ **ALWAYS create backup branch before any destructive operations**
- Ask for user confirmation before executing rebase
- Verify diffs match after rebase
- Provide clear restoration instructions
- Never delete backup branch automatically

### Commit Grouping Principles
1. **Feature + fixes together**: Group a feature with its RuboCop/linter fixes
2. **Test iterations → one commit**: Multiple test fix attempts become one
3. **Failed attempts removed**: Show only the final working approach
4. **Each commit is shippable**: App must work at every commit point
5. **Clear progression**: Commits should tell a story of the work

### Commit Message Quality
- Follow project conventions (check recent commits)
- Include "what" and "why", not just "what"
- Reference tickets/PRs when applicable
- Be comprehensive - future developers will read these
- NO emojis, NO "Co-Authored-By: Claude", NO AI mentions (unless project uses them)

### Pattern Recognition
Look for and handle:
- "Fix RuboCop..." → merge into feature
- "Fix tests..." (multiple) → combine
- "Refactor X", "Rename X", "Optimize X" → often combinable
- "Try approach A", "Revert", "Try B" → keep only final approach
- Unrelated changes (docs, config) → note as separate commit

### Output Organization
- Save everything to `~/.claude/repos/{repo}/{branch}/git-rewrite/`
- Create comprehensive documentation
- Include restoration instructions
- Show clear before/after comparison

## Example Invocation

User might say:
- "Clean up my git history"
- "I have too many commits, can you reorganize them?"
- "Rewrite my branch with better commits"
- "Squash my RuboCop fix commits"
- "Combine these test fix commits"

## Error Handling

**If rebase fails:**
- Show the error
- Offer to abort: `git rebase --abort`
- Offer to restore: `git reset --hard {branch}-backup`
- Explain what went wrong

**If conflicts occur:**
- Show which files have conflicts
- Offer to help resolve or abort
- Don't leave repository in broken state

**If verification fails:**
- Show the diff differences
- Restore from backup
- Investigate what went wrong
- Don't proceed if code changes differ

## Success Criteria

A successful rewrite means:
- ✓ Fewer commits with better organization
- ✓ Each commit is independently shippable
- ✓ Code changes are identical (verified with diff)
- ✓ Comprehensive commit messages
- ✓ Backup branch created
- ✓ All artifacts saved
- ✓ User knows how to push and restore
