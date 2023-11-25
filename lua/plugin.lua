-- lazy init install
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

--require("lazy").setup(plugins)

-- [[ Plugin Settings ]]

-- Config lualine
local lualine = {
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


-- Config nvim-tree
local nvimtree = {
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  config = function()
    require('nvim-tree').setup({
      actions = {
        change_dir = {
          enable = true,
          global = true
        }
      },
      renderer = {
        indent_markers = {
          enable = true
        }
      }
    })
  end
}


-- Config Lazy
require('lazy').setup({

  -- UI related
  lualine,
  nvimtree,

  -- Coding

})

