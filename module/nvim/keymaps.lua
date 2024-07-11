local M = {}
M.fn = function(f, ...)
  local args = { ... }
  return function(...)
    return f(unpack(args), ...)
  end
end

-- Basic movement keybinds, these make navigating splits easy for me
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Toggle hlsearch if it's on, otherwise just do "enter"
vim.keymap.set("n", "<CR>", function()
  if vim.opt.hlsearch:get() then
    vim.cmd.nohl()
    return ""
  else
    return "<CR>"
  end
end, { expr = true })

-- Normally these are not good mappings, but I have left/right on my thumb
-- cluster, so navigating tabs is quite easy this way.
vim.keymap.set("n", "<c-left>", "gT")
vim.keymap.set("n", "<c-right>", "gt")

-- vim.keymap.set("n", "J", "mzJ`z")

-- Navigate quickfix list
vim.keymap.set("n", "<M-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<M-p>", "<cmd>cprev<CR>zz")

-- Navigate quickfix list
vim.keymap.set("n", "<M-N>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<M-P>", "<cmd>lprev<CR>zz")

-- Sweet search and replace current word under cursor ... chef's kiss!
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every occurrence of current word under cursor in the current buffer" }
)

-- Same as above, but only search and replace word under cursor within the visual selection
vim.keymap.set(
  "n",
  "<leader>S",
  [[:%s/\%V\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every occurrence of current word under cursor in the visual selection" }
)

vim.keymap.set("n", ",w", "<cmd>write<CR>")

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", M.fn(vim.diagnostic.jump, { count = 1, float = true }))
vim.keymap.set("n", "[d", M.fn(vim.diagnostic.jump, { count = -1, float = true }))

-- These mappings control the size of splits (width/height)
vim.keymap.set("n", "<C-,>", "<C-W>>")
vim.keymap.set("n", "<C-.>", "<C-W><")
vim.keymap.set("n", "<M-,>", "<c-W>5>")
vim.keymap.set("n", "<M-.>", "<c-W>5<")
vim.keymap.set("n", "<M-t>", "<C-W>+")
vim.keymap.set("n", "<M-s>", "<C-W>-")

-- Split windows in equal width
vim.keymap.set("n", "<leader>=", "<C-w>=")

-- Close the current window
vim.keymap.set("n", "<leader>sx", ":close<CR>")

-- Close everything except the current window
vim.keymap.set("n", "<leader>sX", ":only<CR>")

-- These mappings rotate the window positions
vim.keymap.set("n", "<leader>sr", "<C-w>R", { desc = "rotate windows upwards" })
vim.keymap.set("n", "<leader>sR", "<C-w>r", { desc = "rotate windows downwards" })

-- These mappings create new splits (vertical/horizontal)
vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sz", "<C-w>s")
-- vim.keymap.set("n", "<leader>sV", "<C-w>v <C-w>l")
-- vim.keymap.set("n", "<leader>sZ", "<C-w>z <C-w>j")

-- Toggle b/w most recent 2 buffers
vim.keymap.set("n", ",,", "<C-^>")

-- These mappings open and close new tabs
vim.keymap.set("n", "<leader>to", ":tab split<CR>")
vim.keymap.set("n", "<leader>tO", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>")

-- These mappings control the position of the current window
vim.keymap.set("n", "<leader>sh", "<C-w>H", { noremap = true, desc = "move current window to far left" })
vim.keymap.set("n", "<leader>sj", "<C-w>J", { desc = "move current window to very bottom" })
vim.keymap.set("n", "<leader>sk", "<C-w>K", { desc = "move current window to very top" })
vim.keymap.set("n", "<leader>sl", "<C-w>L", { desc = "move current window to far right" })

vim.keymap.set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! ]c]])
  else
    vim.cmd([[m .+1<CR>==]])
  end
end)

vim.keymap.set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! [c]])
  else
    vim.cmd([[m .-2<CR>==]])
  end
end)

-- Insert new line without entering insert mode
vim.cmd([[
  nnoremap <Leader>O O<Esc>0"_D,
  nnoremap <Leader>o o<Esc>0"_D
]])

-- Folds
vim.keymap.set("n", "<leader>zr", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>zm", "zM", { desc = "Close all folds" })

-- Managing Split Windows
vim.keymap.set("n", "<leader>s+", "<C-w>|", { desc = "Focus horizontal split" })
vim.keymap.set("n", "<leader>s-", "<C-w>_", { desc = "Focus vertical split" })

-- Opens line below or above the current line
vim.keymap.set("i", "<S-CR>", "<C-O>o")
vim.keymap.set("i", "<C-CR>", "<C-O>O")
