return {
	cmd = "Telescope",
	'nvim-telescope/telescope.nvim',
	tag = '0.1.4',
	dependencies = { 'nvim-lua/plenary.nvim' },
	keys = {
		{ "<leader>ff",  ":Telescope find_files<CR>", desc = "find files" },
		{ "<leader>lg",  ":Telescope live_grep<CR>",  desc = "grep file" },
		{ "<leader>fb",  ":Telescope buffers<CR>",  desc = "buffers" },
		{ "<leader>rs", ":Telescope resume<CR>",     desc = "resume" },
		{ "<leader>q",  ":Telescope oldfiles<CR>",   desc = "oldfiles" },
	},
	config = function()
		require('telescope').setup {

			defaults = {
				file_ignore_patterns = { "node_modules" }
			}
		}
	end
}
