-- local lspconfig = require("lspconfig")

local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
  capabilities = require("cmp_nvim_lsp").default_capabilities()
end

-- vim.lsp.config("*", { capabilities = capabilities })

local on_attach = function(client, bufnr)
  -- NOTE: nvim_buf_get_option was deprecated in 0.11.
  -- local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })

  if filetype == "typescript" or filetype == "lua" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end

  vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
  vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
  -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "single" })
  end, { buffer = bufnr })

  vim.keymap.set("n", "<space>vr", vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })

  -- vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "show signature help" })
  vim.keymap.set("i", "<c-s>", function()
    vim.lsp.buf.signature_help({
      border = "solid",
      close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
    })
  end, { buffer = bufnr, desc = "show signature help" })

  vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, { buffer = bufnr })
  vim.keymap.set(
    "n",
    "<leader>ws",
    require("telescope.builtin").lsp_document_symbols,
    { buffer = bufnr, desc = "show document symbols" }
  )
  vim.keymap.set(
    "n",
    "<leader>wd",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    { buffer = bufnr, desc = "show dynamic workspace symbols" }
  )
  vim.keymap.set(
    "n",
    "<leader>dg",
    require("telescope.builtin").diagnostics,
    { buffer = bufnr, desc = "Telescope diagnostics" }
  )
end

-- require("neodev").setup()
require("lazydev").setup()

vim.lsp.config["lua_ls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  server_capabilities = {
    semanticTokensProvider = vim.NIL,
  },
}

vim.lsp.config["nil_ls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["bashls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["ruff"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["vimls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
}

vim.lsp.config["pyright"] = {
  filetypes = { "python" },
  capabilities = capabilities,
  settings = {
    pyright = {
      disableOrganizeImports = true, -- using ruff
    },
    python = {
      analysis = {
        -- ignore = { "*" }, -- using ruff
        -- typeCheckingMode = "off",
        autoSearchPaths = true,
        -- diagnosticMode = "workspace",
      },
    },
  },
}

vim.lsp.config["rust_analyzer"] = {
  cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  -- settings = {
  --   ["rust-analyzer"] = {
  --     checkOnSave = {
  --       command = "clippy",
  --     },
  --   },
  -- },
}

-- Probably want to disable formatting for this lang server
vim.lsp.config["jsonls"] = {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

vim.lsp.config["yamlls"] = {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}

vim.lsp.config["ols"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  -- filetypes = { "odin" },
}

vim.lsp.config["zls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "zig", "zir" },
}

vim.lsp.config["clangd"] = {
  -- TODO: Could include cmd, but not sure those were all relevant flags.
  --    looks like something i would have added while i was floundering
  init_options = { clangdFileStatus = true },
  -- filetypes = { "c", "cpp" },
}

vim.lsp.config["ocamllsp"] = {
  -- manual_install = true,
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
  filetypes = {
    "ocaml",
    "ocaml.interface",
    "ocaml.menhir",
    "ocaml.cram",
    "ocaml.mlx",
  },
  -- get_language_id = function(_, ftype)
  --   return ftype
  -- end,

  -- TODO: Check if i still need the filtypes stuff i had before
}

-- require("ocaml").setup()

-- NOTE: This way of adding a border to the hover frame is deprecated. Instead, use vim.lsp.buf.hover (see above).
-- -- Add a border to the hover frame.
-- -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" })
-- -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
-- --   -- border = "single",
-- --   border = "solid",
-- --   close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
-- -- })

vim.lsp.enable({
  "bashls",
  "clangd",
  "jsonls",
  "lua_ls",
  "nil_ls",
  "ocamllsp",
  "ols",
  "pyright",
  "ruff",
  "rust_analyzer",
  "vimls",
  "yamlls",
  "zls",
})

-- Autoformatting Setup
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    nix = { "alejandra" },
    odin = { "odinfmt" },
    -- ocaml = { "ocamlformat" },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    require("conform").format({
      bufnr = args.buf,
      lsp_fallback = true,
      quiet = true,
    })
  end,
})

require("lsp_lines").setup({})
vim.diagnostic.config({ virtual_text = false })
vim.keymap.set("n", "<space>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
