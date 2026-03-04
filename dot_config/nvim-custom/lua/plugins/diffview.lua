return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Repo History' },
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff View (Changes)' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close Diff View' },
  },
}
