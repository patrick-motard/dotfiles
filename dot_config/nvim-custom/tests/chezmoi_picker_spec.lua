local picker = require 'config.chezmoi_picker'

local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

local sources = {
  { label = 'default', args = {} },
  { label = 'private', args = { '--source', '/home/patrick/code/dotfiles-private' } },
}

local source_calls = {}
local entries = picker.build_entries(sources, function(source)
  table.insert(source_calls, source.label)
  if source.label == 'default' then
    return { '/home/patrick/.config/nvim/init.lua' }
  end
  return { '/home/patrick/.pi/agent/mcp.json' }
end, function(path)
  return path:gsub('^/home/patrick', '~')
end)

check(#source_calls == 2, 'both chezmoi sources were not queried')
check(source_calls[1] == 'default', 'default source was queried in the wrong order')
check(source_calls[2] == 'private', 'private source was not queried in the wrong order')
check(#entries == 2, 'entries from both sources were not combined')
check(entries[1].display == '[default] ~/.config/nvim/init.lua', 'default entry label is wrong')
check(entries[2].display == '[private] ~/.pi/agent/mcp.json', 'private entry label is wrong')
check(entries[1].value == '/home/patrick/.config/nvim/init.lua', 'default target path is wrong')
check(entries[2].source == sources[2], 'private source identity was not retained')

local source_args = { '--source', '/home/patrick/code/dotfiles-private' }
local args = picker.list_args(source_args)
check(args[1] == '--path-style', 'list arguments omitted path style')
check(args[2] == 'absolute', 'list arguments omitted absolute paths')
check(args[7] == '--source', 'source arguments were not appended')
check(args[8] == source_args[2], 'source path argument was not appended')
args[7] = '--changed'
check(source_args[1] == '--source', 'list_args mutated source arguments')

print 'chezmoi_picker_spec: all assertions passed'
