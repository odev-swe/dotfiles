return {
	"voldikss/vim-floaterm",
	config = function()
		-- float term
		local keymap = vim.keymap
		keymap.set("n", "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 <Cr>")
		keymap.set("n", "t", ":FloatermToggle myfloat<CR>")
		keymap.set("t", "<Esc>", "<C-\\><C-n>:q<CR>")
	end,
}

