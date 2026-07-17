-- nvim-lint: async linting per filetype (complements conform's formatting)
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      go = { "golangcilint" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }

    -- run linters on these events
    local group = vim.api.nvim_create_augroup("oscar-lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function()
        -- only lint modifiable, listed buffers
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })

    -- manual trigger
    vim.keymap.set("n", "<leader>ml", function()
      lint.try_lint()
    end, { desc = "Lint current file" })
  end,
}
