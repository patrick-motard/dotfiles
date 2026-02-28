-- https://github.com/rmagatti/auto-session
return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    bypass_session_save_file_types = { 'help' },
    -- suppressed_dirs = { '~/' },
    -- allowed_dirs = {
    --   '~/code/*',
    --   '~/code/zendesk/*',
    --   '~/.local/share/chezmoi/*',
    --   '~/.local/share/chezmoi/dot_config/nvim-custom/*',
    --   'local/share/chezmoi/dot_config/nvim-custom/*',
    --   '~/.config/',
    --   '~/.ssh/',
    -- },
    -- log_level = 'debug',
  },
}
