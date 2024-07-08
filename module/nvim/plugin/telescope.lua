local data = assert(vim.fn.stdpath("data")) --[[@as string]]

require("telescope").setup({
  extensions = {
    wrap_results = true,

    fzf = {},
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<space>fd", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<space>ft", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<space>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<space>fk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })

vim.keymap.set("n", "<space>gw", builtin.grep_string, { desc = "Telescope grep string" })

vim.keymap.set("n", "<space>ff", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end)

vim.keymap.set("n", "<space>en", function()
  builtin.find_files({ cwd = "$HOME/nix-config" })
end)

-- Some convenience functions
local themes = require("telescope.themes")

vim.keymap.set("n", "<c-space>", function()
  local opts = themes.get_ivy({ hidden = false, sorting_strategy = "descending" })
  require("telescope.builtin").buffers(opts)
end, { desc = "Telescope current buffers" })

vim.keymap.set("n", "<space>bo", function()
  builtin.vim_options({
    -- layout_config = {
    --   width = 0.5,
    -- },
    sorting_strategy = "ascending"
  })
end, { desc = "Telescope vim options" })

vim.keymap.set("n", "<space>f/", function()
   builtin.live_grep({
     grep_open_files = true,
     path_display = { "shorten" },
   })
end, { desc = "Telescope live grep in open files" })
