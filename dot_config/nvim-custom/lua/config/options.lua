-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line and column your cursor is on
vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.termguicolors = true

-- Swap file settings - reduce E325 swap file warnings
-- Keep swap files but auto-recover without prompting
vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath 'data' .. '/swap//'
-- Create swap directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath 'data' .. '/swap', 'p')
-- Shorter time before writing swap file (default 4000ms)
vim.opt.updatetime = 250
-- Auto-read files when changed outside of vim
vim.opt.autoread = true
-- Check for external file changes when cursor stops moving
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- Compatibility shim for deprecated vim.lsp.util.jump_to_location
-- This bridges the old API to the new vim.lsp.util.show_document API
-- Remove this once telescope.nvim and other plugins migrate to the new API
if vim.lsp.util.jump_to_location then
  local original_jump = vim.lsp.util.jump_to_location
  vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
    -- If location is a table with uri, convert to the new format
    if type(location) == 'table' and location.uri then
      return vim.lsp.util.show_document(location, offset_encoding, { reuse_win = reuse_win, focus = true })
    end
    -- Otherwise, call the original function
    return original_jump(location, offset_encoding, reuse_win)
  end
end
