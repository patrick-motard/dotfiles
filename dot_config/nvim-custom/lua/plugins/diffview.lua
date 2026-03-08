return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[h]istory (file)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[H]istory (repo)' },
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[d]iff view' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = '[q]uit diff view' },
  },
}
