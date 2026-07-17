return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>oi', '<cmd>Octo issue list<cr>', desc = '[i]ssue list' },
    { '<leader>oI', '<cmd>Octo issue create<cr>', desc = '[I]ssue create' },
    { '<leader>op', '<cmd>Octo pr list<cr>', desc = '[p]r list' },
    { '<leader>om', '<cmd>Octo search is:pr author:@me is:open<cr>', desc = '[m]y PRs' },
    { '<leader>oP', '<cmd>Octo pr create<cr>', desc = '[P]r create' },
    { '<leader>or', '<cmd>Octo repo list<cr>', desc = '[r]epo list' },
    { '<leader>os', '<cmd>Octo search<cr>', desc = '[s]earch' },
  },
  opts = {
    enable_builtin = true,
    default_to_projects_v2 = true,
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
  config = function(_, opts)
    require('octo').setup(opts)
    -- Register which-key groups for octo buffer-local keymaps
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'octo',
      callback = function(event)
        local wk = require('which-key')
        wk.add({
          { ',a', group = '[a] Assignee', buffer = event.buf },
          { ',c', group = '[c] Comment', buffer = event.buf },
          { ',p', group = '[p] PR Actions', buffer = event.buf },
          { ',r', group = '[r] Review/Reaction', buffer = event.buf },
          { ',s', group = '[s] Suggestion', buffer = event.buf },
          { ',l', group = '[l] Label', buffer = event.buf },
          { ',v', group = '[v] Review Submit', buffer = event.buf },
          { ',i', group = '[i] Issue', buffer = event.buf },
          { ',e', group = '[e] Files Panel', buffer = event.buf },
          { ',b', group = '[b] Toggle Panel', buffer = event.buf },
          { ',g', group = '[g] Goto', buffer = event.buf },
          { ',t', group = '[t] Thread', buffer = event.buf },
        })
      end,
    })
  end,
}
