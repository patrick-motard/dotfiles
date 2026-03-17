return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      opts = {
        background_colour = '#000000',
      },
    },
  },
  opts = {
    lsp = {
      -- override markdown rendering so that cmp and other plugins use Treesitter
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    routes = {
      {
        filter = { event = 'msg_show', kind = '', find = '%[Prompt%]' },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = true,        -- use a classic bottom cmdline for search
      command_palette = true,      -- position the cmdline and popupmenu together at the top
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,
      lsp_doc_border = true,       -- add a border to hover docs and signature help
    },
  },
}
