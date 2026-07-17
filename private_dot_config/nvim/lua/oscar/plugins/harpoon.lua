-- harpoon: pin a handful of files, jump to them by index
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap

    keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    keymap.set("n", "<leader>hh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon quick menu" })

    keymap.set("n", "<leader>h1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon to file 1" })

    keymap.set("n", "<leader>h2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon to file 2" })

    keymap.set("n", "<leader>h3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon to file 3" })

    keymap.set("n", "<leader>h4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon to file 4" })

    -- remove the current file from the harpoon list
    keymap.set("n", "<leader>hd", function()
      harpoon:list():remove()
    end, { desc = "Harpoon remove current file" })

    -- cycle through the harpoon list (Ctrl-Shift-p/n often collapses to Ctrl-p/n in terminals, so plain Ctrl is used)
    keymap.set("n", "<C-p>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon prev file" })

    keymap.set("n", "<C-n>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next file" })
  end,
}
