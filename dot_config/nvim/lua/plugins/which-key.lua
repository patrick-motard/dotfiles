return {
  "folke/which-key.nvim",
  keys = {
    { "<leader>cf", ':let @+ = expand("%?")<cr>', desc = "Copy file path." },
    { "<leader>wh", "<C-w>h", desc = "Go ←" },
    { "<leader>wl", "<C-w>l", desc = "Go →" },
    { "<leader>wj", "<C-w>j", desc = "Go ↓" },
    { "<leader>wk", "<C-w>k", desc = "Go ↑" },
  },
}
