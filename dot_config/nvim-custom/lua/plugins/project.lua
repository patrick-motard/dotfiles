-- Project management - Projectile-like functionality for Neovim
return {
  'ahmedkhalf/project.nvim',
  event = 'VimEnter',
  config = function()
    require('project_nvim').setup {
      -- Manual mode doesn't automatically change your root directory, so you have
      -- the option to manually do so using `:ProjectRoot` command.
      manual_mode = false,

      -- Methods of detecting the root directory. **"lsp"** uses the native neovim
      -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
      -- order matters: if one is not detected, the other is used as fallback.
      detection_methods = { 'lsp', 'pattern' },

      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'Cargo.toml' },

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},

      -- Show hidden files in telescope
      show_hidden = false,

      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = true,

      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = 'global',

      -- Path where project.nvim will store the project history for use in
      -- telescope
      datapath = vim.fn.stdpath 'data',
    }

    -- Load the telescope extension
    require('telescope').load_extension 'projects'

    -- Keybindings for project management
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'

    -- Normal mode keybindings with <leader>p prefix (like Projectile)
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[P]roject [F]ind files' })
    vim.keymap.set('n', '<leader>pb', builtin.file_browser, { desc = '[P]roject [B]rowse files' })
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = '[P]roject [S]earch (grep)' })
    vim.keymap.set('n', '<leader>pr', builtin.oldfiles, { desc = '[P]roject [R]ecent files' })
    vim.keymap.set('n', '<leader>pw', function()
      telescope.extensions.projects.projects {}
    end, { desc = '[P]roject [W]orkspace (change directory)' })
    vim.keymap.set('n', '<leader>pp', function()
      telescope.extensions.projects.projects {}
    end, { desc = '[P]roject switch [P]roject' })

    -- Insert mode keybindings in Telescope picker
    -- These will be available when the projects picker is open
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    require('telescope').setup {
      extensions = {
        projects = {
          -- Mappings when in the projects telescope picker
          mappings = {
            i = {
              ['<c-f>'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.find_files()
              end,
              ['<c-b>'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.file_browser()
              end,
              ['<c-s>'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.live_grep()
              end,
              ['<c-r>'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.oldfiles()
              end,
              ['<c-w>'] = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                  vim.cmd('cd ' .. selection.value)
                  print('Changed directory to: ' .. selection.value)
                end
              end,
            },
            n = {
              ['f'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.find_files()
              end,
              ['b'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.file_browser()
              end,
              ['s'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.live_grep()
              end,
              ['r'] = function(prompt_bufnr)
                actions.close(prompt_bufnr)
                builtin.oldfiles()
              end,
              ['w'] = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                  vim.cmd('cd ' .. selection.value)
                  print('Changed directory to: ' .. selection.value)
                end
              end,
            },
          },
        },
      },
    }
  end,
}
