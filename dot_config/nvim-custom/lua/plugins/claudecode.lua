-- Claude Code integration for Neovim
-- https://github.com/coder/claudecode.nvim
return {
  'coder/claudecode.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('claudecode').setup {
      -- Port for the WebSocket server (default: 3000)
      port = 3000,

      -- Auto-start the server when Neovim starts
      auto_start = true,

      -- Log level: 'debug', 'info', 'warn', 'error'
      log_level = 'info',
    }
  end,
  keys = {
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = '[c]laude code toggle' },
    { '<leader>cs', '<cmd>ClaudeCodeStart<cr>', desc = '[s]tart server' },
    { '<leader>cq', '<cmd>ClaudeCodeStop<cr>', desc = '[q]uit server' },
  },
}
