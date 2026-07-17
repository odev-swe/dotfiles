-- Bootstrap lazy.nvim (clones it on first launch if missing)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Import every spec file under lua/oscar/plugins/.
-- No default/starter plugins — only what you add there.
require("lazy").setup({
  spec = {
    { import = "oscar.plugins" },
    { import = "oscar.plugins.lsp" }, -- subfolders aren't auto-imported; add each one
  },
  checker = { enabled = false },
  change_detection = { notify = false },
})
