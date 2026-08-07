return {
  'xvzc/chezmoi.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('chezmoi').setup {
      watch = true,
    }

    vim.keymap.set('n', '<leader>sD', '<cmd>Telescope chezmoi find_files<cr>', { desc = '[d]otfiles' })
  end,
}
