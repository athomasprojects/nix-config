local ok, msg = pcall(require, "sg")
if not ok then
  print("sg failed to load with:", msg)
  return
end

require("plugin.sourcegraph").setup({
  enable_cody = true,
})

-- Toggle cody chat
vim.keymap.set("n", "<space>cc", function()
  require("sg.cody.commands").toggle()
end, { desc = "Cody: Toggle chat" })

vim.keymap.set("n", "<space>cn", function()
  local name = vim.fn.input("chat name: ")
  require("sg.cody.commands").chat(name)
end, { desc = "Cody: Create chat" })

-- vim.keymap.set("v", "<space>a", ":CodyContext<CR>")
-- vim.keymap.set("v", "<space>e", ":CodyExplain<CR>")

vim.keymap.set("n", "<space>ss", function()
  require("sg.extensions.telescope").fuzzy_search_results()
end, { desc = "Search Sourcegraph" })
