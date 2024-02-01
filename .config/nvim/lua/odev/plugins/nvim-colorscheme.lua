return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			vim.cmd([[colorscheme solarized-osaka]])
			return {
				transparent = true,
			}
		end,
	},
}
