-- Project management - Projectile-like functionality for Neovim
return {
  'coffebar/neovim-project',
  event = 'VimEnter',
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
        '~/.config/*',
        '~/.local/share/chezmoi',
      },
      -- Automatically detect project root
      last_session_on_startup = false,
      -- Dashboard mode
      dashboard_mode = false,
    }

    -- Load the telescope extension
    local neovim_project_discover = require 'neovim-project.discover'
    require('telescope').load_extension 'neovim-project'

    -- Keybindings for project management
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'

    -- Normal mode keybindings with <leader>p prefix (like Projectile)
    vim.keymap.set('n', '<leader>pp', function()
      telescope.extensions['neovim-project'].discover {}
    end, { desc = '[P]roject switch [P]roject' })
    vim.keymap.set('n', '<leader>ph', function()
      telescope.extensions['neovim-project'].history {}
    end, { desc = '[P]roject [H]istory' })
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[P]roject [F]ind files' })
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = '[P]roject [S]earch (grep)' })
    vim.keymap.set('n', '<leader>pr', builtin.oldfiles, { desc = '[P]roject [R]ecent files' })
    vim.keymap.set('n', '<leader>pw', function()
      telescope.extensions['neovim-project'].discover {}
    end, { desc = '[P]roject [W]orkspace (change directory)' })

    -- The neovim-project picker already has good defaults
    -- Press Enter to switch to project
    -- It will open the last session or create a new one
  end,
}
