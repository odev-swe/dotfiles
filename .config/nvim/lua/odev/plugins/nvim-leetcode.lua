return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- configuration goes here
		lang = "python3",
		injector = {
			["python3"] = {
				before = "from typing import List",
			},
		},
		storage = {
			home = "~/Documents/github/road2maang/leetcode",
			cache = vim.fn.stdpath("cache") .. "/leetcode",
		},
	},
}
