local M = {}

--- Return the first repository root resolved from the supplied buffer paths.
--- The resolver is injected so this selection logic can be tested without a
--- real filesystem or a particular user's directory layout.
function M.find_root(paths, resolve)
  for _, path in ipairs(paths) do
    local root = resolve(path)
    if root then
      return root
    end
  end
end

return M
