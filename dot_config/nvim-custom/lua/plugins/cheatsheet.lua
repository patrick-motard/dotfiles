return {
  'sudormrfbin/cheatsheet.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('cheatsheet').setup {
      bundled_cheatsheets = false,
    }

    -- Cheatsheet Plugin Related
    ------------------------------------------------------------------------------------------------------------
    -- Open Cheatsheet
    vim.keymap.set('n', '<leader>hh', '<Cmd>Cheatsheet<CR>', { desc = 'Search Cheatsheet', silent = true, noremap = true })
    -- Edit Cheatsheet
    vim.keymap.set('n', '<leader>he', function()
      vim.cmd.edit(os.getenv 'MOIDIR' .. '/dot_config/nvim/cheatsheet.txt')
    end, { silent = true, noremap = true, desc = 'Edit Cheatsheet' })
  end,
}
