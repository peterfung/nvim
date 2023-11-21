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

-- Config gitsigns
local gitsigns = {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
    -- keymap for previewing hunks
    vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<cr>', { desc = '[G]itsigns preview [H]unks' })
    vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<cr>', { desc = '[G]itsigns [P]revious hunk' })
    vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<cr>', { desc = '[G]itsigns [N]ext hunk' })
  end
}


-- Config toggleterm
local toggleterm = {
  'akinsho/toggleterm.nvim',
  version = '*', -- Terminal
  cmd = { 'ToggleTerm' },
  config = function()
    require('toggleterm').setup({
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end
    })
    -- set keymaps to easily move between buffers and terminal
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n><Cmd>ToggleTerm<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
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

-- Config luasnip
local lua_snip = {
  'L3MON4D3/LuaSnip',
  event = "InsertEnter",
  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}

-- Config nvim-cmp
local cmp = {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' }
      },
    }
  end
}

-- Config LSP
local lspconfig = {
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true, cmd = "Mason" },
    'williamboman/mason-lspconfig.nvim',
    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', config = true },
    -- Additional lua configuration, makes nvim stuff amazing
    { 'folke/neodev.nvim', config = true },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- LSP settings.
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
      vim.keymap.set('n', '<Leader>f', ":Format<cr>")
    end

    -- Enable the following language servers
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- pylsp = {
      --   configurationSources = { "flake8" },
      --   plugins = {
      --     jedi_completion = {
      --       include_params = true -- this line enables snippets
      --     },
      --   },
      -- },
      sumneko_lua = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }
    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        }
      end,
    }
  end
}

-- Config autopairs
local autopairs = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup {}
    -- config autopairs
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local nvim_cmp = require('cmp')
    nvim_cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end
}

-- Config illuminate
local illuminate = {
  'RRethy/vim-illuminate',
  event = "BufReadPost",
  config = function()
    require("illuminate").configure({
      delay = 200,
      filetypes_denylist = {
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
      },
    })
  end,
  keys = {
    {
      "]r",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "illuminate Next Reference",
    },
    {
      "[r",
      function()
        require("illuminate").goto_prev_reference(false)
      end,
      desc = "illuminate Prev Reference",
    },
  },
}

-- Config telescope
local telescope = {
  'nvim-telescope/telescope.nvim',
  version = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    -- Keymap for toggling telescope
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sb', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[S]earch [B]uffer' })
    vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files,
      { desc = 'Ctrl-P: Search file in current directory' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  end
}

-- Config Lazy
require('lazy').setup({

  -- UI related
  lualine,
  gitsigns,
  toggleterm,
  nvimtree,

  -- Coding
  lua_snip,
  cmp,
  lspconfig,
  autopairs,
  illuminate,
  { 'numToStr/Comment.nvim', config = true }, -- "gc" to comment visual regions/lines}
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  telescope,
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

})

