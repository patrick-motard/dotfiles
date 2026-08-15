local M = {}

local separator_width = 2
local minimums = {
  section = 8,
  description = 14,
  cheatcode = 12,
}

local function width_function(column)
  return function(_, picker_width)
    local columns = M.calculate_columns(picker_width)
    return columns[column]
  end
end

M.calculate_columns = function(picker_width)
  picker_width = math.max(1, math.floor(tonumber(picker_width) or 1))
  local available = math.max(3, picker_width - (2 * separator_width))
  local minimum_total = minimums.section + minimums.description + minimums.cheatcode

  if available < minimum_total then
    local section = math.max(1, math.floor(available * 0.2))
    local cheatcode = math.max(1, math.floor(available * 0.3))
    local description = available - section - cheatcode
    if description < 1 then
      description = 1
      cheatcode = math.max(1, available - section - description)
    end
    return {
      section = section,
      description = description,
      cheatcode = cheatcode,
    }
  end

  local remaining = available - minimum_total
  local section = minimums.section + math.floor(remaining * 0.2)
  local cheatcode = minimums.cheatcode + math.floor(remaining * 0.3)
  local description = available - section - cheatcode
  return {
    section = section,
    description = description,
    cheatcode = cheatcode,
  }
end

M.pick_cheat = function(telescope_opts, opts)
  telescope_opts = telescope_opts or {}

  local finders = require 'telescope.finders'
  local pickers = require 'telescope.pickers'
  local config = require('telescope.config').values
  local entry_display = require 'telescope.pickers.entry_display'
  local cheatsheet = require 'cheatsheet'

  pickers
    .new(telescope_opts, {
      prompt_title = 'Cheat',
      finder = finders.new_table {
        results = cheatsheet.get_cheats(opts),
        entry_maker = function(entry)
          local displayer = entry_display.create {
            separator = ' ▏',
            items = {
              { width = width_function 'section' },
              { width = width_function 'description' },
              { width = width_function 'cheatcode' },
            },
          }

          local tags = table.concat(entry.tags, ' ')
          return {
            value = entry,
            display = function(ent)
              return displayer {
                { ent.value.section, 'cheatMetadataSection' },
                { ent.value.description, 'cheatDescription' },
                { ent.value.cheatcode, 'cheatCode' },
              }
            end,
            ordinal = string.format('%s %s %s %s', entry.section, entry.description, tags, entry.cheatcode),
          }
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        local mappings = require('cheatsheet.config').options.telescope_mappings
        for keybind, action in pairs(mappings) do
          map('i', keybind, function()
            action(prompt_bufnr)
          end)
        end
        return true
      end,
      sorter = config.generic_sorter(telescope_opts),
    })
    :find()
end

M.setup = function()
  require('cheatsheet.telescope').pick_cheat = M.pick_cheat
end

return M
