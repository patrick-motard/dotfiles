-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim' },
        { path = 'flash.nvim' },
        { path = 'auto-session' },
        { path = 'indent-blankline.nvim' },
        { path = 'nvim-lspconfig' },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
}
