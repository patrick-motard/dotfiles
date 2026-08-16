return {
  'Olical/conjure',
  ft = { 'clojure', 'edn' },
  config = function()
    vim.g['conjure#mapping#prefix'] = '<localleader>'
    require('conjure.main').main()
    require('conjure.mapping')['on-filetype']()

    -- nvim-treesitter-textobjects maps bare `,` globally for repeat-move,
    -- which shadows which-key's localleader trigger. Override it in Conjure
    -- buffers so pressing the localleader opens the action menu.
    local function setup_localleader_keymap(buf)
      vim.keymap.set('n', vim.g.maplocalleader, function()
        require('which-key').show { keys = vim.g.maplocalleader, loop = true }
      end, { buffer = buf, desc = 'which-key conjure actions' })
    end

    setup_localleader_keymap(0)
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('conjure-which-key-localleader', { clear = true }),
      pattern = { 'clojure', 'edn' },
      callback = function(event)
        setup_localleader_keymap(event.buf)
      end,
    })
  end,
}
