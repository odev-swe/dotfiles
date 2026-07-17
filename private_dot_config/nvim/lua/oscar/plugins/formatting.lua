-- conform.nvim: format-on-save with per-filetype formatters
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        go = { "goimports", "gofmt" }, -- organize imports, then gofmt
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        terraform = { "tofu_fmt" }, -- OpenTofu's formatter
        tf = { "tofu_fmt" },
      },
      format_on_save = {
        lsp_fallback = true, -- fall back to LSP formatting if no formatter set
        timeout_ms = 2000,
      },
    })

    -- manual format (normal + visual)
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({ lsp_fallback = true, async = false, timeout_ms = 2000 })
    end, { desc = "Format file or range" })
  end,
}
