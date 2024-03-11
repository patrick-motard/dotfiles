return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "sainnhe/gruvbox-material" },
  { "sainnhe/edge" },
  { "AlexvZyl/nordic.nvim" },
  { "savq/melange-nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}
