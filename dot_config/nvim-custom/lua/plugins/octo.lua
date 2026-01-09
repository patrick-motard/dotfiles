return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>oi', '<cmd>Octo issue list<cr>', desc = 'List issues' },
    { '<leader>oI', '<cmd>Octo issue create<cr>', desc = 'Create issue' },
    { '<leader>op', '<cmd>Octo pr list<cr>', desc = 'List PRs' },
    { '<leader>oP', '<cmd>Octo pr create<cr>', desc = 'Create PR' },
    { '<leader>or', '<cmd>Octo repo list<cr>', desc = 'List repos' },
    { '<leader>os', '<cmd>Octo search<cr>', desc = 'Search' },
    { '<leader>oo', '<cmd>Telescope octo<cr>', desc = 'Octo picker' },
  },
  opts = {
    enable_builtin = true,
    default_to_projects_v2 = true,
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
}
