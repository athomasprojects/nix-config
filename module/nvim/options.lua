vim.g.mapleader = " "
vim.g.maplocalleader = " "

----- Interesting Options -----

-- You have to turn this one on :)
vim.opt.inccommand = "split"

-- Best search settings :)
vim.opt.smartcase = true
vim.opt.ignorecase = true

----- Personal Preferences -----
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.signcolumn = "yes"
vim.opt.shada = { "'10", "<0", "s10", "h" }

vim.opt.clipboard = "unnamedplus"

-- Don't have `o` add a comment
vim.opt.formatoptions:remove "o"

vim.opt.wrap = true
vim.opt.linebreak = true
