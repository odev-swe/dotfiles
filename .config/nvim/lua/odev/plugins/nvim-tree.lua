return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- config
		-- import nvim-tree plugin safely
		local setup, nvimtree = pcall(require, "nvim-tree")
		if not setup then
			print("nvim tree not working")
			return
		end

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- change color for arrows in tree to light blue
		vim.cmd([[ highlight NvimTreeIndentMarker guifg=#d79921]])

		-- configure nvim-tree
		nvimtree.setup({
			diagnostics = {
				enable = true,
			},
			-- change folder arrow icons
			renderer = {
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			-- 	git = {
			-- 		ignore = false,
			-- 	},
		})

		-- keymap
		-- nvim tree
		local keymap = vim.keymap -- common key bind

		keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
	end,
}

