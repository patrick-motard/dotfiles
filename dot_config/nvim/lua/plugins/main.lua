return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "sainnhe/gruvbox-material" },
  { "sainnhe/everforest" },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  { "google/vim-jsonnet" },
}
