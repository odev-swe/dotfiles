-- which-key: popup that shows available keybindings after the leader key
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({})

    -- label the leader-key groups so the popup is organized
    wk.add({
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>h", group = "Git hunks" },
      { "<leader>s", group = "Splits" },
      { "<leader>m", group = "Format" },
      { "<leader>l", group = "LazyGit" },
      { "<leader>t", group = "Toggle" },
      { "<leader>r", group = "Rename/Reload/Restart" },
    })
  end,
}
