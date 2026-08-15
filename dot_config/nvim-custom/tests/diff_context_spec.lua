local context = require 'config.diff_context'

local function check(condition, message)
  if not condition then
    error(message, 0)
  end
end

check(not context.has_pending(nil), 'nil queue should have no pending diffs')
check(not context.has_pending { { status = 'accepted' }, { status = 'rejected' } }, 'completed queue entries should not count as pending')
check(context.has_pending { { status = 'accepted' }, { status = 'pending' } }, 'a pending queue entry should be visible')

check(not context.pi_diff_visible {}, 'empty pi diff state should be hidden')
check(context.pi_diff_visible { active = true }, 'active pi diff should be visible')
check(context.pi_diff_visible { inline_active = true }, 'active inline pi diff should be visible')
check(context.pi_diff_visible { queue = { { status = 'pending' } } }, 'pending pi diff queue should be visible')
check(context.pi_diff_visible { last_accepted = true }, 'pi diff history should be visible')

check(not context.menu_visible {}, 'empty context should hide the Diff menu')
check(context.menu_visible { diff = true }, 'Neovim diff mode should show the Diff menu')
check(context.menu_visible { lsp = true }, 'LSP context should show the Diff menu')
check(context.menu_visible { pi = { active = true } }, 'active pi diff should show the Diff menu')

print 'diff_context_spec: all assertions passed'
