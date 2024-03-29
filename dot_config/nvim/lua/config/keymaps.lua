-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- vim.keymap.set("i", "fd", "<ESC>", { silent = true })
vim.keymap.set("n", "<leader>bt", "<Cmd>BufferLineTogglePin<CR>")

local home = os.getenv("HOME")

local function get_test_file(filename)
  vim.notify(filename)
end

vim.keymap.set("n", "<leader>ok", function()
  get_test_file(vim.fn.expand("%:t"))
end, { silent = true, noremap = true, desc = "test file wip" })

--
-- chezmoi
-- vim.keymap.set()
vim.keymap.set("n", "<leader>hhl", "<Cmd>Cheatsheet<CR>", { desc = "list", silent = true, noremap = true })
vim.keymap.set("n", "<leader>hh", "+hotkeys", { silent = true, noremap = true })

local k = vim.keymap

k.set("n", "<leader>hhe", "<Cmd>CheatsheetEdit<CR>", { desc = "edit", silent = true, noremap = true })
