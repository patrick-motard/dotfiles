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
        '~/code/zendesk/*',
        '~/.local/share/chezmoi',
      },
      -- Automatically detect project root
      last_session_on_startup = false,
      -- Dashboard mode
      dashboard_mode = false,
    }

    -- Keybindings for project management
    local builtin = require 'telescope.builtin'

    -- Normal mode keybindings with <leader>p prefix (like Projectile)
    vim.keymap.set('n', '<leader>pp', '<cmd>Telescope neovim-project discover<cr>', { desc = '[P]roject switch [P]roject' })
    vim.keymap.set('n', '<leader>ph', '<cmd>Telescope neovim-project history<cr>', { desc = '[P]roject [H]istory' })
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[P]roject [F]ind files' })
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = '[P]roject [S]earch (grep)' })
    vim.keymap.set('n', '<leader>pr', builtin.oldfiles, { desc = '[P]roject [R]ecent files' })
    vim.keymap.set('n', '<leader>pw', '<cmd>Telescope neovim-project discover<cr>', { desc = '[P]roject [W]orkspace (change directory)' })
  end,
}
