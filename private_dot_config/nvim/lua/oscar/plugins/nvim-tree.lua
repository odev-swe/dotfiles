-- nvim-tree: a file explorer sidebar
return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- file icons (JetBrainsMono Nerd Font renders these)
  },
  config = function()
    -- nvim-tree recommends disabling netrw at startup
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      renderer = {
        indent_markers = { enable = true }, -- show │ guides for nesting
      },
      actions = {
        open_file = {
          window_picker = { enable = false }, -- don't prompt which window to open in
        },
      },
      filters = {
        custom = { ".DS_Store" }, -- hide macOS junk files
      },
      git = {
        ignore = false, -- still show files listed in .gitignore
      },
    })

    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<C-o>", function()
      vim.fn.jobstart({ "open", "-R", vim.fn.expand("%:p") }) -- reveal current file in Finder
    end, { desc = "Reveal current file in Finder" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle & reveal current file" }) -- toggle and reveal current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end,
}
