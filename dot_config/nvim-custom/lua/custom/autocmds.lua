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
