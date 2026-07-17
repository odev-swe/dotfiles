-- LSP keymaps, diagnostics UI, and per-server settings.
-- Uses the native vim.lsp.config API (Neovim 0.11+); nvim-lspconfig ships the
-- default server configs that these overrides merge into.
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "b0o/schemastore.nvim",   -- JSON/YAML schema catalog (k8s, gh actions, compose, ...)
    "hrsh7th/cmp-nvim-lsp",   -- advertises nvim-cmp's completion capabilities to servers
  },
  config = function()
    -- Broadcast nvim-cmp's extra completion capabilities to every server.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- ponytail: kill LSP file-watching over the workspace. ts_ls otherwise
    -- registers watchers across all of node_modules (60k+ files here), and
    -- every touch fires a scan under real-time AV -> laptop heat. Servers
    -- still read files on demand; only the change-notification firehose stops.
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }
    vim.lsp.config("*", { capabilities = capabilities })

    -- Keymaps: set only when a language server attaches to the buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("oscar-lsp-attach", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap

        -- inlay hints: turn on for this buffer if the server supports them
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        opts.desc = "Toggle inlay hints"
        keymap.set("n", "<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
        end, opts)

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Go to definition"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Go to implementation"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Go to type definition"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "Show hover documentation"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Previous diagnostic"
        keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

        opts.desc = "Next diagnostic"
        keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
      end,
    })

    -- Diagnostic UI: gutter signs + inline text
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = true },
      virtual_text = { prefix = "●" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
      },
    })

    -- ── Per-server overrides ──────────────────────────────────────────────
    -- Set via vim.lsp.config so mason-lspconfig's auto-enable picks them up.

    -- YAML: disable the built-in schema store, use SchemaStore.nvim instead.
    -- keyOrdering=false stops the annoying "keys out of order" warnings.
    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" },
          schemas = require("schemastore").yaml.schemas(),
          keyOrdering = false,
        },
      },
    })

    -- JSON: schemas (package.json, tsconfig, gh actions, ...) + validation
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Lua: teach it about the `vim` global so it stops warning in this config
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          hint = { enable = true }, -- inlay hints
        },
      },
    })

    -- Go: enable the full set of inlay hints (off by default)
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    -- TypeScript/JavaScript: enable inlay hints (off by default)
    local ts_inlay = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    }
    vim.lsp.config("ts_ls", {
      settings = {
        typescript = { inlayHints = ts_inlay },
        javascript = { inlayHints = ts_inlay },
      },
    })
  end,
}
