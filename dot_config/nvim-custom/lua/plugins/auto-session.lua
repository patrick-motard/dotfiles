-- https://github.com/rmagatti/auto-session
return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    bypass_session_save_file_types = { 'help' },
    -- Use cwd as session key, not git root — critical for git worktrees
    -- where git root would resolve to the main worktree instead of the branch worktree
    use_git_branch = false,
    suppressed_dirs = { '~/', '~/Downloads', '~/Desktop' },
  },
}
