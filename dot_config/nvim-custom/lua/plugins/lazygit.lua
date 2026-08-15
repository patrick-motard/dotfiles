local context = require 'config.lazygit_context'

local function repository_root(path)
  local directory = vim.fn.fnamemodify(path, ':p:h')
  local git_entry = vim.fs.find('.git', { path = directory, upward = true })[1]
  return git_entry and vim.fs.dirname(git_entry) or nil
end

local function diff_repository_root()
  local paths = {}

  local function add_buffer(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= '' then
      table.insert(paths, name)
    end
  end

  add_buffer(0)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.wo[win].diff then
      add_buffer(vim.api.nvim_win_get_buf(win))
    end
  end

  return context.find_root(paths, repository_root)
end

local function open_lazygit()
  local root = diff_repository_root()
  if root then
    require('lazygit').lazygit(root)
  else
    vim.cmd 'LazyGit'
  end
end

return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>gg', open_lazygit, desc = '[g] lazygit' },
  },
}
