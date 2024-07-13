local data = assert(vim.fn.stdpath("data")) --[[@as string]]

local set = vim.keymap.set

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

require("telescope").setup({
  extensions = {
    wrap_results = true,

    fzf = {},
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
    ["ui-select"] = {
      themes.get_dropdown({}),
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "manix")

set("n", "<space>fd", builtin.find_files, { desc = "Telescope find files" })
set("n", "<space>ft", builtin.git_files, { desc = "Telescope git files" })
set("n", "<space>fh", builtin.help_tags, { desc = "Telescope help tags" })
set("n", "<space>fg", builtin.live_grep, { desc = "Telescope live grep" })
set("n", "<space>fk", builtin.keymaps, { desc = "Telescope keymaps" })
set("n", "<space>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })

set("n", "<space>gw", builtin.grep_string, { desc = "Telescope grep string" })

set("n", "<space>ff", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end)

set("n", "<space>en", function()
  builtin.find_files({
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "$HOME/nix-config",
  })
end)

-- Some convenience functions

set("n", "<c-space>", function()
  local opts = themes.get_ivy({ hidden = false, sorting_strategy = "descending" })
  builtin.buffers(opts)
end, { desc = "Telescope current buffers" })

set("n", "<space>vo", function()
  builtin.vim_options({
    layout_config = {
      width = 0.5,
    },
    sorting_strategy = "ascending",
  })
end, { desc = "Telescope vim options" })

set("n", "<space>f/", function()
  builtin.live_grep({
    grep_open_files = true,
    path_display = { "shorten" },
  })
end, { desc = "Telescope live grep in open files" })

set("n", "<space>hg", builtin.highlights, { desc = "Telescope highlight groups" })
set("n", "<space>mm", builtin.marks, { desc = "Telescope marks" })
set("n", "<space>nx", "<cmd>Telescope manix<CR>", { desc = "Telescope manix" })

set("n", "<space>vs", function()
  require("telescope").extensions.luasnip.luasnip(themes.get_dropdown({
    layout_config = { width = 0.9, height = 0.9, prompt_position = "top", mirror = true },
    layout_strategy = "vertical",
  }))
end, { desc = "Telescope luasnip" })
