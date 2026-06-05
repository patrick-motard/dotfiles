vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { os.getenv 'HOME' .. '/.local/share/chezmoi/*' },
  callback = function()
    vim.schedule(require('chezmoi.commands.__edit').watch)
  end,
})
local function remove_trailing_whitespace()
  vim.cmd [[ %s/\s\+$//e ]]
end

vim.api.nvim_create_augroup('TrimWhitespaceGroup', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'TrimWhitespaceGroup',
  pattern = '*',
  callback = remove_trailing_whitespace,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.keymap.set('n', '<leader>cs', '<cmd>luafile %<cr>', { desc = 'Source current file', noremap = true, silent = true })
  end,
})

-- Silence W325 swap file warnings - open read-only if another Nvim has the file
vim.api.nvim_create_autocmd('SwapExists', {
  pattern = '*',
  callback = function()
    vim.v.swapchoice = 'e'
  end,
})

local function replace_startup_directory_with_intro()
  if vim.fn.argc() ~= 1 then
    return
  end

  local arg = vim.fn.argv(0)
  if vim.fn.isdirectory(arg) == 0 then
    return
  end

  local current_buf_name = vim.api.nvim_buf_get_name(0)
  if current_buf_name == '' or vim.fn.isdirectory(current_buf_name) == 0 then
    return
  end

  vim.cmd.bwipeout()
  vim.cmd.enew()
  vim.cmd.intro()
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(replace_startup_directory_with_intro)
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'SessionLoadPost',
  callback = function()
    vim.schedule(replace_startup_directory_with_intro)
  end,
})
