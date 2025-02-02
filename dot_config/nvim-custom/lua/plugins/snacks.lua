local git = require 'plugins.custom.git'

return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    ---@type snacks.picker.Config
    picker = {
      sources = {
        git_log_file = {
          confirm = function(picker, item)
            git.openPullRequest(item.commit)
            picker:close()
          end,
          actions = {
            foo = function(picker, item)
              vim.notify 'foo'
            end,
            bar = function(picker, item)
              vim.notify 'bar'
            end,
          },
          win = {
            input = {
              keys = {
                -- ['<cr>'] = 'confirm',
                ['<a-c>'] = { 'foo', mode = { 'n', 'i' } },
                ['<a-d>'] = { 'bar', mode = { 'n', 'i' } },
              },
            },
          },
        },
      },
      layout = 'default',
      -- ---@type snacks.picker.layout.Config
      -- layout = {
      --
      --   layout = {
      --     box = 'horizontal',
      --     title = '{title} {flags}',
      --     title_position = 'center',
      --     { win = 'input', height = 20, border = 'rounded' },
      --   },
      -- },
      --
      -- title = 'Snacks',
    },
  },
  keys = {
    {
      '<leader>as',
      function()
        local Snacks = require 'snacks'
        Snacks.picker.git_log_file()
      end,
      desc = 'Snacks',
    },
  },
}
