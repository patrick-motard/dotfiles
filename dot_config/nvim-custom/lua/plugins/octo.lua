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
}
