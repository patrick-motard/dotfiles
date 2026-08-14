local uv = vim.uv or vim.loop
local M = {}

local excluded_directories = {
  ['.git'] = true,
  ['node_modules'] = true,
  ['mcp-oauth'] = true,
  ['sessions'] = true,
  ['cache'] = true,
  ['caches'] = true,
}

local excluded_extensions = {
  ['.a'] = true,
  ['.class'] = true,
  ['.dylib'] = true,
  ['.gif'] = true,
  ['.gz'] = true,
  ['.ico'] = true,
  ['.jpeg'] = true,
  ['.jpg'] = true,
  ['.map'] = true,
  ['.o'] = true,
  ['.otf'] = true,
  ['.png'] = true,
  ['.so'] = true,
  ['.tar'] = true,
  ['.tgz'] = true,
  ['.ttf'] = true,
  ['.wasm'] = true,
  ['.webp'] = true,
  ['.woff'] = true,
  ['.woff2'] = true,
  ['.zip'] = true,
}

local function join(...)
  local parts = { ... }
  local result = table.remove(parts, 1) or ''
  for _, part in ipairs(parts) do
    if part and part ~= '' then
      result = vim.fs.joinpath(result, part)
    end
  end
  return result
end

local function is_file(path)
  local stat = path and uv.fs_stat(path)
  return stat and stat.type == 'file'
end

local function is_directory(path)
  local stat = path and uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

local function realpath(path)
  return path and (uv.fs_realpath(path) or path) or nil
end

local function basename(path)
  return vim.fs.basename(path)
end

local function extension(path)
  return path:match '(%.[^./]+)$'
end

local function should_skip(name, path)
  if excluded_directories[name] then
    return true
  end
  if name == 'auth.json' or name == 'tokens.json' then
    return true
  end
  return excluded_extensions[extension(path) or ''] == true
end

local function relative(root, path)
  local root_name = root:gsub('/+$', '')
  if path == root_name then
    return ''
  end
  local prefix = root_name .. '/'
  if vim.startswith(path, prefix) then
    return path:sub(#prefix + 1)
  end
  return path
end

local function parent(path)
  return vim.fs.dirname(path)
end

local function read_package_name(root)
  local package_file = join(root, 'package.json')
  if not is_file(package_file) then
    return basename(root)
  end
  local lines = vim.fn.readfile(package_file)
  local contents = table.concat(lines, '\n')
  local ok, package = pcall(vim.json.decode, contents)
  if ok and type(package) == 'table' and type(package.name) == 'string' and package.name ~= '' then
    return package.name
  end
  return basename(root)
end

local function add_resource(resources, seen, record)
  for _, field in ipairs { 'kind', 'name', 'origin', 'logical_path', 'open_path', 'relative_path' } do
    record[field] = tostring(record[field] or '')
  end
  record.ordinal = table.concat({ record.kind, record.name, record.origin, record.relative_path }, ' ')
  local identity = M.identity(record)
  if not seen[identity] then
    seen[identity] = true
    table.insert(resources, record)
  end
end

local function walk(root, logical_root, kind, name, origin, resources, seen, visited, base_root, skip_directories)
  if not is_directory(root) then
    return
  end
  base_root = base_root or root
  local resolved_root = realpath(root)
  if visited[resolved_root] then
    return
  end
  visited[resolved_root] = true

  local handle = uv.fs_scandir(root)
  if not handle then
    return
  end
  while true do
    local entry_name, entry_type = uv.fs_scandir_next(handle)
    if not entry_name then
      break
    end
    local path = join(root, entry_name)
    if not should_skip(entry_name, path) and not (skip_directories and entry_type == 'directory' and skip_directories[entry_name]) then
      local logical_path = join(logical_root, entry_name)
      if entry_type == 'directory' or is_directory(path) then
        walk(path, logical_path, kind, name, origin, resources, seen, visited, base_root, skip_directories)
      elseif entry_type == 'file' or is_file(path) then
        add_resource(resources, seen, {
          kind = kind,
          name = name,
          origin = origin,
          logical_path = logical_path,
          open_path = realpath(path),
          relative_path = relative(base_root, path),
        })
      end
    end
  end
end

local function package_roots(opts, package_root)
  if type(opts.roots) == 'table' then
    local result = {}
    for _, value in ipairs(opts.roots) do
      local path = type(value) == 'table' and (value.path or value.root) or value
      if type(path) == 'string' and is_directory(path) then
        table.insert(result, {
          path = path,
          origin = type(value) == 'table' and value.origin or nil,
          kind = type(value) == 'table' and value.kind or nil,
        })
      end
    end
    return result
  end

  local result = {}
  local seen = {}
  local function add(path, origin, kind)
    if path and is_directory(path) then
      local resolved = realpath(path)
      if not seen[resolved] then
        seen[resolved] = true
        table.insert(result, { path = path, origin = origin, kind = kind })
      end
    end
  end
  add(package_root, 'active-package', 'package')

  local package_parent = opts.package_root_parent
  local function discover(current, depth)
    if not current or depth > 2 or not is_directory(current) then
      return
    end
    local handle = uv.fs_scandir(current)
    if not handle then
      return
    end
    while true do
      local entry_name, entry_type = uv.fs_scandir_next(handle)
      if not entry_name then
        break
      end
      local child = join(current, entry_name)
      if (entry_type == 'directory' or is_directory(child)) and not excluded_directories[entry_name] then
        if is_file(join(child, 'package.json')) then
          add(child, 'package', 'package')
        elseif depth < 2 then
          discover(child, depth + 1)
        end
      end
    end
  end
  discover(package_parent, 0)
  return result
end

local function resolve_package_root(opts, warnings)
  if opts.package_root then
    if is_directory(opts.package_root) then
      return realpath(opts.package_root)
    end
    table.insert(warnings, 'Pi package root does not exist: ' .. opts.package_root)
    return nil
  end

  local executable = opts.pi_executable or vim.fn.exepath 'pi'
  if not executable or executable == '' then
    table.insert(warnings, 'Pi executable not found; active package resources were skipped')
    return nil
  end
  local resolved = realpath(executable)
  local current = is_directory(resolved) and resolved or parent(resolved)
  while current and current ~= '' do
    if is_file(join(current, 'package.json')) then
      return realpath(current)
    end
    local next_parent = parent(current)
    if next_parent == current then
      break
    end
    current = next_parent
  end
  table.insert(warnings, 'Pi package root not found; active package resources were skipped')
  return nil
end

local function extension_records(opts, resources, seen)
  local root = opts.extension_root or join(opts.agent_dir or vim.fn.expand '~/.pi/agent', 'extensions')
  if not is_directory(root) then
    return
  end
  local handle = uv.fs_scandir(root)
  if not handle then
    return
  end
  while true do
    local name, entry_type = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if not name:match '%.disabled$' then
      local deployed = join(root, name)
      if (entry_type == 'directory' or is_directory(deployed)) and not should_skip(name, deployed) then
        local managed = opts.managed_source_root and join(opts.managed_source_root, name)
        local open_root = is_directory(managed) and managed or deployed
        local origin = is_directory(managed) and 'managed' or 'runtime'
        walk(open_root, deployed, 'extension', name, origin, resources, seen, {}, open_root)
      end
    end
  end
end

local function skill_records(opts, resources, seen)
  local root = opts.skill_root or join(opts.agent_dir or vim.fn.expand '~/.pi/agent', 'skills')
  if not is_directory(root) then
    return
  end
  local handle = uv.fs_scandir(root)
  if not handle then
    return
  end
  while true do
    local name, entry_type = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local logical = join(root, name)
    if entry_type == 'directory' or is_directory(logical) then
      local open_root = realpath(logical)
      walk(open_root, logical, 'skill', name, 'user', resources, seen, {}, open_root)
    end
  end
end

local function package_resources(packages, resources, seen)
  for _, package in ipairs(packages) do
    local root = package.path
    local name = read_package_name(root)
    local origin = package.origin or ('package:' .. realpath(root))
    local skip_directories = { extensions = true, skills = true }
    walk(root, root, package.kind or 'package', name, origin, resources, seen, {}, root, skip_directories)

    local function package_children(directory_name, kind)
      local children_root = join(root, directory_name)
      if not is_directory(children_root) then
        return
      end
      local handle = uv.fs_scandir(children_root)
      if not handle then
        return
      end
      while true do
        local child_name, entry_type = uv.fs_scandir_next(handle)
        if not child_name then
          break
        end
        local child_path = join(children_root, child_name)
        if not child_name:match '%.disabled$' and (entry_type == 'directory' or is_directory(child_path)) then
          walk(child_path, child_path, kind, child_name, origin, resources, seen, {}, child_path)
        end
      end
    end

    package_children('skills', 'skill')
    package_children('extensions', 'extension')
  end
end

M.identity = function(resource)
  return table.concat({ resource.kind, resource.name, resource.origin, resource.relative_path }, '\031')
end

M.display = function(resource)
  return string.format('%s/%s [%s] %s', resource.kind, resource.name, resource.origin, resource.logical_path)
end

M.collect = function(opts)
  opts = opts or {}
  local resources = {}
  local warnings = {}
  local seen = {}

  extension_records(opts, resources, seen)
  skill_records(opts, resources, seen)

  local active_package = resolve_package_root(opts, warnings)
  local packages = package_roots(opts, active_package)
  package_resources(packages, resources, seen)

  table.sort(resources, function(left, right)
    return left.ordinal < right.ordinal
  end)
  return resources, warnings
end

return M
