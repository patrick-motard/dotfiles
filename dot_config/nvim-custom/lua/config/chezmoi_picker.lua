local M = {}

function M.list_args(source_args)
  local args = {
    '--path-style',
    'absolute',
    '--include',
    'files',
    '--exclude',
    'externals',
  }
  vim.list_extend(args, vim.deepcopy(source_args or {}))
  return args
end

function M.build_entries(sources, list_source, display_path)
  display_path = display_path or function(path)
    return vim.fn.fnamemodify(path, ':~')
  end

  local entries = {}
  for _, source in ipairs(sources) do
    for _, path in ipairs(list_source(source)) do
      local display = string.format('[%s] %s', source.label, display_path(path))
      table.insert(entries, {
        display = display,
        ordinal = display,
        source = source,
        value = path,
      })
    end
  end

  return entries
end

return M
