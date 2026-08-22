return {
  'numToStr/Comment.nvim',
  opts = {
    pre_hook = function()
      if vim.bo.filetype == 'ruby' then
        return '# %s'
      end
    end,
  },
}
