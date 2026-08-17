-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

local function diff_active()
  return vim.wo.diff
end

local function diff_action(action)
  return function()
    if diff_active() then
      action()
    end
  end
end

local diff_keymaps = {
  {
    '<leader>d]',
    function()
      vim.cmd.normal { ']c', bang = true }
    end,
    'Next diff change',
  },
  {
    '<leader>d[',
    function()
      vim.cmd.normal { '[c', bang = true }
    end,
    'Previous diff change',
  },
  {
    '<leader>do',
    function()
      vim.cmd.diffget()
    end,
    'Obtain change from other pane',
  },
  {
    '<leader>dP',
    function()
      vim.cmd.diffput()
    end,
    'Put change into other pane',
  },
  {
    '<leader>du',
    function()
      vim.cmd.diffupdate()
    end,
    'Update diff',
  },
  {
    '<leader>dx',
    function()
      vim.cmd.diffoff { bang = true }
    end,
    'Disable diff mode',
  },
}

local function refresh_diff_keymaps(buf)
  for _, mapping in ipairs(diff_keymaps) do
    pcall(vim.keymap.del, 'n', mapping[1], { buffer = buf })
  end
  if not diff_active() then
    return
  end
  for _, mapping in ipairs(diff_keymaps) do
    vim.keymap.set('n', mapping[1], diff_action(mapping[2]), {
      buffer = buf,
      silent = true,
      desc = mapping[3],
    })
  end
end

local diff_keymap_group = vim.api.nvim_create_augroup('which-key-diff-context', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = diff_keymap_group,
  callback = function(args)
    refresh_diff_keymaps(args.buf)
  end,
})
vim.api.nvim_create_autocmd('OptionSet', {
  group = diff_keymap_group,
  pattern = 'diff',
  callback = function()
    refresh_diff_keymaps(0)
  end,
})
refresh_diff_keymaps(0)

return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    triggers = {
      { '<auto>', mode = 'nxso' },
      { ',', mode = { 'n', 'v' } },
    },
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      mappings = vim.g.have_nerd_font,
      -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
      -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },

    -- Document existing key chains. Diff and pi-diff mappings are buffer-local,
    -- so WhichKey discovers them only while their context is active.
    spec = {
      { '<leader>c', group = '[c] Code/Claude', mode = { 'n', 'x' } },
      { '<leader>b', group = '[b] Buffer' },
      { '<leader>g', group = '[g] Git' },
      { '<leader>o', group = '[o] Octo' },
      { '<leader>p', group = '[p] Project' },
      { '<leader>r', group = '[r] Rename' },
      { '<leader>s', group = '[s] Search' },
      { '<leader>sP', desc = '[P]i resources' },
      { '<leader>w', group = '[w] Workspace' },
      { '<leader>t', group = '[t] Toggle' },
      { '<leader>e', group = '[e] Editor' },
      { '<leader>h', group = '[h] Help', mode = { 'n', 'v' } },
      { '<leader>cs', group = '[s] Swap next' },
      { '<leader>cS', group = '[S] Swap previous' },
      { '<leader>q', group = '[q] Quit' },
      { '<leader>el', '<CMD>Lazy<CR>', desc = '[l]azy UI' },
      { '<C-w>h', '', desc = 'which_key_ignore' },
      { '<C-w>j', '', desc = 'which_key_ignore' },
      { '<C-w>k', '', desc = 'which_key_ignore' },
      { '<C-w>l', '', desc = 'which_key_ignore' },
    },
  },
}
