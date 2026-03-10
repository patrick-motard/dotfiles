return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[h]istory (file)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[H]istory (repo)' },
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[d]iff view' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = '[q]uit diff view' },
  },
  opts = {
    keymaps = {
      view = {
        { 'n', '<localleader>e',  '<cmd>DiffviewFocusFiles<cr>',                { desc = 'Bring focus to the file panel' } },
        { 'n', '<localleader>b',  '<cmd>DiffviewToggleFiles<cr>',               { desc = 'Toggle the file panel' } },
        { 'n', '<localleader>co', function() require('diffview.actions').conflict_choose('ours') end,   { desc = 'Choose OURS' } },
        { 'n', '<localleader>ct', function() require('diffview.actions').conflict_choose('theirs') end, { desc = 'Choose THEIRS' } },
        { 'n', '<localleader>cb', function() require('diffview.actions').conflict_choose('base') end,   { desc = 'Choose BASE' } },
        { 'n', '<localleader>ca', function() require('diffview.actions').conflict_choose('all') end,    { desc = 'Choose all' } },
        { 'n', '<localleader>cO', function() require('diffview.actions').conflict_choose_all('ours') end,   { desc = 'Choose OURS (whole file)' } },
        { 'n', '<localleader>cT', function() require('diffview.actions').conflict_choose_all('theirs') end, { desc = 'Choose THEIRS (whole file)' } },
        { 'n', '<localleader>cB', function() require('diffview.actions').conflict_choose_all('base') end,   { desc = 'Choose BASE (whole file)' } },
        { 'n', '<localleader>cA', function() require('diffview.actions').conflict_choose_all('all') end,    { desc = 'Choose all (whole file)' } },
      },
      file_panel = {
        { 'n', '<localleader>e', '<cmd>DiffviewFocusFiles<cr>',  { desc = 'Bring focus to the file panel' } },
        { 'n', '<localleader>b', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle the file panel' } },
        { 'n', '<localleader>cO', function() require('diffview.actions').conflict_choose_all('ours') end,   { desc = 'Choose OURS (whole file)' } },
        { 'n', '<localleader>cT', function() require('diffview.actions').conflict_choose_all('theirs') end, { desc = 'Choose THEIRS (whole file)' } },
        { 'n', '<localleader>cB', function() require('diffview.actions').conflict_choose_all('base') end,   { desc = 'Choose BASE (whole file)' } },
        { 'n', '<localleader>cA', function() require('diffview.actions').conflict_choose_all('all') end,    { desc = 'Choose all (whole file)' } },
      },
      file_history_panel = {
        { 'n', '<localleader>e', '<cmd>DiffviewFocusFiles<cr>',  { desc = 'Bring focus to the file panel' } },
        { 'n', '<localleader>b', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle the file panel' } },
      },
    },
  },
}
