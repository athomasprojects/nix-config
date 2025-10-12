require("fff-snacks").setup({})

vim.keymap.set("n", "<space>ff", "<cmd>FFFSnacks <CR>", { desc = "fff find files in the current git repository" })
