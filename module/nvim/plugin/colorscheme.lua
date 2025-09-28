vim.opt.termguicolors = true

-- Set up your custom colorscheme if you want
-- vim.cmd.colorscheme("gruvbuddy")

require("tokyonight").setup({
  style = "day",
  -- disable italic for functions
  styles = {
    keywords = {
      italic = false,
      bold = true,
    },
  },
  on_highlights = function(hl, c)
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopePromptNormal = {
      bg = prompt,
    }
    hl.TelescopePromptBorder = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePromptTitle = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePreviewTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopeResultsTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.FloatBorder = {
      fg = c.bg_float,
      bg = c.bg_float,
      -- guibg=#d0d5e3
    }
  end,
})

vim.cmd.colorscheme("tokyonight")

-- And then modify as you like
local colorbuddy = require("colorbuddy")
-- local c = colorbuddy.colors
-- local s = colorbuddy.styles
-- local g = colorbuddy.groups
-- local Group = colorbuddy.Group

-- Group.new("FloatBorder", nil, g.Float, nil)

-- Group.new("FloatBorder", c.black, c.black)
-- Group.new("ElNormalMode", c.yellow, c.black, s.bold)
-- Group.new("ElCmdMode", c.orange, c.black, s.bold)
-- Group.new("CursorLine", nil, nil)
-- Group.new("CursorLineNr", c.gray4, c.gray0)
-- Group.new("LineNr", c.gray2:light(), c.gray0)
--
-- local group = vim.api.nvim_create_augroup("vimtex_events", {})
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VimtexEventInitPost",
--   group = group,
--   command = vim.cmd([[
--     hi Statement guifg=#81a2be
--     hi texFileArg guifg=#de935f
--   ]]),
-- })
--
-- vim.cmd([[
--   hi link ElNormal ElNormalMode
--   hi link ElCommand ElCmdMode
--  ]])
