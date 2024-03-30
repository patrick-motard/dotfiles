-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- vim.keymap.set("i", "fd", "<ESC>", { silent = true })
vim.keymap.set("n", "<leader>bt", "<Cmd>BufferLineTogglePin<CR>")

local home = os.getenv("HOME")

local function get_test_file(filename)
  -- vim.notify(filename)
  -- spec/unit/app/controllers/api/base_controller_spec.rb
  --domains/product_catalog/api.rb
  local test_path = string.format("spec/unit/%s_spec.rb", filename)
  -- vim.notify(test_path)
  vim.cmd.edit(test_path)
end

vim.keymap.set("n", "<leader>ot", function()
  get_test_file(vim.fn.expand("%:r"))
  -- get_test_file(vim.fn.expand("%:t"))
end, { silent = true, noremap = true, desc = "Open test for ruby file." })

--
-- chezmoi
-- vim.keymap.set()
vim.keymap.set("n", "<leader>hhl", "<Cmd>Cheatsheet<CR>", { desc = "list", silent = true, noremap = true })
vim.keymap.set("n", "<leader>hh", "+hotkeys", { silent = true, noremap = true })

local k = vim.keymap

k.set("n", "<leader>hhe", "<Cmd>CheatsheetEdit<CR>", { desc = "edit", silent = true, noremap = true })
