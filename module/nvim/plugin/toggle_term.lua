local nv = require("nvterm.terminal")

require("nvterm").setup()

vim.keymap.set({ "n", "t" }, ",th", function()
  nv.toggle("horizontal")
end, { silent = true, desc = "Toggle horizontal terminal" })

vim.keymap.set({ "n", "t" }, ",tv", function()
  nv.toggle("vertical")
end, { silent = true, desc = "Toggle vertical terminal" })

vim.keymap.set({ "n", "t" }, ",ct", function()
  nv.close_all_terms()
end, { silent = true, desc = "[Nvterm] close all terminals" })
