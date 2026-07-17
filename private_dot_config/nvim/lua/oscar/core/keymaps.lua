local keymap = vim.keymap

-- clear search highlights
keymap.set("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear search highlights" })

-- save and quit
keymap.set("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all files" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })

-- toggle line wrap
keymap.set("n", "<leader>wr", "<cmd>set wrap!<cr>", { desc = "Toggle line wrap" })

-- exit insert mode with jk
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- window splits
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })

-- move between window splits with Ctrl + h/j/k/l
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to split below" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to split above" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- resize splits: see plugins/smart-splits.lua for Alt+hjkl resize keymaps

-- reload config without restarting nvim
-- clears cached oscar.* modules, then re-sources init.lua.
-- best for iterating on options/keymaps; plugin setups may need a real restart
-- or `:Lazy reload <plugin>`.
keymap.set("n", "<leader>rr", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^oscar") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload nvim config" })
