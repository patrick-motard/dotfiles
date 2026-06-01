return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation between hunks
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Next hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Previous hunk' })

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = '[s]tage hunk' })
      map('v', '<leader>gr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = '[r]eset hunk' })
      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
      map('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end, { desc = '[b]lame line' })
      map('n', '<leader>gl', gitsigns.toggle_current_line_blame, { desc = '[l]ine blame toggle' })
    end,
  },
}
