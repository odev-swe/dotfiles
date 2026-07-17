-- In-buffer markdown renderer. Treesitter-based, no browser/node.
-- Lazy-loaded on markdown filetype so it never touches other buffers.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown" },
  opts = {
    -- Start rendered; toggle off for raw editing.
    enabled = true,
  },
  keys = {
    { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: toggle render" },
  },
}
