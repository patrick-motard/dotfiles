-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
  callback = function()
    vim.schedule(require("chezmoi.commands.__edit").watch)
  end,
})
local function remove_trailing_whitespace()
  vim.cmd([[ %s/\s/+$//e ]])
end

vim.api.nvim_create_augroup("TrimWhitespaceGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "TrimWhitespaceGroup",
  pattern = "*",
  callback = remove_trailing_whitespace,
})

-- vim.api.nvim_create_augroup("dotfile_cmds", { clear: true })
-- vim.api.nvim_create_autocmd("BufWritePost", { "BufWritePost",
--   group = "dotfile_cmds",
--   pattern = os.getenv("HOME") .. "/.local/share/chezmoi/*",
--
--   cmd = "lua require('chezmoi.commands.__edit').edit()" }
