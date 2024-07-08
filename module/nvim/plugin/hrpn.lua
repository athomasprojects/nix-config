local harpoon = require("harpoon")

harpoon:setup({})

vim.keymap.set("n", "<space>hm", function() harpoon:list():add() end)
vim.keymap.set("n", "<space>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<M-Left>", function() harpoon:list():prev() end, { desc = "harpoon prev file" })
vim.keymap.set("n", "<M-Right>", function() harpoon:list():next() end, { desc = "harpoon next file" })

local keys = { ")", "(", "}", "{", "]", "[" }

for i = 1, #keys do
  vim.keymap.set(
    "n",
    string.format("<space>%s", keys[i]),
    function()
      harpoon:list():select(i)
    end,
    { desc = "harpoon" .. " file #" .. i })
end
