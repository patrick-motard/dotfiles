return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "AlexvZyl/nordic.nvim" },
  { "sainnhe/gruvbox-material" },
  { "sainnhe/everforest" },
  { "ptdewey/darkearth-nvim", priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
  -- Configure LazyVim to load gruvbox
  -- This is how you set the default theme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  { "google/vim-jsonnet" },
}
