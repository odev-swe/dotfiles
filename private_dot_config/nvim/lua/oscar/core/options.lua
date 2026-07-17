-- Leader keys must be set before lazy.nvim loads (init.lua requires core first)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ensure mise shims are on PATH so LSP servers (e.g. gopls) find `go`, `node`,
-- etc. even when nvim is launched from a GUI where ~/.zshrc never ran.
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 and not string.find(vim.env.PATH or "", mise_shims, 1, true) then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end

local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- indentation (2 spaces, expand tabs)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

-- behaviour
opt.wrap = false
opt.clipboard:append("unnamedplus") -- use system clipboard
opt.splitright = true
opt.splitbelow = true
