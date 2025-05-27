vim.opt.termguicolors = true

-- Set up your custom colorscheme if you want
vim.cmd.colorscheme("gruvbuddy")

-- And then modify as you like
local colorbuddy = require("colorbuddy")
local c = colorbuddy.colors
local s = colorbuddy.styles
local Group = colorbuddy.Group

Group.new("FloatBorder", c.black, c.black)
Group.new("ElNormalMode", c.yellow, c.black, s.bold)
Group.new("ElCmdMode", c.orange, c.black, s.bold)
Group.new("LineNr", c.gray2:light(), c.gray0)

local group = vim.api.nvim_create_augroup("vimtex_events", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventInitPost",
  group = group,
  command = vim.cmd([[ 
    hi Statement guifg=#81a2be 
    hi texFileArg guifg=#de935f
  ]]),
})

vim.cmd([[
  hi link ElNormal ElNormalMode
  hi link ElCommand ElCmdMode
]])
