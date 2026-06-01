-- inline-diff.nvim: VSCode-style inline diff in the buffer
-- Shows deletions as virtual lines, additions/modifications highlighted inline
return {
  'cvlmtg/inline-diff.nvim',
  cmd = { 'InlineDiff', 'InlineDiffEnable', 'InlineDiffDisable' },
  keys = {
    { '<leader>gi', '<cmd>InlineDiff<cr>', desc = '[i]nline diff toggle' },
  },
  opts = {
    debounce_ms = 150,
  },
}
