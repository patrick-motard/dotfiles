-- pi-diff: Accept proposed edits from pi
--
-- Modes:
--   show(file, proposed_file)        - Vertical split diff
--   show_inline(file, proposed_file)  - Apply inline, show old lines as virtual text
--
-- Multi-file:
--   queue(file, proposed_file)        - Add to pending queue
--   show_queued(index)                - Show a specific queued diff
--   show_next() / show_prev()         - Navigate queue
--   accept_all() / reject_all()       - Bulk operations
--
-- Keybindings:
--   <leader>dy  - Accept the current diff
--   <leader>dn  - Reject the current diff
--   <leader>dj  - Next diff in queue
--   <leader>dk  - Previous diff in queue
--   <leader>da  - Accept all pending diffs
--   <leader>dA  - Reject all pending diffs
--   <leader>df  - Telescope picker of pending diffs
--   <leader>dp  - Re-show last accepted diff
--
local M = {}

-- Track active diff state
M._active = nil
-- Track last accepted diff for re-viewing
M._last_accepted = nil
-- Multi-file queue
M._queue = {}
M._queue_index = 0

-- Forward declarations: these are defined further down but referenced earlier
-- (in M.accept and the reject keymap). Declaring them as locals up here keeps
-- those references in scope; without this they resolve to nil globals.
local mark_queue_accepted, mark_queue_rejected

-- Drop-directory drained by the nvim-buffer pi extension every 500ms. Each note
-- is written to a unique temp file and atomically renamed into place, so
-- concurrent writes (accept_all, or rapid sequential accepts in a queue) never
-- clobber one another the way the legacy single-slot /tmp/pi-nvim-message.json
-- did. The extension turns each note into a user message back to pi.
local MESSAGE_DIR = '/tmp/pi-nvim-messages'
local notify_seq = 0

--- Drop a note for pi.
--- @param message string Human-readable note (becomes a message to pi)
--- @param file string|nil Associated file path (shown as context)
local function notify_pi(message, file)
  pcall(vim.fn.mkdir, MESSAGE_DIR, 'p')
  notify_seq = notify_seq + 1
  -- Prefix with THIS nvim's pid so the paired pi instance (which knows its
  -- sibling nvim socket /tmp/nvim-<pid>.sock) only drains its own notes. This
  -- scopes notifications per session and prevents other pi instances sharing
  -- the directory from stealing them. time+seq keep per-instance ordering.
  local base = string.format('%d-%d-%05d', vim.fn.getpid(), os.time(), notify_seq)
  local tmp = MESSAGE_DIR .. '/.' .. base .. '.json.tmp'
  local final = MESSAGE_DIR .. '/' .. base .. '.json'
  local payload = vim.fn.json_encode({ message = message, file = file })
  local f = io.open(tmp, 'w')
  if f then
    f:write(payload)
    f:close()
    os.rename(tmp, final)  -- atomic on the same filesystem
  end
end

--- Show a vertical split diff between the current file and a proposed version.
--- @param target_file string Absolute path to the file being edited
--- @param proposed_file string Path to temp file containing proposed content
function M.show(target_file, proposed_file, silent)
  -- Close any existing diff session
  if M._active then
    M.close(false, true)
  end

  -- Open the target file if not already the current buffer
  local current_file = vim.fn.expand('%:p')
  if current_file ~= target_file then
    vim.cmd('edit ' .. vim.fn.fnameescape(target_file))
  end

  -- Ensure we're in a single window before splitting
  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.cmd('only')
  end  -- Remember the original buffer
  local original_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()

  -- Enable diff on the original
  vim.cmd('diffthis')

  -- Open vertical split with proposed content
  vim.cmd('vsplit ' .. vim.fn.fnameescape(proposed_file))
  local proposed_buf = vim.api.nvim_get_current_buf()
  local proposed_win = vim.api.nvim_get_current_win()

  -- Configure the proposed buffer
  vim.bo[proposed_buf].buftype = 'nofile'
  vim.bo[proposed_buf].bufhidden = 'wipe'
  vim.bo[proposed_buf].swapfile = false
  vim.bo[proposed_buf].modifiable = false
  vim.bo[proposed_buf].filetype = 'diff'  -- Prevent obsidian.nvim from attaching

  -- Set a descriptive name (unique per file)
  pcall(vim.api.nvim_buf_set_name, proposed_buf, '[pi-proposed] ' .. vim.fn.fnamemodify(target_file, ':t') .. ' (' .. proposed_buf .. ')')

  -- Enable diff on proposed
  vim.cmd('diffthis')

  -- Enable line wrapping in both diff windows. Diff mode turns 'wrap' off by
  -- default (Neovim's 'diffopt' lacks 'followwrap'), so set it explicitly here
  -- so long lines are visible without horizontal scrolling. 'linebreak' wraps
  -- at word boundaries rather than mid-token.
  for _, win in ipairs({ original_win, proposed_win }) do
    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
  end

  -- Store state
  M._active = {
    original_buf = original_buf,
    original_win = original_win,
    proposed_buf = proposed_buf,
    proposed_win = proposed_win,
    proposed_file = proposed_file,
    target_file = target_file,
  }

  -- Set up keybindings in both windows
  local opts = { noremap = true, silent = true, buffer = true }

  -- Keybindings for the proposed buffer (where cursor lands)
  vim.keymap.set('n', '<leader>dy', function() M.accept() end,
    vim.tbl_extend('force', opts, { desc = '[d]iff accept ([y]es)' }))
  vim.keymap.set('n', '<leader>dn', function() M.close(false); mark_queue_rejected() end,
    vim.tbl_extend('force', opts, { desc = '[d]iff reject ([n]o)' }))

  -- Also set keybindings on the original buffer
  vim.api.nvim_set_current_win(original_win)
  vim.keymap.set('n', '<leader>dy', function() M.accept() end,
    vim.tbl_extend('force', opts, { desc = '[d]iff accept ([y]es)' }))
  vim.keymap.set('n', '<leader>dn', function() M.close(false); mark_queue_rejected() end,
    vim.tbl_extend('force', opts, { desc = '[d]iff reject ([n]o)' }))

  -- Move cursor back to proposed window for review
  vim.api.nvim_set_current_win(proposed_win)

  -- Notify (unless called from queue navigation which shows its own message)
  if not silent then
    vim.notify('pi diff: <leader>dy to accept, <leader>dn to reject', vim.log.levels.INFO)
  end

  return 'ok'
end

--- Accept the proposed changes: copy content to original buffer and close diff
function M.accept()
  if not M._active then
    vim.notify('pi-diff: No active diff session', vim.log.levels.WARN)
    return
  end

  local state = M._active

  -- Save original content before overwriting (for re-viewing later)
  local original_lines = vim.api.nvim_buf_get_lines(state.original_buf, 0, -1, false)

  -- Read proposed content
  local proposed_lines = vim.api.nvim_buf_get_lines(state.proposed_buf, 0, -1, false)

  -- Store for re-viewing
  M._last_accepted = {
    target_file = state.target_file,
    original_lines = original_lines,
    proposed_lines = proposed_lines,
  }

  -- Apply to original buffer
  vim.api.nvim_buf_set_lines(state.original_buf, 0, -1, false, proposed_lines)

  -- Persist to disk. Accept previously only updated the buffer, leaving the
  -- change unsaved (and pi unaware it had even happened).
  if vim.bo[state.original_buf].buftype == '' and vim.api.nvim_buf_get_name(state.original_buf) ~= '' then
    vim.api.nvim_buf_call(state.original_buf, function()
      pcall(vim.cmd, 'silent keepalt write')
    end)
  end

  -- Close the diff
  M.close(true)

  -- Advance queue if we're in multi-file mode
  mark_queue_accepted()

  -- Notify pi (drained by the nvim-buffer extension)
  notify_pi('Accepted and saved your proposed edit to ' .. state.target_file, state.target_file)

  vim.notify('pi diff: Changes accepted & saved. <leader>dp to review.', vim.log.levels.INFO)
end

--- Close the diff session
--- @param accepted boolean Whether changes were accepted
--- @param silent? boolean Suppress notifications (for navigation)
function M.close(accepted, silent)
  if not M._active then return end

  local state = M._active
  M._active = nil

  -- Close proposed window if it still exists
  if vim.api.nvim_win_is_valid(state.proposed_win) then
    vim.api.nvim_win_close(state.proposed_win, true)
  end

  -- Turn off diff mode on original
  if vim.api.nvim_win_is_valid(state.original_win) then
    vim.api.nvim_set_current_win(state.original_win)
    vim.cmd('diffoff')
  end

  -- Clean up temp file
  vim.fn.delete(state.proposed_file)

  if not accepted and not silent then
    notify_pi('Rejected your proposed edit to ' .. state.target_file, state.target_file)
    vim.notify('pi diff: Changes rejected', vim.log.levels.INFO)
  end
end

--- Queue a diff for later review (multi-file support)
--- @param target_file string Absolute path to the file being edited
--- @param proposed_file string Path to temp file containing proposed content
function M.queue(target_file, proposed_file)
  table.insert(M._queue, {
    target_file = target_file,
    proposed_file = proposed_file,
    status = 'pending',  -- pending, accepted, rejected
  })
  local count = #M._queue
  vim.notify(string.format('pi diff: Queued %s (%d pending)', vim.fn.fnamemodify(target_file, ':t'), count), vim.log.levels.INFO)
  -- If this is the first item, show it
  if count == 1 then
    M.show_queued(1)
  end
end

--- Show a specific queued diff by index
--- @param index number 1-based index into the queue
function M.show_queued(index)
  if index < 1 or index > #M._queue then
    vim.notify('pi-diff: No diff at index ' .. index, vim.log.levels.WARN)
    return
  end

  local item = M._queue[index]
  if item.status ~= 'pending' then
    vim.notify('pi-diff: Diff already ' .. item.status, vim.log.levels.WARN)
    return
  end

  M._queue_index = index

  -- Close any active diff silently (navigating, not rejecting)
  if M._active then
    M.close(false, true)
  end

  -- Show it (this sets M._active) — pass silent flag
  M.show(item.target_file, item.proposed_file, true)

  -- Single combined notification with fixed width
  local title = string.format('pi diff [%d/%d]', index, #M._queue)
  local filename = vim.fn.fnamemodify(item.target_file, ':t')
  local keys = '<leader> dy accept · dn reject · dj next · dk prev'
  -- Pad filename to fixed width so notification doesn't jump
  local width = #keys
  local padded_name = filename .. string.rep(' ', math.max(0, width - #filename))
  vim.notify(padded_name .. '\n' .. keys, vim.log.levels.INFO, { title = title })
end

--- Show next pending diff in queue
function M.show_next()
  if #M._queue == 0 then
    vim.notify('pi-diff: Queue is empty', vim.log.levels.WARN)
    return
  end

  -- Find next pending item after current index
  for i = M._queue_index + 1, #M._queue do
    if M._queue[i].status == 'pending' then
      M.show_queued(i)
      return
    end
  end
  -- Wrap around
  for i = 1, M._queue_index do
    if M._queue[i].status == 'pending' then
      M.show_queued(i)
      return
    end
  end
  vim.notify('pi-diff: No more pending diffs', vim.log.levels.INFO)
end

--- Show previous pending diff in queue
function M.show_prev()
  if #M._queue == 0 then
    vim.notify('pi-diff: Queue is empty', vim.log.levels.WARN)
    return
  end

  -- Find previous pending item before current index
  for i = M._queue_index - 1, 1, -1 do
    if M._queue[i].status == 'pending' then
      M.show_queued(i)
      return
    end
  end
  -- Wrap around
  for i = #M._queue, M._queue_index, -1 do
    if M._queue[i].status == 'pending' then
      M.show_queued(i)
      return
    end
  end
  vim.notify('pi-diff: No more pending diffs', vim.log.levels.INFO)
end

--- Accept all pending diffs in the queue
function M.accept_all()
  if #M._queue == 0 then
    vim.notify('pi-diff: Queue is empty', vim.log.levels.WARN)
    return
  end

  local count = 0
  local accepted_names = {}
  for _, item in ipairs(M._queue) do
    if item.status == 'pending' then
      -- Read proposed content and apply
      local proposed_lines = {}
      if vim.fn.filereadable(item.proposed_file) == 1 then
        for line in io.lines(item.proposed_file) do
          proposed_lines[#proposed_lines + 1] = line
        end
        -- Open the file and apply
        vim.cmd('edit ' .. vim.fn.fnameescape(item.target_file))
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, proposed_lines)
        -- Persist to disk
        if vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
          pcall(vim.cmd, 'silent keepalt write')
        end
        vim.fn.delete(item.proposed_file)
      end
      item.status = 'accepted'
      accepted_names[#accepted_names + 1] = vim.fn.fnamemodify(item.target_file, ':t')
      count = count + 1
    end
  end

  -- Close any active split diff
  if M._active then
    M.close(true)
  end

  M._queue = {}
  M._queue_index = 0
  -- One batched note so none get clobbered in the extension's mailbox
  notify_pi(string.format('Accepted and saved all %d proposed edits: %s', count, table.concat(accepted_names, ', ')))
  vim.notify(string.format('pi diff: Accepted all (%d files)', count), vim.log.levels.INFO)
end

--- Reject all pending diffs in the queue
function M.reject_all()
  if #M._queue == 0 then
    vim.notify('pi-diff: Queue is empty', vim.log.levels.WARN)
    return
  end

  local count = 0
  local rejected_names = {}
  for _, item in ipairs(M._queue) do
    if item.status == 'pending' then
      vim.fn.delete(item.proposed_file)
      item.status = 'rejected'
      rejected_names[#rejected_names + 1] = vim.fn.fnamemodify(item.target_file, ':t')
      count = count + 1
    end
  end

  -- Close any active split diff
  if M._active then
    M.close(false)
  end

  M._queue = {}
  M._queue_index = 0
  -- One batched note so none get clobbered in the extension's mailbox
  notify_pi(string.format('Rejected all %d proposed edits: %s', count, table.concat(rejected_names, ', ')))
  vim.notify(string.format('pi diff: Rejected all (%d files)', count), vim.log.levels.INFO)
end

--- Telescope picker for pending diffs
function M.telescope_pick()
  local has_telescope, pickers = pcall(require, 'telescope.pickers')
  if not has_telescope then
    vim.notify('pi-diff: Telescope not available', vim.log.levels.ERROR)
    return
  end

  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local previewers = require('telescope.previewers')

  local items = {}
  for i, item in ipairs(M._queue) do
    if item.status == 'pending' then
      table.insert(items, {
        display = string.format('[%d] %s', i, vim.fn.fnamemodify(item.target_file, ':~:.')),
        index = i,
        item = item,
      })
    end
  end

  if #items == 0 then
    vim.notify('pi-diff: No pending diffs', vim.log.levels.INFO)
    return
  end

  pickers.new({}, {
    prompt_title = 'Pi Diffs (pending)',
    layout_strategy = 'vertical',
    layout_config = {
      preview_height = 0.6,
    },
    finder = finders.new_table {
      results = items,
      entry_maker = function(entry)
        local item = entry.item
        local lines_added = 0
        local lines_removed = 0
        -- Quick line count diff
        if vim.fn.filereadable(item.target_file) == 1 and vim.fn.filereadable(item.proposed_file) == 1 then
          local orig_count = #vim.fn.readfile(item.target_file)
          local prop_count = #vim.fn.readfile(item.proposed_file)
          if prop_count > orig_count then
            lines_added = prop_count - orig_count
          elseif orig_count > prop_count then
            lines_removed = orig_count - prop_count
          end
        end

        local stat_parts = {}
        if lines_added > 0 then table.insert(stat_parts, '+' .. lines_added) end
        if lines_removed > 0 then table.insert(stat_parts, '-' .. lines_removed) end
        local stats = #stat_parts > 0 and ' (' .. table.concat(stat_parts, ', ') .. ')' or ''

        local display_str = string.format('[%d] %s%s',
          entry.index,
          vim.fn.fnamemodify(item.target_file, ':~:.'),
          stats
        )

        return {
          value = entry,
          display = display_str,
          ordinal = display_str,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = 'Diff Preview',
      define_preview = function(self, entry)
        local item = entry.value.item
        -- Read original file content
        local original_lines = {}
        if vim.fn.filereadable(item.target_file) == 1 then
          for line in io.lines(item.target_file) do
            original_lines[#original_lines + 1] = line
          end
        end
        -- Read proposed content
        local proposed_lines = {}
        if vim.fn.filereadable(item.proposed_file) == 1 then
          for line in io.lines(item.proposed_file) do
            proposed_lines[#proposed_lines + 1] = line
          end
        end
        -- Generate unified diff
        local original_text = table.concat(original_lines, '\n') .. '\n'
        local proposed_text = table.concat(proposed_lines, '\n') .. '\n'
        local diff_text = vim.diff(original_text, proposed_text, {
          result_type = 'unified',
          ctxlen = 3,
        })
        local diff_lines = vim.split(diff_text or '', '\n')
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, diff_lines)
        vim.bo[self.state.bufnr].filetype = 'diff'
      end,
    }),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          M.show_queued(selection.value.index)
        end
      end)
      return true
    end,
  }):find()
end

--- Mark current queued item as accepted (called from the accept flow)
function mark_queue_accepted()
  if M._queue_index > 0 and M._queue_index <= #M._queue then
    M._queue[M._queue_index].status = 'accepted'
    -- Auto-advance to next pending
    vim.defer_fn(function()
      local has_pending = false
      for _, item in ipairs(M._queue) do
        if item.status == 'pending' then has_pending = true; break end
      end
      if has_pending then
        M.show_next()
      else
        M._queue = {}
        M._queue_index = 0
      end
    end, 100)
  end
end

--- Mark current queued item as rejected (called from the reject flow)
function mark_queue_rejected()
  if M._queue_index > 0 and M._queue_index <= #M._queue then
    M._queue[M._queue_index].status = 'rejected'
    -- Auto-advance to next pending
    vim.defer_fn(function()
      local has_pending = false
      for _, item in ipairs(M._queue) do
        if item.status == 'pending' then has_pending = true; break end
      end
      if has_pending then
        M.show_next()
      else
        M._queue = {}
        M._queue_index = 0
      end
    end, 100)
  end
end

--- Re-show the last accepted diff for review
function M.show_previous()
  if not M._last_accepted then
    vim.notify('pi-diff: No previous diff to show', vim.log.levels.WARN)
    return
  end

  local last = M._last_accepted

  -- Open the target file
  local current_file = vim.fn.expand('%:p')
  if current_file ~= last.target_file then
    vim.cmd('edit ' .. vim.fn.fnameescape(last.target_file))
  end

  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Enable diff on current (which has the accepted/new content)
  vim.cmd('diffthis')

  -- Create a scratch buffer with the original (pre-accept) content
  vim.cmd('vsplit')
  local prev_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(prev_buf)
  vim.api.nvim_buf_set_lines(prev_buf, 0, -1, false, last.original_lines)
  vim.bo[prev_buf].buftype = 'nofile'
  vim.bo[prev_buf].bufhidden = 'wipe'
  vim.bo[prev_buf].swapfile = false
  vim.bo[prev_buf].modifiable = false
  vim.bo[prev_buf].filetype = 'diff'  -- Prevent obsidian.nvim from attaching
  vim.api.nvim_buf_set_name(prev_buf, '[pi-previous] ' .. vim.fn.fnamemodify(last.target_file, ':t'))

  -- Enable diff on the previous version
  vim.cmd('diffthis')

  local prev_win = vim.api.nvim_get_current_win()

  -- Keymap to close the review split
  local opts = { noremap = true, silent = true, buffer = prev_buf }
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(prev_win, true)
    vim.api.nvim_set_current_win(current_win)
    vim.cmd('diffoff')
  end, vim.tbl_extend('force', opts, { desc = 'Close diff review' }))

  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(prev_win, true)
    vim.api.nvim_set_current_win(current_win)
    vim.cmd('diffoff')
  end, vim.tbl_extend('force', opts, { desc = 'Close diff review' }))

  vim.notify('pi diff: Showing previous state (q or Esc to close)', vim.log.levels.INFO)
end

-- Set up global keymaps
vim.keymap.set('n', '<leader>dp', function() M.show_previous() end,
  { noremap = true, silent = true, desc = '[d]iff show [p]revious' })
vim.keymap.set('n', '<leader>dj', function() M.show_next() end,
  { noremap = true, silent = true, desc = '[d]iff next file' })
vim.keymap.set('n', '<leader>dk', function() M.show_prev() end,
  { noremap = true, silent = true, desc = '[d]iff prev file' })
vim.keymap.set('n', '<leader>da', function() M.accept_all() end,
  { noremap = true, silent = true, desc = '[d]iff accept [a]ll' })
vim.keymap.set('n', '<leader>dA', function() M.reject_all() end,
  { noremap = true, silent = true, desc = '[d]iff reject [A]ll' })
vim.keymap.set('n', '<leader>df', function() M.telescope_pick() end,
  { noremap = true, silent = true, desc = '[d]iff [f]ind (telescope)' })

-- Namespace for inline diff virtual text
local ns_inline = vim.api.nvim_create_namespace('pi_diff_inline')

-- Track inline diff state
M._inline_active = nil

-- Define highlight groups matching inline-diff.nvim style
local function setup_highlights()
  -- Use same colors as inline-diff.nvim if available, otherwise fall back to diff highlights
  local function hl_exists(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    return ok and next(hl) ~= nil
  end

  if not hl_exists('PiDiffAdd') then
    if hl_exists('InlineDiffAdd') then
      vim.api.nvim_set_hl(0, 'PiDiffAdd', { link = 'InlineDiffAdd' })
      vim.api.nvim_set_hl(0, 'PiDiffDelete', { link = 'InlineDiffDelete' })
      vim.api.nvim_set_hl(0, 'PiDiffWordAdd', { link = 'InlineDiffWordAdd' })
      vim.api.nvim_set_hl(0, 'PiDiffWordDel', { link = 'InlineDiffWordDel' })
    else
      vim.api.nvim_set_hl(0, 'PiDiffAdd', { bg = '#3c4841', fg = '#ffffff' })
      vim.api.nvim_set_hl(0, 'PiDiffDelete', { bg = '#493b40', fg = '#ffffff' })
      vim.api.nvim_set_hl(0, 'PiDiffWordAdd', { bg = '#4a6354', fg = '#ffffff' })
      vim.api.nvim_set_hl(0, 'PiDiffWordDel', { bg = '#79485a', fg = '#ffffff', strikethrough = true })
    end
  end
end

--- Show proposed changes inline: apply new content, highlight changes, show deletions as virtual text
--- @param target_file string Absolute path to the file being edited
--- @param proposed_file string Path to temp file containing proposed content
function M.show_inline(target_file, proposed_file)
  -- Close any existing inline diff
  if M._inline_active then
    M.reject_inline()
  end

  setup_highlights()

  -- Open the target file if not already the current buffer
  local current_file = vim.fn.expand('%:p')
  if current_file ~= target_file then
    vim.cmd('edit ' .. vim.fn.fnameescape(target_file))
  end

  local buf = vim.api.nvim_get_current_buf()

  -- Read original content
  local original_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Read proposed content
  local proposed_lines = {}
  for line in io.lines(proposed_file) do
    proposed_lines[#proposed_lines + 1] = line
  end

  -- Compute diff
  local original_text = table.concat(original_lines, '\n') .. '\n'
  local proposed_text = table.concat(proposed_lines, '\n') .. '\n'
  local diff_result = vim.diff(original_text, proposed_text, { result_type = 'indices' })

  -- Apply the proposed content to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, proposed_lines)

  -- Process each hunk: highlight additions/modifications, show deletions as virtual text
  -- diff_result is a list of {orig_start, orig_count, new_start, new_count}
  for _, hunk in ipairs(diff_result) do
    local orig_start, orig_count, new_start, new_count = hunk[1], hunk[2], hunk[3], hunk[4]

    -- Show deleted lines as virtual text above the change location
    if orig_count > 0 then
      local virt_lines = {}
      for i = orig_start, orig_start + orig_count - 1 do
        local del_text = original_lines[i] or ''
        table.insert(virt_lines, { { del_text, 'PiDiffDelete' } })
      end

      -- Place above the new content (or at the deletion point)
      local place_at = math.max(0, new_start - 1)  -- 0-indexed
      vim.api.nvim_buf_set_extmark(buf, ns_inline, place_at, 0, {
        virt_lines = virt_lines,
        virt_lines_above = true,
      })
    end

    -- Highlight added/modified lines in the buffer
    if new_count > 0 then
      for i = new_start, new_start + new_count - 1 do
        local line_idx = i - 1  -- 0-indexed
        if line_idx >= 0 and line_idx < #proposed_lines then
          if orig_count > 0 then
            -- This is a modification (lines were both deleted and added)
            -- Highlight the whole line (lower priority so word diff shows through)
            vim.api.nvim_buf_set_extmark(buf, ns_inline, line_idx, 0, {
              line_hl_group = 'PiDiffAdd',
              priority = 100,
            })
            -- Word-level diff for modified lines
            local orig_line_idx = orig_start + (i - new_start)
            if orig_line_idx <= orig_start + orig_count - 1 then
              local orig_line = original_lines[orig_line_idx] or ''
              local new_line = proposed_lines[i] or ''
              -- Simple word diff: find first and last differing characters
              local first_diff = 1
              local min_len = math.min(#orig_line, #new_line)
              while first_diff <= min_len and orig_line:sub(first_diff, first_diff) == new_line:sub(first_diff, first_diff) do
                first_diff = first_diff + 1
              end
              local last_diff_orig = #orig_line
              local last_diff_new = #new_line
              while last_diff_orig > first_diff and last_diff_new > first_diff
                and orig_line:sub(last_diff_orig, last_diff_orig) == new_line:sub(last_diff_new, last_diff_new) do
                last_diff_orig = last_diff_orig - 1
                last_diff_new = last_diff_new - 1
              end
              -- Highlight the changed word region (higher priority)
              if first_diff <= last_diff_new then
                vim.api.nvim_buf_set_extmark(buf, ns_inline, line_idx, first_diff - 1, {
                  end_col = last_diff_new,
                  hl_group = 'PiDiffWordAdd',
                  priority = 200,
                })
              end
            end
          else
            -- Pure addition
            vim.api.nvim_buf_set_extmark(buf, ns_inline, line_idx, 0, {
              line_hl_group = 'PiDiffAdd',
              priority = 100,
            })
          end
        end
      end
    end
  end

  -- Store state for accept/reject
  M._inline_active = {
    buf = buf,
    original_lines = original_lines,
    proposed_lines = proposed_lines,
    target_file = target_file,
    proposed_file = proposed_file,
    saved_conceallevel = vim.wo.conceallevel,
  }

  -- Disable conceal so diff is fully visible
  -- Use a buffer-local autocmd to keep it at 0 (fights obsidian.nvim's BufEnter reset)
  vim.wo.conceallevel = 0
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    buffer = buf,
    group = vim.api.nvim_create_augroup('pi_diff_conceal', { clear = true }),
    callback = function()
      if M._inline_active and M._inline_active.buf == buf then
        vim.wo.conceallevel = 0
      end
    end,
  })

  -- Set buffer-local keymaps
  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set('n', '<leader>dy', function() M.accept_inline() end,
    vim.tbl_extend('force', opts, { desc = '[d]iff accept ([y]es)' }))
  vim.keymap.set('n', '<leader>dn', function() M.reject_inline() end,
    vim.tbl_extend('force', opts, { desc = '[d]iff reject ([n]o)' }))

  -- Clean up temp file
  vim.fn.delete(proposed_file)

  vim.notify('pi diff (inline): <leader>dy to accept, <leader>dn to reject', vim.log.levels.INFO)
  return 'ok'
end

--- Accept inline changes (just clear virtual text, content already applied)
function M.accept_inline()
  if not M._inline_active then
    vim.notify('pi-diff: No active inline diff', vim.log.levels.WARN)
    return
  end

  local state = M._inline_active
  M._inline_active = nil

  -- Store for re-viewing
  M._last_accepted = {
    target_file = state.target_file,
    original_lines = state.original_lines,
    proposed_lines = state.proposed_lines,
  }

  -- Clear virtual text
  vim.api.nvim_buf_clear_namespace(state.buf, ns_inline, 0, -1)

  -- Restore conceallevel and remove the guard autocmd
  pcall(vim.api.nvim_del_augroup_by_name, 'pi_diff_conceal')
  vim.wo.conceallevel = state.saved_conceallevel or 3

  -- Remove buffer-local keymaps
  pcall(vim.keymap.del, 'n', '<leader>dy', { buffer = state.buf })
  pcall(vim.keymap.del, 'n', '<leader>dn', { buffer = state.buf })

  -- Persist to disk (inline applies content at show time but never saved it)
  if vim.bo[state.buf].buftype == '' and vim.api.nvim_buf_get_name(state.buf) ~= '' then
    vim.api.nvim_buf_call(state.buf, function()
      pcall(vim.cmd, 'silent keepalt write')
    end)
  end

  notify_pi('Accepted and saved your proposed edit to ' .. state.target_file, state.target_file)
  vim.notify('pi diff: Changes accepted & saved. <leader>dp to review.', vim.log.levels.INFO)
end

--- Reject inline changes (restore original content, clear virtual text)
function M.reject_inline()
  if not M._inline_active then
    vim.notify('pi-diff: No active inline diff', vim.log.levels.WARN)
    return
  end

  local state = M._inline_active
  M._inline_active = nil

  -- Restore original content
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, state.original_lines)

  -- Clear virtual text
  vim.api.nvim_buf_clear_namespace(state.buf, ns_inline, 0, -1)

  -- Restore conceallevel and remove the guard autocmd
  pcall(vim.api.nvim_del_augroup_by_name, 'pi_diff_conceal')
  vim.wo.conceallevel = state.saved_conceallevel or 3

  -- Remove buffer-local keymaps
  pcall(vim.keymap.del, 'n', '<leader>dy', { buffer = state.buf })
  pcall(vim.keymap.del, 'n', '<leader>dn', { buffer = state.buf })

  notify_pi('Rejected your proposed edit to ' .. state.target_file, state.target_file)
  vim.notify('pi diff: Changes rejected, original restored.', vim.log.levels.INFO)
end

return M
