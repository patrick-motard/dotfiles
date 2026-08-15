local M = {}

function M.has_pending(queue)
  for _, item in ipairs(queue or {}) do
    if item.status == 'pending' then
      return true
    end
  end
  return false
end

function M.pi_diff_visible(state)
  return state.active == true or state.inline_active == true or M.has_pending(state.queue) or state.last_accepted == true
end

function M.menu_visible(state)
  return state.diff == true or state.lsp == true or M.pi_diff_visible(state.pi or {})
end

return M
