return {
  'xvzc/chezmoi.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('chezmoi').setup {
      watch = true,
    }

    vim.keymap.set('n', '<leader>sd', '<cmd>Telescope chezmoi find_files<cr>', { desc = '[D]otfiles' })
  end,
}
