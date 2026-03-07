return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Custom component to show current project
    local function project_name()
      local project_nvim = require 'project_nvim.project'
      local project_root = project_nvim.get_project_root()
      if project_root then
        return vim.fn.fnamemodify(project_root, ':t')
      end
      return ''
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            project_name,
            icon = '󰉋',
            color = { fg = '#8be9fd', gui = 'bold' },
          },
          'filename',
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filetype' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'oil', 'mason' },
    }
  end,
}
