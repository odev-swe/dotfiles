local M = {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	enabled = true,
	lazy = vim.fn.argc() ~= 0,
}

M.config = function()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	dashboard.section.header.val = {
		[[ ██████╗ ██████╗ ███████╗ ██╗    ██╗ ]],
		[[ ██╔═══██╗██╔══██╗██╔════╝██║    ██║   ]],
		[[ ██║   ██║██║  ██║█████╗  ██║   ██║ ]],
		[[ ██║   ██║██║  ██║██╔══╝  ╚██╗ ██╔╝]],
		[[ ╚██████╔╝██████╔╝███████╗ ╚████╔╝ ]],
		[[   ╚═════╝ ╚═════╝ ╚══════╝  ╚═══╝  ]],
	}

	dashboard.section.buttons.val = {
		dashboard.button("f", "󰱽 " .. " Find file", "<cmd>Telescope find_files <CR>"),
		dashboard.button("n", " " .. " New file", "<cmd>ene <BAR> startinsert <CR>"),
		dashboard.button("p", " " .. " Projects", "<cmd>lua require('telescope').extensions.project.project()<CR>"),
		dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles <CR>"),
		dashboard.button("t", "󰺯 " .. " Find text", "<cmd>Telescope live_grep <CR>"),
		dashboard.button("l", "l " .. " LeetCode", "<cmd>Leet<CR>"),
		dashboard.button("c", " " .. " Config", "<cmd>e $MYVIMRC | Neotree ~/.config/nvim left<CR>"),
		dashboard.button("q", " " .. " Quit", "<cmd>qa<CR>"),
	}

	dashboard.section.footer.opts.hl = "Type"
	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Keyword"

	dashboard.opts.opts.noautocmd = true
	alpha.setup(dashboard.opts)
end

return M
