-- lualine: statusline with git branch, diffs, diagnostics, file info
return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto", -- derives colors from the active colorscheme (catppuccin)
        globalstatus = true,  -- one statusline across all splits
      },
      sections = {
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- relative path
      },
    })
  end,
}
