-- Notes:
-- To send a notification in vim:
-- vim.notify(filename)
-- This is how to do a nested group in whichkey, for reference.
-- vim.keymap.set("n", "<leader>hh", "+hotkeys", { silent = true, noremap = true })

-- Keymaps:

-- Ruby Related
------------------------------------------------------------------------------------------------------------
-- Find and open test file for currently open ruby file.
local function get_test_file(filename)
  local test_path = string.format("spec/unit/%s_spec.rb", filename)
  vim.cmd.edit(test_path)
end
vim.keymap.set("n", "<leader>ot", function()
  get_test_file(vim.fn.expand("%:r"))
end, { silent = true, noremap = true, desc = "Open test for ruby file." })

-- Cheatsheet Plugin Related
------------------------------------------------------------------------------------------------------------
-- Open Cheatsheet
vim.keymap.set("n", "<leader>hh", "<Cmd>Cheatsheet<CR>", { desc = "Search Cheatsheet", silent = true, noremap = true })
-- Edit Cheatsheet
vim.keymap.set("n", "<leader>he", function()
  vim.cmd.edit(os.getenv("MOIDIR") .. "/dot_config/nvim/cheatsheet.txt")
end, { silent = true, noremap = true, desc = "Edit Cheatsheet" })

vim.keymap.set("n", "<c-w>m", "<c-w>h", { noremap = true })
vim.keymap.set("n", "<c-w>i", "<c-w>l", { noremap = true })
