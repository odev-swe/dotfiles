-- nvim-ts-autotag: auto close & rename HTML/JSX/Svelte tags (treesitter-powered)
return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
