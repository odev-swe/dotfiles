-- toggleterm.nvim: quick toggleable terminal (float by default)
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal (float)" },
    { [[<C-\>]], "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal" },
    -- dedicated float terminals by id, each with a label shown in the border
    { "<leader>t1", "<cmd>1ToggleTerm direction=float name=main<CR>", desc = "Terminal: main" },
    { "<leader>t2", "<cmd>2ToggleTerm direction=float name=build<CR>", desc = "Terminal: build" },
    { "<leader>t3", "<cmd>3ToggleTerm direction=float name=logs<CR>", desc = "Terminal: logs" },
    -- show all open terminals in a picker
    { "<leader>ts", "<cmd>TermSelect<CR>", desc = "Select terminal" },
    -- kill: current terminal, or all terminals
    { "<leader>tk", "<cmd>bd!<CR>", desc = "Kill current terminal", mode = { "n", "t" } },
    {
      "<leader>tK",
      function()
        for _, term in ipairs(require("toggleterm.terminal").get_all()) do
          term:shutdown()
        end
      end,
      desc = "Kill all terminals",
    },
  },
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = {
      border = "rounded",
      title_pos = "center",
    },
    start_in_insert = true,
    -- label each float with its terminal id/name at the top
    winbar = {
      enabled = true,
      name_formatter = function(term)
        return "  Terminal " .. term.id .. (term.display_name and (": " .. term.display_name) or "") .. "  "
      end,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- escape hatches so you're never trapped in terminal insert mode
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function()
        local o = { buffer = 0, silent = true }
        -- leave insert -> normal (terminal) mode
        vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], o)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], o)
        -- window jumps straight from terminal insert mode
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], o)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], o)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], o)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], o)
      end,
    })
  end,
}
