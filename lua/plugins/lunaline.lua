return {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  dependencies = { 'catppuccin/nvim' },
  event = "VeryLazy",
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'gruvbox_dark',
        component_separators = '|',
        section_separators = '',
      },
    }
  end
}
