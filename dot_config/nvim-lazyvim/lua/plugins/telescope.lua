return {
  "nvim-telescope/telescope.nvim",
  -- keys = {
  --   { "<C-Tab>", "<cmd>Telescope buffers<cr>", desc = "test" },
  -- },
  config = function(_, opts)
    require("telescope").load_extension("chezmoi")
  end,
  keys = {
    {
      "<leader>om",
      LazyVim.pick("files", { cwd = os.getenv("HOME") }),
      desc = "custom find files",
    },
  },
}
