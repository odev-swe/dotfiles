-- global key mapper leader
vim.g.mapleader = " "

-- make it precise
local keymap = vim.keymap -- common key bind

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x') -- delete single alphabet
keymap.set("n", "gts", "0")
keymap.set("n", "gte", "%")

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<C-h>", "<C-w><Left>") -- move to left screen
keymap.set("n", "<C-l>", "<C-w><Right>") -- move to right screen
keymap.set("n", "<C-j>", "<C-w><Up>") -- move to up screen
keymap.set("n", "<C-k>", "<C-w><Down>") -- move to down screen
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

-- plugin key bind
keymap.set("n", "<leader>lcc", ":Leet console<CR>")
keymap.set("n", "<leader>lct", ":Leet test<CR>")
keymap.set("n", "<leader>lcr", ":Leet run<CR>")

-- run
keymap.set("n", "<leader>rr", ":!g++ -Wall % && ./a.out<cr>")
