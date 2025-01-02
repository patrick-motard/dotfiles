return {
  'stevearc/oil.nvim',
  opts = {
    default_file_explores = true,
    win_options = {
      wrap = true,
    },
  },
  keys = {
    { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
  },
  config = function(opts)
    require('oil').setup(opts)
  end,
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
