-- mason: installs & manages LSP servers, then auto-enables them.
-- (mason-lspconfig v2 auto-enables installed servers via vim.lsp.enable)
return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        -- config editing
        "lua_ls",

        -- go
        "gopls",

        -- javascript / typescript / web
        "ts_ls",
        "jsonls",

        -- devops
        "yamlls",        -- yaml (k8s, gh actions, compose, ...)
        "dockerls",      -- Dockerfile
        "docker_compose_language_service",
        "bashls",        -- bash / shell scripts
        "tofu_ls",       -- OpenTofu (NOT terraform-ls)
        "helm_ls",       -- Helm charts
      },
    })
  end,
}
