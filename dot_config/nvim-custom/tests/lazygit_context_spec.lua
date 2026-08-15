local context = require 'config.lazygit_context'

local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

local roots = {
  ['/unmanaged/config.yml'] = nil,
  ['/work/dotfiles/config.yml'] = '/work/dotfiles',
}

local function resolve(path)
  return roots[path]
end

check(context.find_root({
  '/unmanaged/config.yml',
  '/work/dotfiles/config.yml',
}, resolve) == '/work/dotfiles', 'a repository-backed diff pane should provide the LazyGit root')

check(context.find_root({ '/unmanaged/config.yml' }, resolve) == nil, 'an unmanaged file should not invent a LazyGit root')

print 'lazygit_context_spec: all assertions passed'
