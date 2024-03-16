return {
  "folke/which-key.nvim",
  keys = {
    { "<leader>cf", ':let @+ = expand("%?")<cr>', desc = "Copy file path." },
    { "<leader>wh", "<C-w>Left", desc = "Go ←" },
    { "<leader>wl", "<C-w>Right", desc = "Go →" },
    { "<leader>wj", "<C-w>Down", desc = "Go ↓" },
    { "<leader>wk", "<C-w>Up", desc = "Go ↑" },
    { "<leader><tab><tab>", "<cmd>Telescope buffers<cr>", desc = "buffers" },

    { "<leader>gu", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy Commit URL" },
    { "<leader>gU", "<cmd>GitBlameCopyFileURL<cr>", desc = "Copy File URL" },

    { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Commit URL" },
    { "<leader>gO", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open File URL" },

    -- { "<leader>w/", "<Cmd>vsplit<CR>", desc = "Split Vertical" },
    -- { "<leader>w-", "<Cmd>split<CR>", desc = "Split Horizontal" },
  },
}
