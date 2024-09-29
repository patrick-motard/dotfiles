-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- { '<leader>wh', '<C-w>h', desc = 'Go ←' },
-- { '<leader>wl', '<C-w>l', desc = 'Go →' },
-- { '<leader>wj', '<C-w>j', desc = 'Go ↓' },
-- { '<leader>wk', '<C-w>k', desc = 'Go ↑' },

local nmap = function(keys, cmd, desc)
  vim.keymap.set('n', '<leader>' .. keys, cmd, { desc = desc, noremap = true })
end

nmap('bb', '<cmd>e #<cr>', 'Previous Buffer')
nmap('qq', '<cmd>q<cr>', 'Quit')
nmap('Q', '<cmd>q!<cr>', 'Quit no save')
nmap('wq', '<cmd>wq<cr>', 'Write Quit')

nmap('gu', '<cmd>GitBlameCopyCommitURL<cr>', 'Copy Commit URL')
nmap('gU', '<cmd>GitBlameCopyFileURL<cr>', 'Copy File URL')
nmap('go', '<cmd>GitBlameOpenCommitURL<cr>', 'Open Commit URL')
nmap('gO', '<cmd>GitBlameOpenFileURL<cr>', 'Open File URL')
nmap('cf', ':let @+ = expand("%?")<cr>', 'Copy file path')
