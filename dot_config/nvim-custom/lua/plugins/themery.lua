return {
  'zaldih/themery.nvim',
  lazy = false,
  config = function()
    require('themery').setup {
      themes = {
        'gruvbox',
        'kanagawa',
        'nordic',
        'gruvbox-material',
        'everforest',
        'darkearth',
      },
    }
  end,
}
