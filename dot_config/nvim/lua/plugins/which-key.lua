return {
  "folke/which-key.nvim",
  keys = {
    { "<leader>cf", ':let @+ = expand("%?")<cr>', desc = "Copy file path." },
    { "<leader>wh", "<C-w>h", desc = "Go ←" },
    { "<leader>wl", "<C-w>l", desc = "Go →" },
    { "<leader>wj", "<C-w>j", desc = "Go ↓" },
    { "<leader>wk", "<C-w>k", desc = "Go ↑" },
    { "<leader><tab><tab>", "<cmd>Telescope buffers<cr>", desc = "buffers" },

    { "<leader>gu", "<cmd>GitBlameCopyCommitURL", desc = "Copy Commit URL" },
    { "<leader>gU", "<cmd>GitBlameCopyFileURL", desc = "Copy File URL" },

    { "<leader>go", "<cmd>GitBlameOpenCommitURL", desc = "Open Commit URL" },
    { "<leader>gO", "<cmd>GitBlameOpenFileURL", desc = "Open File URL" },

    -- { "<leader>w/", "<Cmd>vsplit<CR>", desc = "Split Vertical" },
    -- { "<leader>w-", "<Cmd>split<CR>", desc = "Split Horizontal" },
  },
}
