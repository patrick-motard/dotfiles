-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main', -- Use main branch for nvim-treesitter 1.0+ compatibility
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'
    local swap = require 'nvim-treesitter-textobjects.swap'
    local repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

    -- Select keymaps
    local select_keymaps = {
      ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
      ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
      ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
      ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },
      ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
      ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },
      ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
      ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
      ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
      ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
      ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
      ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },
      ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
      ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },
      ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
      ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
    }

    for key, opts in pairs(select_keymaps) do
      vim.keymap.set({ 'x', 'o' }, key, function()
        select.select_textobject(opts.query, 'textobjects')
      end, { desc = opts.desc })
    end

    -- Move keymaps
    local goto_next_start = {
      [']f'] = { query = '@call.outer', desc = 'Next function call start' },
      [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
      [']c'] = { query = '@class.outer', desc = 'Next class start' },
      [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
      [']l'] = { query = '@loop.outer', desc = 'Next loop start' },
      [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
      [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
    }
    local goto_next_end = {
      [']F'] = { query = '@call.outer', desc = 'Next function call end' },
      [']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
      [']C'] = { query = '@class.outer', desc = 'Next class end' },
      [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
      [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
    }
    local goto_previous_start = {
      ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
      ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
      ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
      ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
      ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
    }
    local goto_previous_end = {
      ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
      ['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
      ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
      ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
      ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
    }

    for key, opts in pairs(goto_next_start) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        move.goto_next_start(opts.query, opts.query_group or 'textobjects')
      end, { desc = opts.desc })
    end
    for key, opts in pairs(goto_next_end) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        move.goto_next_end(opts.query, opts.query_group or 'textobjects')
      end, { desc = opts.desc })
    end
    for key, opts in pairs(goto_previous_start) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        move.goto_previous_start(opts.query, opts.query_group or 'textobjects')
      end, { desc = opts.desc })
    end
    for key, opts in pairs(goto_previous_end) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        move.goto_previous_end(opts.query, opts.query_group or 'textobjects')
      end, { desc = opts.desc })
    end

    -- Swap keymaps
    vim.keymap.set('n', '<leader>na', function()
      swap.swap_next '@parameter.inner'
    end, { desc = 'Swap parameter with next' })
    vim.keymap.set('n', '<leader>nm', function()
      swap.swap_next '@function.outer'
    end, { desc = 'Swap function with next' })
    vim.keymap.set('n', '<leader>pa', function()
      swap.swap_previous '@parameter.inner'
    end, { desc = 'Swap parameter with previous' })
    vim.keymap.set('n', '<leader>pm', function()
      swap.swap_previous '@function.outer'
    end, { desc = 'Swap function with previous' })

    -- Repeatable move with ; and ,
    vim.keymap.set({ 'n', 'x', 'o' }, ';', repeat_move.repeat_last_move)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', repeat_move.repeat_last_move_opposite)

    -- Make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', repeat_move.builtin_T_expr, { expr = true })
  end,
}
