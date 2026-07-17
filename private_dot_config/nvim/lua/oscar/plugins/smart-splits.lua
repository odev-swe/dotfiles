-- smart-splits: hold Alt+hjkl to resize the current split, repeats smoothly while held
return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
    { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
    { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
    { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
  },
  config = function()
    require("smart-splits").setup()
  end,
}
