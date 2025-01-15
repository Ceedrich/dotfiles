vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap

-- Use the system clipboard
keymap.set({ "v", "n" }, "<C-y>", '"+y')
keymap.set({ "v", "n" }, "<C-p>", '"+p')
keymap.set({ "v", "n" }, "<C-x>", '"+x')

