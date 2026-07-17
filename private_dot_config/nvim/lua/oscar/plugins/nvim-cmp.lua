-- nvim-cmp: autocompletion popup, wired to LSP + snippets + buffer/path sources
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",   -- text from the current buffer
    "hrsh7th/cmp-path",     -- filesystem paths
    "hrsh7th/cmp-nvim-lsp", -- LSP completion source
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",       -- snippet completion source
        "rafamadriz/friendly-snippets",   -- a pile of ready-made snippets
      },
    },
    "onsails/lspkind.nvim", -- pictograms (icons) in the completion menu
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = { completeopt = "menu,menuone,preview,noselect" },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),     -- trigger completion
        ["<C-e>"] = cmp.mapping.abort(),            -- close menu
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- accept selected
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
