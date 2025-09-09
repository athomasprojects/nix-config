local harpoon = require("harpoon")

harpoon:setup({})

vim.keymap.set("n", "<space>ha", function()
  harpoon:list():add()
end, { desc = "harpoon add" })
vim.keymap.set("n", "<space>hl", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "harpoon list" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<M-Left>", function()
  harpoon:list():prev()
end, { desc = "harpoon prev file" })
vim.keymap.set("n", "<M-Right>", function()
  harpoon:list():next()
end, { desc = "harpoon next file" })

-- local keys = { ")", "(", "}", "{", "]", "[" }

for i = 1, 6 do
  vim.keymap.set("n", string.format("<space>%d", i), function()
    harpoon:list():select(i)
  end, { desc = "harpoon" .. " file #" .. i })
end
