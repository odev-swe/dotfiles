-- Catppuccin colorscheme — matches WezTerm's "Catppuccin Mocha"
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,    -- load during startup
  priority = 1000, -- load before other plugins so the colorscheme applies first
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        nvimtree = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
