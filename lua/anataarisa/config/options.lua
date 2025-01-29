vim.cmd("let g:netrw_liststyle = 3")

local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

opt.backspace = "2"
opt.showcmd = true
opt.laststatus = 2
opt.autowrite = true
opt.cursorline = true
opt.autoread = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true
opt.relativenumber = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.splitright = true
opt.splitbelow = true

g.lazyvim_rust_diagnostics = "rust-analyzer"
