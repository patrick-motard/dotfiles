return {
  "folke/which-key.nvim",
  keys = {
    { "<leader>cf", ':let @+ = expand("%?")<cr>', desc = "Copy file path." },
    { "<leader>wh", "<C-w>h", desc = "Go ←" },
    { "<leader>wl", "<C-w>l", desc = "Go →" },
    { "<leader>wj", "<C-w>j", desc = "Go ↓" },
    { "<leader>wk", "<C-w>k", desc = "Go ↑" },
    -- { "<leader>cs", "<cmd>term ma<cr>", desc = "Source dotfiles" },
    -- { "<leader>w/", "<Cmd>vsplit<CR>", desc = "Split Vertical" },
    -- { "<leader>w-", "<Cmd>split<CR>", desc = "Split Horizontal" },
  },
}
