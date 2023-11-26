return {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  dependencies = { 'catppuccin/nvim' },
  event = "VeryLazy",
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
    }
  end
}
