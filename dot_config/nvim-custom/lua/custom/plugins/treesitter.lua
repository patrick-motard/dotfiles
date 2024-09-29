return {
  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  -- { import = 'lazyvim.plugins.extras.lang.typescript' },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.endwise = { enable = true }
      opts.indent = { enable = true, disable = { 'yaml', 'ruby' } }
      opts.ensure_installed = {
        'bash',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'ruby',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      }
    end,
  },
}
