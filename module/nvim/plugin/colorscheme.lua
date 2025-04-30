vim.opt.termguicolors = true

-- Set up your custom colorscheme if you want
vim.cmd.colorscheme("gruvbuddy")

-- And then modify as you like
local colorbuddy = require("colorbuddy")
local c = colorbuddy.colors
local Group = colorbuddy.Group

Group.new("FloatBorder", c.black, c.black)
Group.new("LineNr", c.gray2:light(), c.gray0)
