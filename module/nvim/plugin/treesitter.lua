local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

require("nvim-treesitter").setup({
  ensure_installed = {},
  sync_install = false,
  auto_install = false,

  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = { "latex" }, -- , "markdown" },
    disable = { "bibtex" }, --, "markdown"
  },

  indent = {
    enable = true,
    disable = { "python", "ocaml", "ocaml.interface" },
  },

  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
  --     node_incremental = "<M-w>", -- increment to the upper named parent
  --     node_decremental = "<M-C-w>", -- decrement to the previous node
  --     scope_incremental = "<M-S-w>", -- increment to the upper scope (as defined in locals.scm)
  --   },
  -- },

  -- textobjects = {
  --   move = {
  --     enable = true,
  --     set_jumps = true,
  --     goto_next_start = {
  --       ["]p"] = "@parameter.inner",
  --       ["]m"] = "@function.outer",
  --       ["]]"] = "@class.outer",
  --     },
  --     goto_next_end = {
  --       ["]M"] = "@function.outer",
  --       ["]["] = "@class.outer",
  --     },
  --     goto_previous_start = {
  --       ["[p"] = "@parameter.inner",
  --       ["[m"] = "@function.outer",
  --       ["[["] = "@class.outer",
  --     },
  --     goto_previous_end = {
  --       ["[M"] = "@function.outer",
  --       ["[]"] = "@class.outer",
  --     },
  --   },
  --
  --   selection_modes = {
  --     ["@parameter.outer"] = "v", -- charwise
  --     ["@function.outer"] = "V", -- linewise
  --     ["@class.outer"] = "<c-v>", -- blockwise
  --   },
  --
  --   select = {
  --     enable = true,
  --     lookahead = true,
  --     keymaps = {
  --       ["af"] = "@function.outer",
  --       ["if"] = "@function.inner",
  --       ["ac"] = "@conditional.outer",
  --       ["ic"] = "@conditional.inner",
  --       ["al"] = "@loop.outer",
  --       ["il"] = "@loop.inner",
  --       ["ai"] = "@comment.outer",
  --       ["ii"] = "@comment.inner",
  --       ["aa"] = "@parameter.outer",
  --       ["ia"] = "@parameter.inner",
  --       ["av"] = "@variable.outer",
  --       ["iv"] = "@variable.inner",
  --     },
  --   },
  -- },
})

local syntax_on = {
  -- elixir = true,
  -- php = true,
  bash = true,
  bibtex = true,
  c = true,
  cmake = true,
  cpp = true,
  fish = true,
  go = true,
  html = true,
  javascript = true,
  json = true,
  latex = true,
  lua = true,
  make = true,
  markdown = true,
  nix = true,
  ocaml = true,
  python = true,
  rust = true,
  toml = true,
  vimdoc = true,
  vim = true,
  yaml = true,
}

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    pcall(vim.treesitter.start)

    if syntax_on[ft] then
      vim.bo[bufnr].syntax = "on"
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local parsers = require("nvim-treesitter.parsers")

    parsers.lua = {
      tier = 0,

      ---@diagnostic disable-next-line: missing-fields
      install_info = {
        url = "https://github.com/tjdevries/tree-sitter-lua",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }
  end,
})
