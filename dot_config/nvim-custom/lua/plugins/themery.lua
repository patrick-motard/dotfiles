return {
  'zaldih/themery.nvim',
  lazy = false,
  config = function()
    require('themery').setup {
      themes = {
        -- 'gruvbox',
        'nordic',
        'nord',
        {
          name = 'kanagawa wave',
          colorscheme = 'kanagawa-wave',
          -- before = [[
          --   vim.o.background = 'dark'
          -- ]],
        },
        { name = 'kanagawa dragon', colorscheme = 'kanagawa-dragon' },
        { name = 'kanagawa lotus', colorscheme = 'kanagawa-lotus' },

        'gruvbox-material',
        'everforest',
        'darkearth',
        {
          name = 'Gruvbox Dark Hard',
          colorscheme = 'gruvbox',
          before = [[
          vim.opt.background = 'dark'
          vim.g.gruvbox_contrast_dark = 'hard'
          ]],
        },

        {
          name = 'Gruvbox Light Hard',
          colorscheme = 'gruvbox',
          before = [[
          vim.opt.background = 'light'
          vim.g.gruvbox_contrast_dark = 'hard'
          ]],
        },
      },
      -- globalBefore = [[ vim.opt.background = 'dark' ]],
      -- globalAfter = [[ vim.opt.background = 'dark' ]],
    }
  end,
}
