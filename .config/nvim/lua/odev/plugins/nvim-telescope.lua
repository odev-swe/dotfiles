return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-project.nvim",
	},
	config = function()
		-- keymap
		local keymap = vim.keymap -- common key bind

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
		keymap.set("n", "<leader>fc", function()
			vim.builtin.grep_string({ search = vim.fn.input("Grep >") })
		end) -- find string under cursor in current working directory
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

		require("telescope").setup({
			project_actions = require("telescope._extensions.project.actions"),
			extensions = {
				project = {
					base_dirs = {
						{ path = "~/Documents/github", max_depth = 99 },
					},
					hidden_files = true, -- default: false
					theme = "dropdown",
					order_by = "asc",
					search_by = "title",
				},
			},
		})
	end,
}
