return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Custom component to show current project
    local function project_name()
      local cwd = vim.fn.getcwd()
      return vim.fn.fnamemodify(cwd, ':t')
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
          {
            'filename',
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path, 3 = absolute with ~ for home
            shorting_target = 40, -- Shorten path to leave 40 spaces for other components
          },
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
