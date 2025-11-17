Sync Claude Code configuration changes from ~/.claude/ back to the dotfiles repository.

Steps:
1. Run `chezmoi add -r ~/.claude/skills ~/.claude/commands ~/.claude/CLAUDE.md` to sync changes to chezmoi source
2. Navigate to the chezmoi source directory (~/.local/share/chezmoi)
3. Check if there are changes in private_dot_claude/
4. If there are changes:
   - Show the user what changed using git status and git diff
   - Analyze the changes and generate an appropriate commit message following the repository's commit style (no emojis, no Claude co-authoring, focus on "why" not "what")
   - Show the proposed commit message to the user and ask for approval
   - If approved, commit the changes
   - Ask if they want to push to remote
   - If yes, push the changes
5. Report success or any errors encountered

Important: The commit message should follow the guidelines from CLAUDE.md.
