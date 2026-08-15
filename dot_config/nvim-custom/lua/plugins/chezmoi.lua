return {
  'xvzc/chezmoi.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local chezmoi_commands = require 'chezmoi.commands'
    local chezmoi_picker = require 'config.chezmoi_picker'
    local make_entry = require 'telescope.make_entry'
    local telescope_config = require('telescope.config').values
    local action_state = require 'telescope.actions.state'
    local actions = require 'telescope.actions'
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'

    require('chezmoi').setup {
      watch = true,
    }

    local sources = {
      { label = 'default', args = {} },
      { label = 'private', args = { '--source', vim.fn.expand '~/code/dotfiles-private' } },
    }

    local function source_path(entry)
      return chezmoi_commands.source_path {
        targets = { entry.value },
        args = vim.deepcopy(entry.source.args),
      }
    end

    local function find_files()
      local opts = { cwd = vim.fn.expand '~' }
      local entries = chezmoi_picker.build_entries(sources, function(source)
        return chezmoi_commands.list {
          args = chezmoi_picker.list_args(source.args),
        }
      end)
      local file_entry = make_entry.gen_from_file(opts)

      pickers
        .new(opts, {
          prompt_title = 'Chezmoi Files',
          finder = finders.new_table {
            results = entries,
            entry_maker = function(entry)
              local file = file_entry(entry.value)
              file.display = entry.display
              file.ordinal = entry.ordinal
              file.source = entry.source
              return file
            end,
          },
          attach_mappings = function(prompt_bufnr, map)
            local edit_action = function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              local ok, paths = pcall(source_path, selection)
              if not ok or vim.tbl_isempty(paths) then
                vim.notify('Could not resolve chezmoi source path', vim.log.levels.ERROR)
                return
              end

              vim.cmd.edit(vim.fn.fnameescape(paths[1]))
            end

            for _, key in ipairs(require('chezmoi').config.telescope.select) do
              map('i', key, 'select_default')
            end

            actions.select_default:replace(edit_action)
            return true
          end,
          previewer = telescope_config.file_previewer(opts),
          sorter = telescope_config.generic_sorter(opts),
        })
        :find()
    end

    vim.keymap.set('n', '<leader>sD', find_files, { desc = '[d]otfiles' })
  end,
}
