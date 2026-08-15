return {
  'Olical/conjure',
  ft = { 'clojure', 'edn' },
  config = function()
    vim.g['conjure#mapping#prefix'] = '<localleader>'
    require('conjure.main').main()
    require('conjure.mapping')['on-filetype']()
  end,
}
