return {
  {
    --  https://github.com/rebelot/kanagawa.nvim
    'rebelot/kanagawa.nvim',
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
  { 'shaunsingh/nord.nvim' },
  { 'AlexvZyl/nordic.nvim' },
  { 'sainnhe/gruvbox-material' },
  { 'sainnhe/everforest' },
  { 'ptdewey/darkearth-nvim', priority = 1000 },
}
