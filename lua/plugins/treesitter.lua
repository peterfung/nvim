return {
	'nvim-treesitter/nvim-treesitter',
	config = function()
		-- 报错 No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable.
		-- window环境，下载 zig 。使用 scoop install zig
		-- https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager
		require('nvim-treesitter.configs').setup({
			-- :TSInstallInfo 命令查看支持的语言
			ensure_installed = { "cpp", "python", "bash", "lua"},
			-- 启用代码高亮功能
			highlight = {
				enable = false
			},
			-- 启用增量选择
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<CR>',
					node_incremental = '<CR>',
					node_decremental = '<BS>',
					scope_incremental = '<TAB>',
				}
			},
			-- 启用基于Treesitter的代码格式化(=) . NOTE: This is an experimental feature.
			indent = {
				enable = true
			}
		})
	end
}
