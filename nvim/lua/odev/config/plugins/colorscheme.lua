return {
    {
      "sainnhe/gruvbox-material",
      lazy = false, -- Ensure the theme loads immediately
      priority = 1000, -- Load this theme first
      config = function()
        -- Set Gruvbox Material theme as the colorscheme
        vim.g.gruvbox_material_background = "medium" -- Options: 'soft', 'medium', 'hard'
        vim.g.gruvbox_material_palette = "material"  -- Options: 'material', 'mix', 'original'
        vim.g.gruvbox_material_enable_italic = 1     -- Enable italic text
        vim.g.gruvbox_material_diagnostic_virtual_text = "colored" -- Colored virtual text for diagnostics
        vim.g.gruvbox_material_sign_column_background = "none" -- Transparent sign column
  
        -- Apply the colorscheme
        vim.cmd([[colorscheme gruvbox-material]])
      end,
    },
  }
  