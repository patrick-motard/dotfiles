return {
  {
    --  https://github.com/rebelot/kanagawa.nvim
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        background = {
          dark = 'wave',
          light = 'lotus',
        },
      }
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    -- init = function()
    config = function()
      require('gruvbox').setup {}
      vim.o.background = 'dark'
      vim.cmd 'colorscheme gruvbox'
    end,
  },
  -- {
  --   'morhetz/gruvbox',
  --   lazy = true,
  --   config = function()
  --     vim.o.background = 'dark'
  --     vim.g.gruvbox_contrast_dark = 'medium'
  --     vim.g.gruvbox_contrast_light = 'soft'
  --     -- vim.cmd [[colorscheme gruvbox]]
  --   end,
  -- },
  { 'shaunsingh/nord.nvim', lazy = true },
  { 'AlexvZyl/nordic.nvim', lazy = true },
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'sainnhe/everforest', lazy = true },
  { 'ptdewey/darkearth-nvim', lazy = true, priority = 1000 },
}
