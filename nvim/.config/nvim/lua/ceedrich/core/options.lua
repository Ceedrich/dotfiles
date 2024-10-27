-- https://youtu.be/6pAG3BHurdM?si=2G0jBLrD9Qo3gjWu

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.cursorline = true

-- colorscheme work?
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

opt.splitright = true
opt.splitbelow = true

vim.cmd.colorscheme = "catppuccin"

-- spell checking
opt.spelllang = "de_ch,en_gb"
opt.spell = true
