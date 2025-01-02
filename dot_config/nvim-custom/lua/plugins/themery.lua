return {
  'zaldih/themery.nvim',
  -- Force themery to load lazily, even though keys are specified below.
  -- Themery needs to load automatically otherwise the theme won'b be set until the
  -- keys registered below are pressed.
  lazy = false,
  keys = {
    { '<leader>et', '<CMD>Themery<CR>', desc = '[T]hemery' },
  },
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
