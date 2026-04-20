return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/code/wiki/**.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/code/wiki/**.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'wiki',
        path = '~/code/wiki',
      },
    },

    -- Daily notes config - matches your existing journal/ directory
    daily_notes = {
      folder = 'journal',
      date_format = '%Y-%m-%d',
      template = 'Daily Note.md',
    },

    -- Templates folder
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },

    -- Use telescope for pickers (already installed)
    picker = {
      name = 'telescope.nvim',
    },

    -- Don't create new notes with random IDs - use the title as filename
    note_id_func = function(title)
      if title ~= nil then
        return title
      else
        return tostring(os.time())
      end
    end,

    -- conceallevel = 1 lets obsidian.nvim render link text nicely
    -- without hiding too much
    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
      },
    },
  },

  config = function(_, opts)
    require('obsidian').setup(opts)

    -- Set conceallevel for markdown files in the vault so links render correctly
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = vim.fn.expand '~' .. '/code/wiki/**.md',
      callback = function()
        vim.opt_local.conceallevel = 1
      end,
    })
  end,

  keys = {
    { '<leader>on', '<cmd>ObsidianNew<cr>', desc = '[n]ew note' },
    { '<leader>oo', '<cmd>ObsidianQuickSwitch<cr>', desc = '[o]pen note' },
    { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = '[s]earch vault' },
    { '<leader>od', '<cmd>ObsidianToday<cr>', desc = '[d]aily note' },
    { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = '[b]acklinks' },
    { '<leader>ot', '<cmd>ObsidianTags<cr>', desc = '[t]ags' },
    { '<leader>ol', '<cmd>ObsidianLinks<cr>', desc = '[l]inks in buffer' },
    { '<leader>oT', '<cmd>ObsidianTemplate<cr>', desc = '[T]emplate insert' },
    { '<leader>or', '<cmd>ObsidianRename<cr>', desc = '[r]ename note' },
    -- Follow link under cursor (overrides default gf for markdown in vault)
    { 'gf', '<cmd>ObsidianFollowLink<cr>', desc = 'Follow obsidian link', ft = 'markdown' },
  },
}
