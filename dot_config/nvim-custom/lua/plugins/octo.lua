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
    -- Work around an octo.nvim bug (present through at least commit 8476766):
    -- the `update_pull_request_state` mutation used by `Octo pr close`/reopen
    -- concatenates the ReviewThreadInformation and ReviewThreadComment fragment
    -- *definitions* but never spreads them, so GitHub rejects the whole mutation
    -- with "Fragment X was defined, but not used" and the PR never closes. Strip
    -- those dead definitions from just that mutation. This is a harmless no-op
    -- if upstream later fixes it (the substrings simply stop matching).
    do
      local ok_m, mutations = pcall(require, 'octo.gh.mutations')
      local ok_f, frags = pcall(require, 'octo.gh.fragments')
      if ok_m and ok_f and type(mutations.update_pull_request_state) == 'string' then
        mutations.update_pull_request_state = mutations.update_pull_request_state
          :gsub(vim.pesc(frags.review_thread_information), '')
          :gsub(vim.pesc(frags.review_thread_comment), '')
      end
    end
    -- Octo sets buffer-local <localleader> (,) prefixed keymaps, but a global
    -- bare `,` map from nvim-treesitter-textobjects (repeat-move) shadows
    -- which-key's popup trigger. Override `,` buffer-locally in octo buffers so
    -- which-key shows the action menu instead of running repeat-move.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'octo',
      callback = function(event)
        vim.keymap.set('n', ',', function()
          require('which-key').show { keys = ',', loop = true }
        end, { buffer = event.buf, desc = 'which-key octo actions' })
        require('which-key').add {
          { ',a', group = 'Assignee', buffer = event.buf },
          { ',c', group = 'Comment', buffer = event.buf },
          { ',g', group = 'Goto', buffer = event.buf },
          { ',i', group = 'Issue', buffer = event.buf },
          { ',l', group = 'Label', buffer = event.buf },
          { ',p', group = 'PR Actions', buffer = event.buf },
          { ',r', group = 'Review/Reaction', buffer = event.buf },
          { ',s', group = 'Suggestion', buffer = event.buf },
          { ',v', group = 'Review Submit', buffer = event.buf },
        }
      end,
    })
  end,
}
