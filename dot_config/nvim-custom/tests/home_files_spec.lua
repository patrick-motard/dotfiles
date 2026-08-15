local home_files = require 'config.home_files'

local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

local command = home_files.find_command()

check(command[1] == 'fd', 'home file search should use fd')
check(command[2] == '.', 'home file search should provide fd a match-all pattern')
check(home_files.contains(command, '--type'), 'home file search should restrict results to files')
check(home_files.contains(command, '--hidden'), 'home file search should include hidden files')
check(home_files.contains(command, '--no-ignore'), 'home file search should include ignored files')
check(home_files.contains(command, '--exclude=node_modules'), 'home file search should exclude node_modules')
check(home_files.contains(command, '--exclude=.git'), 'home file search should exclude .git')
check(home_files.contains(command, '--exclude=.worktrees'), 'home file search should exclude .worktrees')
check(home_files.contains(command, '--exclude=worktrees'), 'home file search should exclude worktrees')
check(not home_files.contains(command, '--follow'), 'home file search should not follow symlinks')
check(type(home_files.search_dirs) == 'function', 'home file search should support an optional private search-root provider')

local scoped_command = home_files.find_command({ '/home/tester/code/project' })
check(scoped_command[1] == 'fd', 'scoped home search should use fd')
check(scoped_command[2] == '--type',
  'scoped home search should let Telescope supply the fd pattern')
check(not home_files.contains(scoped_command, '.'),
  'scoped home search should not add a second fd pattern/search root')

print 'home_files_spec: all assertions passed'
