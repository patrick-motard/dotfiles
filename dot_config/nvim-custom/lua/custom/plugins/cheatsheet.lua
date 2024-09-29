return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("cheatsheet").setup({
      bundled_cheatsheets = false,
    })
  end,
}
