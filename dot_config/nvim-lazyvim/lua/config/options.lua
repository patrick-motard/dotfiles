-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
local vim = vim
-- local opt = vim.opt

local options = {
  -- colors
  termguicolors = true,
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  -- line wrapping
  wrap = true,
  -- https://neovim.io/doc/user/options.html#'timeoutlen'
  -- How quickly vim will respond to a mapped key
  timeoutlen = 50,
  guicursor = "n-v-c-sm:block-blinkon100,i-ci-ve:ver25-blinkon100,r-cr-o:hor20-blinkon100",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.g.lazyvim_ruby_lsp = "solargraph"
vim.g.lazyvim_ruby_formatter = "rubocop"
