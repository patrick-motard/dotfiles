return {
  'sudormrfbin/cheatsheet.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>hh', '<Cmd>Cheatsheet<CR>', desc = 'Search Cheatsheet', silent = true, noremap = true },
    {
      '<leader>he',
      function()
        vim.cmd.edit(os.getenv 'MOIDIR' .. '/dot_config/nvim-custom/cheatsheet.txt')
      end,
      desc = 'Edit Cheatsheet',
    },
  },
  config = function()
    require('cheatsheet').setup {
      bundled_cheatsheets = false,
    }
  end,
}
