return {
  "folke/which-key.nvim",
  keys = {
    { "<leader>cf", ':let @+ = expand("%?")<cr>', desc = "Copy file path." },
    { "<leader>wh", "<C-w>h", desc = "Go ←" },
    { "<leader>wl", "<C-w>l", desc = "Go →" },
    { "<leader>wj", "<C-w>j", desc = "Go ↓" },
    { "<leader>wk", "<C-w>k", desc = "Go ↑" },
    { "<leader><tab><tab>", "<cmd>Telescope buffers<cr>", desc = "buffers" },

    { "<leader>gu", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy Commit URL" },
    { "<leader>gU", "<cmd>GitBlameCopyFileURL<cr>", desc = "Copy File URL" },

    { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Commit URL" },
    { "<leader>gO", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open File URL" },
    { "<leader>o", "+super" },
    { "<leader>sd", "<cmd>Telescope chezmoi find_files<cr>", desc = "Dotfiles" },
    -- { "<leader>w/", "<Cmd>vsplit<CR>", desc = "Split Vertical" },
    -- { "<leader>w-", "<Cmd>split<CR>", desc = "Split Horizontal" },
  },
  -- config = function(_, opts) {
  --   local wk = require("which-key")
  --   wk. register
  -- }
}
