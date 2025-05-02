local set = vim.keymap.set
local k = vim.keycode

local M = {}
M.fn = function(f, ...)
  local args = { ... }
  return function(...)
    return f(unpack(args), ...)
  end
end

-- Basic movement keybinds, these make navigating splits easy for me
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Toggle hlsearch if it's on, otherwise just do "enter"
set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return k("<CR>")
  end
end, { expr = true })

-- Normally these are not good mappings, but I have left/right on my thumb
-- cluster, so navigating tabs is quite easy this way.
set("n", "<c-left>", "gT")
set("n", "<c-right>", "gt")

-- set("n", "J", "mzJ`z")

-- Navigate quickfix list
set("n", "<M-n>", "<cmd>cnext<CR>zz")
set("n", "<M-p>", "<cmd>cprev<CR>zz")

-- Navigate location list
set("n", "<M-N>", "<cmd>lnext<CR>zz")
set("n", "<M-P>", "<cmd>lprev<CR>zz")

-- Sweet search and replace current word under cursor...chef's kiss!
set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every occurrence of current word under cursor in the current buffer" }
)

-- Same as above, but only search and replace word under cursor within the visual selection
set(
  "n",
  "<leader>S",
  [[:%s/\%V\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every occurrence of current word under cursor in the visual selection" }
)

set("n", ",w", "<cmd>write<CR>")

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
-- set("n", "]d", vim.diagnostic.goto_next)
-- set("n", "[d", vim.diagnostic.goto_prev)
set("n", "]d", M.fn(vim.diagnostic.jump, { count = 1, float = true }))
set("n", "[d", M.fn(vim.diagnostic.jump, { count = -1, float = true }))

-- These mappings control the size of splits (width/height)
set("n", "<C-,>", "<C-W>>")
set("n", "<C-.>", "<C-W><")
set("n", "<M-,>", "<c-W>5>")
set("n", "<M-.>", "<c-W>5<")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")

-- Split windows in equal width
set("n", "<leader>=", "<C-w>=")

-- Close the current window
set("n", "<leader>sx", ":close<CR>")

-- Close everything except the current window
set("n", "<leader>sX", ":only<CR>")

-- These mappings rotate the window positions
set("n", "<leader>sr", "<C-w>R", { desc = "rotate windows upwards" })
set("n", "<leader>sR", "<C-w>r", { desc = "rotate windows downwards" })

-- These mappings create new splits (vertical/horizontal)
set("n", "<leader>sv", "<C-w>v")
set("n", "<leader>sz", "<C-w>s")
-- set("n", "<leader>sV", "<C-w>v <C-w>l")
-- set("n", "<leader>sZ", "<C-w>z <C-w>j")

-- Toggle b/w most recent 2 buffers
set("n", ",,", "<C-^>")

-- These mappings open and close new tabs
set("n", "<leader>to", ":tab split<CR>")
set("n", "<leader>tO", ":tabnew<CR>")
set("n", "<leader>tx", ":tabclose<CR>")

-- These mappings control the position of the current window
set("n", "<leader>sh", "<C-w>H", { noremap = true, desc = "move current window to far left" })
set("n", "<leader>sj", "<C-w>J", { desc = "move current window to very bottom" })
set("n", "<leader>sk", "<C-w>K", { desc = "move current window to very top" })
set("n", "<leader>sl", "<C-w>L", { desc = "move current window to far right" })

set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! ]c]])
  else
    vim.cmd([[m .+1<CR>==]])
  end
end)

set("n", "<M-k>", function()
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
set("n", "<leader>zr", "zR", { desc = "Open all folds" })
set("n", "<leader>zm", "zM", { desc = "Close all folds" })

-- Managing split windows
set("n", "<leader>s+", "<C-w>|", { desc = "Focus horizontal split" })
set("n", "<leader>s-", "<C-w>_", { desc = "Focus vertical split" })

-- Opens line below or above the current line
set("i", "<S-CR>", "<C-O>o")
set("i", "<C-CR>", "<C-O>O")

-- Greatest remap ever
set("x", "<leader>p", [["_dP]])

-- Next greatest remap ever : asbjornHaland
set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

-- Delete to void register
set({ "n", "v" }, "<leader>d", [["_d]])

-- Toggle lsp inlay inhints
set("n", "<space>tt", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)
