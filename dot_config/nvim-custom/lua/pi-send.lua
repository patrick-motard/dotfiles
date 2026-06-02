-- pi-send: Send messages to pi from neovim
--
-- Keybindings:
--   <leader>cp (normal)  - Open floating input, send message about current buffer
--   <leader>cp (visual)  - Open floating input, send message with visual selection
--
local M = {}

local MESSAGE_DIR = '/tmp/pi-nvim-messages'
local send_seq = 0

--- Open a floating input and send the message to pi
--- @param selection string|nil Selected text (if in visual mode)
--- @param start_line number|nil Start line of selection
--- @param end_line number|nil End line of selection
function M.send(selection, start_line, end_line)
  local file = vim.fn.expand('%:p')
  local buf_name = vim.fn.expand('%:t')

  -- Create floating input
  local width = math.min(80, vim.o.columns - 10)
  local prompt_text = selection
    and string.format(' pi ← %s (lines %d-%d) ', buf_name, start_line, end_line)
    or string.format(' pi ← %s ', buf_name)

  local input_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[input_buf].buftype = 'nofile'
  vim.bo[input_buf].filetype = 'pi-input'

  local win_opts = {
    relative = 'editor',
    width = width,
    height = 1,
    col = math.floor((vim.o.columns - width) / 2),
    row = vim.o.lines - 4,
    style = 'minimal',
    border = 'rounded',
    title = prompt_text,
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(input_buf, true, win_opts)

  -- Start in insert mode
  vim.cmd('startinsert')

  -- Submit on Enter
  vim.keymap.set('i', '<CR>', function()
    local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
    local message = table.concat(lines, '\n')

    -- Close the float
    vim.cmd('stopinsert')
    vim.api.nvim_win_close(win, true)

    if message == '' then
      vim.notify('pi-send: Empty message, not sent', vim.log.levels.WARN)
      return
    end

    -- Write a note into the scoped drop-directory the nvim-buffer extension
    -- drains. Prefix with THIS nvim's pid so only the paired pi instance picks
    -- it up (prevents cross-session theft); atomic temp-then-rename avoids
    -- partial reads.
    local payload = vim.fn.json_encode({
      message = message,
      file = file,
      selection = selection,
      startLine = start_line,
      endLine = end_line,
    })

    pcall(vim.fn.mkdir, MESSAGE_DIR, 'p')
    send_seq = send_seq + 1
    local base = string.format('%d-%d-%05d', vim.fn.getpid(), os.time(), send_seq)
    local tmp = MESSAGE_DIR .. '/.' .. base .. '.json.tmp'
    local final = MESSAGE_DIR .. '/' .. base .. '.json'
    local f = io.open(tmp, 'w')
    if f then
      f:write(payload)
      f:close()
      os.rename(tmp, final)
      vim.notify('pi ← ' .. message, vim.log.levels.INFO)
    else
      vim.notify('pi-send: Failed to write message file', vim.log.levels.ERROR)
    end
  end, { buffer = input_buf, silent = true })

  -- Cancel on Escape
  vim.keymap.set('i', '<Esc>', function()
    vim.cmd('stopinsert')
    vim.api.nvim_win_close(win, true)
  end, { buffer = input_buf, silent = true })

  -- Also cancel on q in normal mode
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = input_buf, silent = true })

  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = input_buf, silent = true })
end

-- Normal mode: send message about buffer (no selection)
vim.keymap.set('n', '<leader>cp', function()
  M.send(nil, nil, nil)
end, { noremap = true, silent = true, desc = '[p]rompt pi' })

-- Visual mode: send message with selection
vim.keymap.set('v', '<leader>cp', function()
  -- Get selection before leaving visual mode
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Exit visual mode to get the marks set
  vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))

  -- Get the selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local selection = table.concat(lines, '\n')

  M.send(selection, start_line, end_line)
end, { noremap = true, silent = true, desc = '[p]rompt pi with selection' })

return M
