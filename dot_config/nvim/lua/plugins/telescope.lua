return {
  "nvim-telescope/telescope.nvim",
  -- keys = {
  --   { "<C-Tab>", "<cmd>Telescope buffers<cr>", desc = "test" },
  -- },
  config = function(_, opts)
    require("telescope").load_extension("chezmoi")
  end,
}
