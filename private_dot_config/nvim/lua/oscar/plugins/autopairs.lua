-- nvim-autopairs: auto-close brackets, quotes, etc. + integrate with nvim-cmp
return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true, -- use treesitter to decide when to pair
      ts_config = {
        lua = { "string" }, -- don't add pairs inside lua strings
        javascript = { "template_string" },
      },
    })

    -- make autopairs and cmp play nice: inserting () after confirming a function
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
