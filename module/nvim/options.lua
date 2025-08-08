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
-- vim.opt.relativenumber = true

vim.api.nvim_set_option_value("cursorline", true, {})
vim.api.nvim_set_option_value("cursorlineopt", "number", {})

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.signcolumn = "yes"
vim.opt.shada = { "'10", "<0", "s10", "h" }

-- This uses the clipboard for everything instead of the default register.
-- vim.opt.clipboard = "unnamedplus"

-- Don't have `o` add a comment
vim.opt.formatoptions:remove("o")

vim.opt.wrap = true
vim.opt.linebreak = true
