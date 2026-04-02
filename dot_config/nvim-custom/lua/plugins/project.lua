-- Project management - Projectile-like functionality for Neovim
return {
  'coffebar/neovim-project',
  lazy = false,
  priority = 100,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    { 'Shatur/neovim-session-manager' },
  },
  init = function()
    -- Enable saving the state of plugins in the session
    vim.opt.sessionoptions:append 'globals'
  end,
  config = function()
    require('neovim-project').setup {
      projects = {
        '~/code/*',
        '~/code/clients/*/*',
        '~/code/zendesk/*',
        '~/code/claude/*',
        '~/code/worktrees/*/*',
        '~/.local/share/chezmoi',
      },
      -- Exclude config directories from project discovery
      ignore_projects = {
        '~/code/claude',
        '~/code/clients',
        '~/code/clients/*',
        '~/code/worktrees',
        '~/code/worktrees/*',
        '~/.config',
      },
      -- Automatically detect project root
      last_session_on_startup = false,
      -- Dashboard mode
      dashboard_mode = false,
    }

    -- Keybindings for project management
    local builtin = require 'telescope.builtin'

    -- Normal mode keybindings with <leader>p prefix (like Projectile)
    vim.keymap.set('n', '<leader>pp', '<cmd>Telescope neovim-project discover<cr>', { desc = '[p] switch project' })
    vim.keymap.set('n', '<leader>ph', '<cmd>Telescope neovim-project history<cr>', { desc = '[h]istory' })
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[f]ind files' })
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = '[s]earch (grep)' })
    vim.keymap.set('n', '<leader>pr', builtin.oldfiles, { desc = '[r]ecent files' })
  end,
}
