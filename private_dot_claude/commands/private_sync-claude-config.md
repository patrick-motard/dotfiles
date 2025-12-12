Sync dotfiles and Claude Code configuration changes back to the dotfiles repository.

Steps:
1. Sync changes to chezmoi source:

   **Important**: Use `--autotemplate` ONLY for files that are already templates (`.tmpl`) in chezmoi source. Otherwise chezmoi will prompt interactively and fail.

   **Claude files** (NOT templates):
   ```bash
   chezmoi add -r ~/.claude/skills ~/.claude/commands ~/.claude/CLAUDE.md
   ```

   **System config files** (ARE templates - use --autotemplate):
   ```bash
   chezmoi add --autotemplate ~/.zsh/.zshrc ~/.zsh/.zprofile ~/.zsh/.zshenv ~/.zsh/aliases.zsh
   ```

   **Other files** (check if templated first):
   - If `.tmpl` exists in `~/.local/share/chezmoi/`: use `--autotemplate`
   - If NO `.tmpl`: use plain `chezmoi add`

2. Navigate to the chezmoi source directory (~/.local/share/chezmoi)
3. Check if there are changes using git status
4. If there are changes:
   - Show the user what changed using git status and git diff
   - Analyze the changes and generate an appropriate commit message following the repository's commit style (no emojis, no Claude co-authoring, focus on "why" not "what")
   - Show the proposed commit message to the user and ask for approval
   - If approved, commit the changes
   - Ask if they want to push to remote
   - If yes, push the changes
5. Report success or any errors encountered

Important: The commit message should follow the guidelines from CLAUDE.md.
