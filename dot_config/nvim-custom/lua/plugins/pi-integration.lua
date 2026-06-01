-- Pi integration: send messages to pi, accept/reject diffs
-- Loads pi-send and pi-diff modules
return {
  dir = vim.fn.stdpath('config'),
  name = 'pi-integration',
  lazy = false,
  config = function()
    require('pi-send')
    require('pi-diff')
  end,
}
