-- telescope: fuzzy finder for files, text, buffers, etc.
return {
  "nvim-telescope/telescope.nvim",
  -- master (not 0.1.x): the 0.1.x branch calls nvim-treesitter's old
  -- ft_to_lang API, removed in the treesitter `main` rewrite. master uses
  -- Neovim's native vim.treesitter API, compatible with 0.12 + treesitter main.
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make", -- compiles the native fzf sorter (faster fuzzy matching)
    },
    "nvim-tree/nvim-web-devicons", -- icons in the pickers
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        -- <C-k>/<C-j> to move up/down the results list
        mappings = {
          i = {
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- yank visual selection into reg "v" without clobbering unnamed reg
    local function get_visual_selection()
      local save_reg = vim.fn.getreg("v")
      local save_regtype = vim.fn.getregtype("v")
      vim.cmd('noau normal! "vy')
      local sel = vim.fn.getreg("v")
      vim.fn.setreg("v", save_reg, save_regtype)
      return sel
    end

    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" }) -- find files
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" }) -- recent files
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string in cwd" }) -- search text (ripgrep)
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find string under cursor in cwd" }) -- search word under cursor
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "List open buffers" }) -- open buffers
    keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Search help tags" }) -- help tags
    keymap.set("v", "<leader>fs", function()
      require("telescope.builtin").live_grep({ default_text = get_visual_selection() })
    end, { desc = "Find visually selected string in cwd" }) -- search selected text (ripgrep)
  end,
}
