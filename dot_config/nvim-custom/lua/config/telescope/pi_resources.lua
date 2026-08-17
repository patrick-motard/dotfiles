local uv = vim.uv or vim.loop
local M = {}

local excluded_directories = {
  ['.cache'] = true,
  ['.git'] = true,
  ['.next'] = true,
  ['.nyc_output'] = true,
  ['.turbo'] = true,
  ['build'] = true,
  ['cache'] = true,
  ['caches'] = true,
  ['coverage'] = true,
  ['mcp-oauth'] = true,
  ['node_modules'] = true,
  ['sessions'] = true,
  ['target'] = true,
  ['temp'] = true,
  ['tmp'] = true,
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
  ['.node'] = true,
  ['.o'] = true,
  ['.otf'] = true,
  ['.pdf'] = true,
  ['.png'] = true,
  ['.so'] = true,
  ['.tar'] = true,
  ['.tgz'] = true,
  ['.tmpl'] = true,
  ['.ttf'] = true,
  ['.wasm'] = true,
  ['.webp'] = true,
  ['.woff'] = true,
  ['.woff2'] = true,
  ['.zip'] = true,
}

local active_package_files = {
  ['CHANGELOG.md'] = true,
  ['README.md'] = true,
  ['package.json'] = true,
}

local active_package_directories = { 'docs', 'examples', 'dist' }

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
  if name == '.env' or name:match '^%.env%.' or name == 'auth.json' or name == 'tokens.json' then
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

local function within_root(root, path)
  local normalized_root = root:gsub('/+$', '')
  return path == normalized_root or vim.startswith(path, normalized_root .. '/')
end

local function parent(path)
  return vim.fs.dirname(path)
end

local function add_warning(warnings, warning_seen, key, message)
  if warning_seen[key] then
    return
  end
  warning_seen[key] = true
  table.insert(warnings, message)
end

local function scan_directory(path, label, warnings, warning_seen, key)
  local stat = uv.fs_stat(path)
  if not stat or stat.type ~= 'directory' then
    add_warning(warnings, warning_seen, key, label .. ' unavailable: ' .. path)
    return nil
  end
  local handle = uv.fs_scandir(path)
  if not handle then
    add_warning(warnings, warning_seen, key, label .. ' unreadable: ' .. path)
    return nil
  end
  return handle
end

local function read_package_name(root)
  local package_file = join(root, 'package.json')
  if not is_file(package_file) then
    return basename(root)
  end
  local read_ok, lines = pcall(vim.fn.readfile, package_file)
  if not read_ok then
    return basename(root)
  end
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

local function add_file(path, logical_path, base_root, boundary_root, kind, name, origin, resources, seen, warnings, warning_seen)
  if should_skip(basename(path), path) or not is_file(path) then
    return
  end
  local resolved_path = uv.fs_realpath(path)
  if not resolved_path then
    add_warning(warnings, warning_seen, 'unresolved:' .. boundary_root, 'Some paths could not be resolved under ' .. logical_path)
    return
  end
  if not within_root(boundary_root, resolved_path) then
    add_warning(warnings, warning_seen, 'escaped:' .. boundary_root, 'Skipped paths outside resource root: ' .. logical_path)
    return
  end
  add_resource(resources, seen, {
    kind = kind,
    name = name,
    origin = origin,
    logical_path = logical_path,
    open_path = resolved_path,
    relative_path = relative(base_root, path),
  })
end

local function walk(root, logical_root, kind, name, origin, resources, seen, warnings, warning_seen, opts)
  opts = opts or {}
  local base_root = opts.base_root or root
  local boundary_root = opts.boundary_root or uv.fs_realpath(root)
  local visited = opts.visited or {}
  if not boundary_root then
    add_warning(warnings, warning_seen, 'unresolved-root:' .. root, 'Resource root could not be resolved: ' .. logical_root)
    return
  end

  local resolved_root = uv.fs_realpath(root)
  if not resolved_root or not within_root(boundary_root, resolved_root) then
    add_warning(warnings, warning_seen, 'escaped:' .. boundary_root, 'Skipped paths outside resource root: ' .. logical_root)
    return
  end
  if visited[resolved_root] then
    return
  end
  visited[resolved_root] = true

  local handle = scan_directory(root, 'Resource directory', warnings, warning_seen, 'unreadable:' .. boundary_root)
  if not handle then
    return
  end
  while true do
    local entry_name, entry_type = uv.fs_scandir_next(handle)
    if not entry_name then
      break
    end
    local path = join(root, entry_name)
    if not should_skip(entry_name, path) and not (opts.skip_directories and opts.skip_directories[entry_name]) then
      local logical_path = join(logical_root, entry_name)
      local stat = uv.fs_stat(path)
      if stat and stat.type == 'directory' then
        walk(path, logical_path, kind, name, origin, resources, seen, warnings, warning_seen, {
          base_root = base_root,
          boundary_root = boundary_root,
          visited = visited,
          skip_directories = opts.skip_directories,
        })
      elseif stat and stat.type == 'file' then
        add_file(path, logical_path, base_root, boundary_root, kind, name, origin, resources, seen, warnings, warning_seen)
      elseif entry_type == 'link' then
        add_warning(warnings, warning_seen, 'unresolved:' .. boundary_root, 'Some paths could not be resolved under ' .. logical_root)
      end
    end
  end
end

local function default_paths(opts)
  local home = opts.home_dir or vim.fn.expand '~'
  local agent_dir = opts.agent_dir or join(home, '.pi', 'agent')
  local package_root_parent = opts.package_root_parent or join(agent_dir, 'git', 'github.com')
  local managed_source_root = opts.managed_source_root
  if managed_source_root == nil then
    local candidates = opts.managed_source_roots
      or {
        join(home, 'code', 'dotfiles-private', 'dot_pi', 'private_agent', 'extensions'),
        join(home, '.local', 'share', 'chezmoi', 'dot_pi', 'private_agent', 'extensions'),
      }
    managed_source_root = candidates[1]
    for _, candidate in ipairs(candidates) do
      if is_directory(candidate) then
        managed_source_root = candidate
        break
      end
    end
  end
  return {
    agent_dir = agent_dir,
    extension_root = opts.extension_root or join(agent_dir, 'extensions'),
    skill_root = opts.skill_root or join(agent_dir, 'skills'),
    package_root_parent = package_root_parent,
    managed_source_root = managed_source_root,
  }
end

local function resolve_package_root(opts, warnings, warning_seen)
  if opts.package_root then
    if is_directory(opts.package_root) then
      return realpath(opts.package_root)
    end
    add_warning(warnings, warning_seen, 'active-package', 'Pi package root unavailable: ' .. opts.package_root)
    return nil
  end

  local executable = opts.pi_executable or vim.fn.exepath 'pi'
  if not executable or executable == '' then
    add_warning(warnings, warning_seen, 'active-package', 'Pi executable not found; active package resources were skipped')
    return nil
  end
  local resolved = uv.fs_realpath(executable)
  if not resolved then
    add_warning(warnings, warning_seen, 'active-package', 'Pi executable could not be resolved; active package resources were skipped')
    return nil
  end
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
  add_warning(warnings, warning_seen, 'active-package', 'Pi package root not found; active package resources were skipped')
  return nil
end

local function active_package_resources(root, resources, seen, warnings, warning_seen)
  local boundary_root = uv.fs_realpath(root)
  if not boundary_root then
    add_warning(warnings, warning_seen, 'active-package', 'Pi package root could not be resolved: ' .. root)
    return
  end
  local name = read_package_name(root)
  for file_name in pairs(active_package_files) do
    local path = join(root, file_name)
    add_file(path, path, root, boundary_root, 'package', name, 'active-package', resources, seen, warnings, warning_seen)
  end
  for _, directory_name in ipairs(active_package_directories) do
    local path = join(root, directory_name)
    if is_directory(path) then
      walk(path, path, 'package', name, 'active-package', resources, seen, warnings, warning_seen, {
        base_root = root,
        boundary_root = boundary_root,
      })
    end
  end
end

local function package_origin(path, package_root_parent)
  local relative_path = relative(package_root_parent, path)
  local parts = vim.split(relative_path, '/', { plain = true, trimempty = true })
  if #parts >= 2 then
    return parts[#parts - 1] .. '/' .. parts[#parts]
  end
  return basename(parent(path)) .. '/' .. basename(path)
end

local function package_roots(opts, paths, warnings, warning_seen)
  local result = {}
  local seen = {}
  local function add(path, origin, kind, require_parent_containment)
    if not is_directory(path) then
      add_warning(warnings, warning_seen, 'package-root:' .. path, 'Package root unavailable: ' .. path)
      return
    end
    local resolved = uv.fs_realpath(path)
    local boundary = uv.fs_realpath(paths.package_root_parent)
    if not resolved or (require_parent_containment and boundary and not within_root(boundary, resolved)) then
      add_warning(warnings, warning_seen, 'package-root:' .. path, 'Package root outside configured package tree: ' .. path)
      return
    end
    if not seen[resolved] then
      seen[resolved] = true
      table.insert(result, {
        path = path,
        origin = origin or package_origin(path, paths.package_root_parent),
        kind = kind,
      })
    end
  end

  if type(opts.roots) == 'table' then
    for _, value in ipairs(opts.roots) do
      local path = type(value) == 'table' and (value.path or value.root) or value
      if type(path) == 'string' then
        add(path, type(value) == 'table' and value.origin or nil, type(value) == 'table' and value.kind or nil, false)
      end
    end
    return result
  end

  local parent_handle = scan_directory(paths.package_root_parent, 'Git-installed package root', warnings, warning_seen, 'package-root-parent')
  if not parent_handle then
    return result
  end
  local package_boundary = uv.fs_realpath(paths.package_root_parent)
  while true do
    local owner = uv.fs_scandir_next(parent_handle)
    if not owner then
      break
    end
    local owner_path = join(paths.package_root_parent, owner)
    local resolved_owner = uv.fs_realpath(owner_path)
    if
      resolved_owner
      and package_boundary
      and within_root(package_boundary, resolved_owner)
      and is_directory(owner_path)
      and not should_skip(owner, owner_path)
    then
      local owner_handle = scan_directory(owner_path, 'Package owner directory', warnings, warning_seen, 'package-owner:' .. owner_path)
      if owner_handle then
        while true do
          local repo = uv.fs_scandir_next(owner_handle)
          if not repo then
            break
          end
          local repo_path = join(owner_path, repo)
          local resolved_repo = uv.fs_realpath(repo_path)
          if resolved_repo and within_root(package_boundary, resolved_repo) and is_directory(repo_path) and is_file(join(repo_path, 'package.json')) then
            add(repo_path, owner .. '/' .. repo, 'package', true)
          end
        end
      end
    end
  end
  return result
end

local function extension_records(paths, resources, seen, warnings, warning_seen)
  local handle = scan_directory(paths.extension_root, 'Pi extension root', warnings, warning_seen, 'extension-root')
  if not handle then
    return
  end

  local managed_available = scan_directory(paths.managed_source_root, 'Managed extension source', warnings, warning_seen, 'managed-source-root') ~= nil

  while true do
    local name = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if not name:match '%.disabled$' then
      local deployed = join(paths.extension_root, name)
      if is_directory(deployed) and not should_skip(name, deployed) then
        local managed = managed_available and join(paths.managed_source_root, name) or nil
        local open_root = managed and is_directory(managed) and managed or deployed
        local origin = managed and is_directory(managed) and 'managed' or 'runtime'
        walk(open_root, deployed, 'extension', name, origin, resources, seen, warnings, warning_seen)
      end
    end
  end
end

local function skill_records(paths, resources, seen, warnings, warning_seen)
  local handle = scan_directory(paths.skill_root, 'Pi skill root', warnings, warning_seen, 'skill-root')
  if not handle then
    return
  end
  while true do
    local name = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local logical_root = join(paths.skill_root, name)
    local open_root = uv.fs_realpath(logical_root)
    if open_root and is_directory(open_root) then
      local skill_path = join(open_root, 'SKILL.md')
      add_file(skill_path, join(logical_root, 'SKILL.md'), open_root, open_root, 'skill', name, 'user', resources, seen, warnings, warning_seen)
    end
  end
end

local function package_resources(packages, resources, seen, warnings, warning_seen)
  for _, package in ipairs(packages) do
    local root = package.path
    local boundary_root = uv.fs_realpath(root)
    local name = read_package_name(root)
    local skip_directories = { extensions = true, skills = true }
    walk(root, root, package.kind or 'package', name, package.origin, resources, seen, warnings, warning_seen, {
      boundary_root = boundary_root,
      skip_directories = skip_directories,
    })

    local extensions_root = join(root, 'extensions')
    if is_directory(extensions_root) then
      local handle = uv.fs_scandir(extensions_root)
      if handle then
        while true do
          local extension_name = uv.fs_scandir_next(handle)
          if not extension_name then
            break
          end
          local extension_root = join(extensions_root, extension_name)
          local resolved_extension = uv.fs_realpath(extension_root)
          if
            not extension_name:match '%.disabled$'
            and resolved_extension
            and within_root(boundary_root, resolved_extension)
            and is_directory(extension_root)
          then
            walk(extension_root, extension_root, 'extension', extension_name, package.origin, resources, seen, warnings, warning_seen)
          end
        end
      end
    end

    local skills_root = join(root, 'skills')
    if is_directory(skills_root) then
      local handle = uv.fs_scandir(skills_root)
      if handle then
        while true do
          local skill_name = uv.fs_scandir_next(handle)
          if not skill_name then
            break
          end
          local skill_root = join(skills_root, skill_name)
          local resolved_skill_root = uv.fs_realpath(skill_root)
          if resolved_skill_root and within_root(boundary_root, resolved_skill_root) and is_directory(skill_root) then
            add_file(
              join(skill_root, 'SKILL.md'),
              join(skill_root, 'SKILL.md'),
              skill_root,
              boundary_root,
              'skill',
              skill_name,
              package.origin,
              resources,
              seen,
              warnings,
              warning_seen
            )
          end
        end
      end
    end
  end
end

M.identity = function(resource)
  return table.concat({ resource.kind, resource.name, realpath(resource.open_path) or resource.open_path }, '\031')
end

M.display = function(resource)
  local display_path = resource.relative_path
  if resource.origin == 'managed' or resource.origin == 'user' then
    display_path = resource.logical_path
  end
  return string.format('%s/%s [%s] %s', resource.kind, resource.name, resource.origin, display_path)
end

M.collect = function(opts)
  opts = opts or {}
  local resources = {}
  local warnings = {}
  local warning_seen = {}
  local seen = {}
  local paths = default_paths(opts)

  extension_records(paths, resources, seen, warnings, warning_seen)
  skill_records(paths, resources, seen, warnings, warning_seen)

  local active_package = resolve_package_root(opts, warnings, warning_seen)
  if active_package then
    active_package_resources(active_package, resources, seen, warnings, warning_seen)
  end
  local packages = package_roots(opts, paths, warnings, warning_seen)
  package_resources(packages, resources, seen, warnings, warning_seen)

  table.sort(resources, function(left, right)
    return left.ordinal < right.ordinal
  end)
  return resources, warnings
end

return M
