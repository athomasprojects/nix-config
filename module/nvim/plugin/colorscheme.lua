vim.opt.termguicolors = true

-- Set up your custom colorscheme if you want
vim.cmd.colorscheme("gruvbuddy")

-- And then modify as you like
local colorbuddy = require("colorbuddy")
local c = colorbuddy.colors
local Group = colorbuddy.Group

Group.new("FloatBorder", c.black, c.black)

local group = vim.api.nvim_create_augroup("vimtex_events", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventInitPost",
  group = group,
  command = vim.cmd([[ 
    hi Statement guifg=#81a2be 
    hi texFileArg guifg=#de935f
  ]]),
})
