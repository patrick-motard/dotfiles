local M = {}

M.excludes = {
  '.git',
  'node_modules',
  'vendor',
  'target',
  'dist',
  'build',
  '.cache',
  '__pycache__',
  '.venv',
  '.npm',
  '.cargo/registry',
  '.worktrees',
  'worktrees',
}

function M.find_command(search_dirs)
  local command = { 'fd' }
  if not search_dirs then
    table.insert(command, '.')
  end
  vim.list_extend(command, {
    '--type',
    'f',
    '--hidden',
    '--no-ignore',
  })
  for _, pattern in ipairs(M.excludes) do
    table.insert(command, '--exclude=' .. pattern)
  end
  return command
end

function M.search_dirs(home)
  local ok, private = pcall(require, 'config.home_search_roots')
  if ok and type(private.search_dirs) == 'function' then
    return private.search_dirs(home)
  end
end

function M.contains(command, value)
  for _, argument in ipairs(command) do
    if argument == value or argument:match('^' .. vim.pesc(value) .. '=') then
      return true
    end
  end
  return false
end

return M
