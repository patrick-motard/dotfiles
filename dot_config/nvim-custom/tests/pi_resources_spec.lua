local resource = require 'config.telescope.pi_resources'
local uv = vim.uv or vim.loop

local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

local function mkdir(path)
  vim.fn.mkdir(path, 'p')
end

local function write(path, lines)
  mkdir(vim.fs.dirname(path))
  vim.fn.writefile(lines or { 'fixture' }, path)
end

local function symlink(target, path)
  mkdir(vim.fs.dirname(path))
  local ok, err = uv.fs_symlink(target, path)
  check(ok ~= nil, string.format('could not create symlink %s: %s', path, err or 'unknown error'))
end

local root = vim.fn.tempname()
local home = vim.fs.joinpath(root, 'home')
local package_root = vim.fs.joinpath(root, 'active-package')
local agent_dir = vim.fs.joinpath(home, '.pi', 'agent')
local extension_root = vim.fs.joinpath(agent_dir, 'extensions')
local skill_root = vim.fs.joinpath(agent_dir, 'skills')
local package_parent = vim.fs.joinpath(agent_dir, 'git', 'github.com')
local managed_source_root = vim.fs.joinpath(home, 'code', 'dotfiles-private', 'dot_pi', 'private_agent', 'extensions')
local pi_target = vim.fs.joinpath(package_root, 'bin', 'pi-real')
local pi_link = vim.fs.joinpath(root, 'bin', 'pi')
local package_a = vim.fs.joinpath(package_parent, 'owner-a', 'package-a')
local package_b = vim.fs.joinpath(package_parent, 'owner-b', 'package-b')
local outside_root = vim.fs.joinpath(root, 'outside')
local outside_secret = vim.fs.joinpath(outside_root, 'secret.txt')

write(vim.fs.joinpath(package_root, 'package.json'), { '{"name":"fixture-pi"}' })
write(vim.fs.joinpath(package_root, 'README.md'))
write(vim.fs.joinpath(package_root, 'CHANGELOG.md'))
write(vim.fs.joinpath(package_root, 'docs', 'guide.md'))
write(vim.fs.joinpath(package_root, 'docs', 'manual.pdf'))
write(vim.fs.joinpath(package_root, 'examples', 'example.ts'))
write(vim.fs.joinpath(package_root, 'dist', 'runtime.js'))
write(vim.fs.joinpath(package_root, 'dist', 'runtime.js.map'))
write(vim.fs.joinpath(package_root, 'src', 'ignored.ts'))
write(vim.fs.joinpath(package_root, '.env'), { 'SECRET=ignored' })
write(vim.fs.joinpath(package_root, 'node_modules', 'ignored.js'))
write(vim.fs.joinpath(package_root, 'mcp-oauth', 'tokens.json'))
write(outside_secret, { 'outside fixture' })
write(pi_target)
symlink(pi_target, pi_link)
symlink(outside_root, vim.fs.joinpath(package_root, 'docs', 'escaped-directory'))
symlink(outside_secret, vim.fs.joinpath(package_root, 'docs', 'escaped-file.md'))

write(vim.fs.joinpath(extension_root, 'disabled.disabled', 'index.ts'))
write(vim.fs.joinpath(extension_root, 'normal', 'runtime.ts'))
write(vim.fs.joinpath(extension_root, 'runtime-only', 'index.ts'))
write(vim.fs.joinpath(managed_source_root, 'normal', 'source.ts'))
write(vim.fs.joinpath(managed_source_root, 'normal', 'coverage', 'ignored.js'))
symlink(outside_root, vim.fs.joinpath(managed_source_root, 'normal', 'escaped-directory'))

local user_skill_target = vim.fs.joinpath(root, 'shared-skills', 'user-skill')
write(vim.fs.joinpath(user_skill_target, 'SKILL.md'), { '# User skill' })
write(vim.fs.joinpath(user_skill_target, 'references', 'ignored.md'))
symlink(user_skill_target, vim.fs.joinpath(skill_root, 'user-skill'))

for _, package in ipairs { package_a, package_b } do
  write(vim.fs.joinpath(package, 'package.json'), { '{"name":"' .. vim.fs.basename(package) .. '"}' })
  write(vim.fs.joinpath(package, 'README.md'))
  write(vim.fs.joinpath(package, 'src', 'index.ts'))
  write(vim.fs.joinpath(package, 'skills', 'shared', 'SKILL.md'), { '# Shared skill' })
  write(vim.fs.joinpath(package, 'skills', 'shared', 'references', 'ignored.md'))
end
write(vim.fs.joinpath(package_a, 'extensions', 'package-extension', 'index.ts'))
write(vim.fs.joinpath(package_a, 'extensions', 'package-extension', 'coverage', 'ignored.js'))
symlink(outside_root, vim.fs.joinpath(package_a, 'extensions', 'package-extension', 'escaped-directory'))

-- Only the injectable machine home and Pi executable are supplied. All resource
-- roots use the same derived defaults as the zero-option production call.
local resources, warnings = resource.collect {
  home_dir = home,
  pi_executable = pi_link,
}

check(#resources > 0, 'fixture should produce resources')

local function find(kind, name, suffix, origin)
  for _, item in ipairs(resources) do
    if item.kind == kind and item.name == name and item.relative_path == suffix and (not origin or item.origin == origin) then
      return item
    end
  end
end

local function contains_path(fragment)
  for _, item in ipairs(resources) do
    if item.logical_path:find(fragment, 1, true) or item.open_path:find(fragment, 1, true) then
      return true
    end
  end
  return false
end

local function has_warning(items, fragment)
  for _, warning in ipairs(items) do
    if warning:find(fragment, 1, true) then
      return true
    end
  end
  return false
end

local readme = find('package', 'fixture-pi', 'README.md', 'active-package')
check(readme ~= nil, 'active package README is missing')
check(readme.open_path == uv.fs_realpath(vim.fs.joinpath(package_root, 'README.md')), 'README open path is wrong')
check(vim.fn.filereadable(readme.open_path) == 1, 'README open path does not exist')
check(find('package', 'fixture-pi', 'CHANGELOG.md', 'active-package') ~= nil, 'active package changelog is missing')
check(find('package', 'fixture-pi', 'docs/guide.md', 'active-package') ~= nil, 'package docs are missing')
check(find('package', 'fixture-pi', 'examples/example.ts', 'active-package') ~= nil, 'package examples are missing')
check(find('package', 'fixture-pi', 'dist/runtime.js', 'active-package') ~= nil, 'package runtime is missing')
check(find('package', 'fixture-pi', 'bin/pi-real', 'active-package') == nil, 'active package bin escaped the allowlist')
check(find('package', 'fixture-pi', 'src/ignored.ts', 'active-package') == nil, 'active package src escaped the allowlist')

for _, item in ipairs(resources) do
  for _, field in ipairs { 'kind', 'name', 'origin', 'logical_path', 'open_path', 'relative_path', 'ordinal' } do
    check(type(item[field]) == 'string', field .. ' is not a string')
  end
  check(not item.logical_path:find('node_modules', 1, true), 'node_modules leaked into inventory')
  check(not item.logical_path:find 'mcp%-oauth', 'mcp-oauth leaked into inventory')
  check(not item.logical_path:find 'tokens%.json', 'token file leaked into inventory')
  check(not item.logical_path:find '%.map$', 'source map leaked into inventory')
  check(not item.logical_path:find 'coverage', 'coverage output leaked into inventory')
  check(not item.logical_path:find 'references/ignored%.md', 'skill subtree content leaked into inventory')
  check(not item.logical_path:find 'manual%.pdf', 'binary asset leaked into inventory')
  check(type(item.ordinal) == 'string' and item.ordinal ~= '', 'ordinal is missing')
end
check(not contains_path(outside_secret), 'a symlink escaped its intended resource root')
check(has_warning(warnings, 'outside resource root'), 'symlink escape should produce one concise warning')
check(find('extension', 'disabled.disabled', 'index.ts') == nil, 'disabled extension was included')

local managed = find('extension', 'normal', 'source.ts', 'managed')
check(managed ~= nil, 'default managed extension source is missing')
check(managed.open_path == uv.fs_realpath(vim.fs.joinpath(managed_source_root, 'normal', 'source.ts')), 'managed source did not win')
check(managed.logical_path == vim.fs.joinpath(extension_root, 'normal', 'source.ts'), 'managed logical label changed')
local runtime = find('extension', 'runtime-only', 'index.ts', 'runtime')
check(runtime ~= nil, 'runtime extension fallback is missing')

local user = find('skill', 'user-skill', 'SKILL.md', 'user')
check(user ~= nil, 'user skill is missing')
check(user.logical_path == vim.fs.joinpath(skill_root, 'user-skill', 'SKILL.md'), 'user skill logical symlink label changed')
check(user.open_path == uv.fs_realpath(vim.fs.joinpath(user_skill_target, 'SKILL.md')), 'user skill symlink target is wrong')
local user_identity = resource.identity(user)
check(user_identity:find(user.open_path, 1, true) ~= nil, 'identity omits resolved open path')
check(
  user_identity == resource.identity(vim.tbl_extend('force', user, { origin = 'alias', relative_path = 'alias/SKILL.md' })),
  'identity changed for an alias of the same resolved file'
)
check(
  user_identity ~= resource.identity(vim.tbl_extend('force', user, { open_path = readme.open_path })),
  'identity did not distinguish a different resolved file'
)
check(resource.display(user):find(user.logical_path, 1, true) ~= nil, 'display omits the user skill logical path')

local duplicate_skills = {}
for _, item in ipairs(resources) do
  if item.kind == 'skill' and item.name == 'shared' and item.relative_path == 'SKILL.md' then
    table.insert(duplicate_skills, item)
  end
end
check(#duplicate_skills == 2, 'same-name package skills were not retained separately')
check(resource.identity(duplicate_skills[1]) ~= resource.identity(duplicate_skills[2]), 'duplicate package skill identities collided')
local package_skill = find('skill', 'shared', 'SKILL.md', 'owner-a/package-a')
check(package_skill ~= nil, 'default package skill discovery is missing')
check(resource.display(package_skill):find 'owner%-a/package%-a', 'package display omits owner/repository origin')
check(resource.display(package_skill):find 'SKILL%.md', 'package display omits target-relative path')
check(not resource.display(package_skill):find(package_a, 1, true), 'package display exposes an absolute package path')
check(find('extension', 'package-extension', 'index.ts', 'owner-a/package-a') ~= nil, 'default package extension discovery is missing')
check(find('package', 'package-a', 'README.md', 'owner-a/package-a') ~= nil, 'default package root discovery is missing')

local explicit_package = vim.fs.joinpath(root, 'explicit-package')
write(vim.fs.joinpath(explicit_package, 'package.json'), { '{"name":"explicit-package"}' })
write(vim.fs.joinpath(explicit_package, 'README.md'))
local explicit_resources = resource.collect {
  home_dir = home,
  pi_executable = vim.fs.joinpath(root, 'missing-pi'),
  roots = { { path = explicit_package, origin = 'custom/explicit' } },
}
local explicit_found = false
for _, item in ipairs(explicit_resources) do
  explicit_found = explicit_found
    or (item.kind == 'package' and item.name == 'explicit-package' and item.origin == 'custom/explicit' and item.relative_path == 'README.md')
end
check(explicit_found, 'explicit package root injection no longer works outside the conventional package tree')

local missing_path = vim.fs.joinpath(root, 'missing')
local missing_resources, missing_warnings = resource.collect {
  pi_executable = vim.fs.joinpath(root, 'missing-pi'),
  extension_root = missing_path,
  skill_root = missing_path,
  package_root_parent = missing_path,
  managed_source_root = missing_path,
}
check(#missing_resources == 0, 'missing roots should not produce resources')
check(has_warning(missing_warnings, 'Pi extension root unavailable'), 'missing extension root warning is absent')
check(has_warning(missing_warnings, 'Pi skill root unavailable'), 'missing skill root warning is absent')
check(has_warning(missing_warnings, 'Pi executable could not be resolved'), 'missing Pi warning is absent')
check(has_warning(missing_warnings, 'Git-installed package root unavailable'), 'missing package root warning is absent')

local fallback_resources, fallback_warnings = resource.collect {
  pi_executable = vim.fs.joinpath(root, 'missing-pi'),
  home_dir = home,
  roots = {},
  managed_source_root = missing_path,
}
check(has_warning(fallback_warnings, 'Managed extension source unavailable'), 'missing managed source warning is absent')
local fallback_has_extension = false
local fallback_has_skill = false
for _, item in ipairs(fallback_resources) do
  fallback_has_extension = fallback_has_extension or item.kind == 'extension'
  fallback_has_skill = fallback_has_skill or item.kind == 'skill'
end
check(fallback_has_extension and fallback_has_skill, 'missing Pi should retain extension and skill resources')

vim.fn.delete(root, 'rf')
print 'pi_resources_spec: all assertions passed'
