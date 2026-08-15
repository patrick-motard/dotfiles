local layout = require 'config.cheatsheet_telescope'

local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

for _, picker_width in ipairs { 24, 40, 80, 160 } do
  local columns = layout.calculate_columns(picker_width)
  local total = columns.section + columns.description + columns.cheatcode
  check(total + 4 <= picker_width, string.format('columns overflow picker width %d', picker_width))
  check(columns.section >= 1, 'section column disappeared')
  check(columns.description >= 1, 'description column disappeared')
  check(columns.cheatcode >= 1, 'cheatcode column disappeared')
end

local narrow = layout.calculate_columns(40)
check(narrow.section >= 8, 'narrow section column is unreadable')
check(narrow.description >= 14, 'narrow description column is unreadable')
check(narrow.cheatcode >= 12, 'narrow cheatcode column is unreadable')

local wide = layout.calculate_columns(160)
check(wide.section > narrow.section, 'wide section column did not grow')
check(wide.description > narrow.description, 'wide description column did not grow')
check(wide.cheatcode > narrow.cheatcode, 'wide cheatcode column did not grow')

print 'cheatsheet_layout_spec: all assertions passed'
