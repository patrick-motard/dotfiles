-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'TSInstall', 'TSUpdate', 'TSUpdateSync' },
  config = function()
    vim.treesitter.language.register('markdown', 'mdx')

    -- Incremental selection keymaps
    vim.keymap.set('n', '<C-space>', function()
      require('nvim-treesitter.incremental_selection').init_selection()
    end, { desc = 'Start incremental selection' })
    vim.keymap.set('v', '<C-space>', function()
      require('nvim-treesitter.incremental_selection').node_incremental()
    end, { desc = 'Increment selection' })
    vim.keymap.set('v', '<bs>', function()
      require('nvim-treesitter.incremental_selection').node_decremental()
    end, { desc = 'Decrement selection' })
  end,
}
