local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

require 'pi-diff'

for _, lhs in ipairs { '<leader>dp', '<leader>dj', '<leader>dk', '<leader>da', '<leader>dA', '<leader>df' } do
  local mapping = vim.fn.maparg(lhs, 'n', false, true)
  check(mapping.desc == 'which_key_ignore', lhs .. ' should be hidden from WhichKey outside an active pi diff')
end

print 'pi_diff_keymaps_spec: all assertions passed'
