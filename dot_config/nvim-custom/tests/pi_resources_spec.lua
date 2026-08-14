local resource = require 'config.telescope.pi_resources'
local uv = vim.uv or vim.loop

local failures = 0
local function check(condition, message)
  if not condition then
    failures = failures + 1
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
local package_root = vim.fs.joinpath(root, 'active-package')
local package_parent = vim.fs.joinpath(root, 'packages')
local agent_dir = vim.fs.joinpath(root, 'agent')
local extension_root = vim.fs.joinpath(agent_dir, 'extensions')
local skill_root = vim.fs.joinpath(agent_dir, 'skills')
local managed_source_root = vim.fs.joinpath(root, 'managed-extensions')
local pi_target = vim.fs.joinpath(root, 'bin', 'pi-real')
local pi_link = vim.fs.joinpath(root, 'bin', 'pi')
local package_a = vim.fs.joinpath(package_parent, 'package-a')
local package_b = vim.fs.joinpath(package_parent, 'package-b')

write(vim.fs.joinpath(package_root, 'package.json'), { '{"name":"fixture-pi"}' })
write(vim.fs.joinpath(package_root, 'README.md'))
write(vim.fs.joinpath(package_root, 'docs', 'guide.md'))
write(vim.fs.joinpath(package_root, 'examples', 'example.ts'))
write(vim.fs.joinpath(package_root, 'dist', 'runtime.js'))
write(vim.fs.joinpath(package_root, 'dist', 'runtime.js.map'))
write(vim.fs.joinpath(package_root, 'node_modules', 'ignored.js'))
write(vim.fs.joinpath(package_root, 'mcp-oauth', 'tokens.json'))
write(pi_target)
symlink(pi_target, pi_link)

write(vim.fs.joinpath(extension_root, 'disabled.disabled', 'index.ts'))
write(vim.fs.joinpath(extension_root, 'normal', 'runtime.ts'))
write(vim.fs.joinpath(managed_source_root, 'normal', 'source.ts'))

local user_skill_target = vim.fs.joinpath(root, 'shared-skills', 'user-skill')
write(vim.fs.joinpath(user_skill_target, 'SKILL.md'), { '# User skill' })
write(vim.fs.joinpath(user_skill_target, 'references', 'notes.md'))
symlink(user_skill_target, vim.fs.joinpath(skill_root, 'user-skill'))

for _, package in ipairs { package_a, package_b } do
  write(vim.fs.joinpath(package, 'package.json'), { '{"name":"' .. vim.fs.basename(package) .. '"}' })
  write(vim.fs.joinpath(package, 'skills', 'shared', 'SKILL.md'), { '# Shared skill' })
end

local opts = {
  pi_executable = pi_link,
  agent_dir = agent_dir,
  package_root = package_root,
  package_root_parent = package_parent,
  managed_source_root = managed_source_root,
  extension_root = extension_root,
  skill_root = skill_root,
  roots = { package_root, package_a, package_b },
}
local resources, warnings = resource.collect(opts)

check(#warnings == 0, 'fixture package should not produce warnings')
check(#resources > 0, 'fixture should produce resources')

local function find(kind, name, suffix)
  for _, item in ipairs(resources) do
    if item.kind == kind and item.name == name and item.relative_path == suffix then
      return item
    end
  end
end

local readme = find('package', 'fixture-pi', 'README.md')
check(readme ~= nil, 'active package README is missing')
check(
  readme.open_path == (uv.fs_realpath(vim.fs.joinpath(package_root, 'README.md')) or vim.fs.joinpath(package_root, 'README.md')),
  'README open path is wrong'
)
check(vim.fn.filereadable(readme.open_path) == 1, 'README open path does not exist')
check(find('package', 'fixture-pi', 'docs/guide.md') ~= nil, 'package docs are missing')
check(find('package', 'fixture-pi', 'examples/example.ts') ~= nil, 'package examples are missing')
check(find('package', 'fixture-pi', 'dist/runtime.js') ~= nil, 'package runtime is missing')

for _, item in ipairs(resources) do
  check(not item.logical_path:find('node_modules', 1, true), 'node_modules leaked into inventory')
  check(not item.logical_path:find 'mcp%-oauth', 'mcp-oauth leaked into inventory')
  check(not item.logical_path:find 'tokens%.json', 'token file leaked into inventory')
  check(not item.logical_path:find '%.map$', 'source map leaked into inventory')
  check(type(item.ordinal) == 'string' and item.ordinal ~= '', 'ordinal is missing')
  check(type(item.kind) == 'string' and type(item.name) == 'string', 'resource identity fields are missing')
end
check(find('extension', 'disabled.disabled', 'index.ts') == nil, 'disabled extension was included')
local managed = find('extension', 'normal', 'source.ts')
check(managed ~= nil, 'managed extension source is missing')
check(
  managed.open_path
    == (uv.fs_realpath(vim.fs.joinpath(managed_source_root, 'normal', 'source.ts')) or vim.fs.joinpath(managed_source_root, 'normal', 'source.ts')),
  'managed source did not win'
)
check(managed.logical_path == vim.fs.joinpath(extension_root, 'normal', 'source.ts'), 'managed logical label changed')

local user = find('skill', 'user-skill', 'SKILL.md')
check(user ~= nil, 'user skill is missing')
check(user.logical_path == vim.fs.joinpath(skill_root, 'user-skill', 'SKILL.md'), 'user skill logical symlink label changed')
check(
  user.open_path == (uv.fs_realpath(vim.fs.joinpath(user_skill_target, 'SKILL.md')) or vim.fs.joinpath(user_skill_target, 'SKILL.md')),
  'user skill symlink target is wrong'
)
check(resource.identity(user):find(user.relative_path, 1, true) ~= nil, 'identity omits relative path')
check(resource.display(user):find(user.logical_path, 1, true) ~= nil, 'display omits logical path')

local duplicate_skills = {}
for _, item in ipairs(resources) do
  if item.kind == 'skill' and item.name == 'shared' and item.relative_path == 'SKILL.md' then
    table.insert(duplicate_skills, item)
  end
end
check(#duplicate_skills == 2, 'same-name package skills were not retained separately')
check(resource.identity(duplicate_skills[1]) ~= resource.identity(duplicate_skills[2]), 'duplicate package skill identities collided')

local missing_resources, missing_warnings = resource.collect {
  pi_executable = vim.fs.joinpath(root, 'missing-pi'),
  agent_dir = agent_dir,
  extension_root = extension_root,
  skill_root = skill_root,
  roots = {},
}
check(#missing_warnings == 1, 'missing pi should produce exactly one warning')
check(#missing_resources > 0, 'missing pi should retain extension and skill results')
check(find('extension', 'normal', 'source.ts') ~= nil, 'fixture extension unexpectedly disappeared')
local missing_has_extension = false
local missing_has_skill = false
for _, item in ipairs(missing_resources) do
  missing_has_extension = missing_has_extension or item.kind == 'extension'
  missing_has_skill = missing_has_skill or item.kind == 'skill'
end
check(missing_has_extension and missing_has_skill, 'missing pi results omitted extension or skill resources')

vim.fn.delete(root, 'rf')
print(string.format('pi_resources_spec: %d assertions passed', 36 - failures))
