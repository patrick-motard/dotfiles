return {
  'princejoogie/dir-telescope.nvim',
  -- telescope.nvim is a required dependency
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('dir-telescope').setup {
      -- these are the default options set
      hidden = true,
      no_ignore = false,
      show_preview = true,
      follow_symlinks = false,
    }

    -- vim.keymap.set('n', '', '', { desc = 'Move focus to the upper window' })
  end,
}
