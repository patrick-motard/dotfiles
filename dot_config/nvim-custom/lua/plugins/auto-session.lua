-- https://github.com/rmagatti/auto-session
return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    -- suppressed_dirs = { '~/' },
    allowed_dirs = { '~/code/*', '~/.local/share/chezmoi/*', '~/.config/', '~/.ssh/' },
    -- log_level = 'debug',
  },
}