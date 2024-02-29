-- plugins/git-blame.lua
return {
  {
    "f-person/git-blame.nvim",
    config = function()
      require("git-blame").setup({
        message_when_not_committed = " ",
      })
    end,
  },
}
