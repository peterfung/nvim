return {
    "nvim-tree/nvim-tree.lua",
	keys = {
		{ "tt", ":NvimTreeToggle<CR>", desc = "toggle nerdtree" },
	},
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.g.termguicolors = true

        require("nvim-tree").setup({
            sort_by = "case_sensitive",
        })
    end,
}
