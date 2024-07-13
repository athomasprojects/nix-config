local lspconfig = require("lspconfig")

local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
  capabilities = require("cmp_nvim_lsp").default_capabilities()
end

local on_attach = function(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  if filetype == "typescript" or filetype == "lua" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  if client.name == "ruff_lsp" then
    client.server_capabilities.hoverProvider = false
  end

  vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
  vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })

  vim.keymap.set("n", "<space>vr", vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })

  vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = bufnr }, "show signature help")

  vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, { buffer = bufnr })
  vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_document_symbols, { buffer = bufnr })
  vim.keymap.set("n", "<leader>wd", require("telescope.builtin").lsp_dynamic_workspace_symbols, { buffer = bufnr })
end

require("neodev").setup()
lspconfig.lua_ls.setup({
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
})

lspconfig.nil_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.ruff_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.vimls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.pyright.setup({
  capabilities = capabilities,
  settings = {
    disableLanguageServices = true,
    disableOrganizeImports = true,
    -- useLibraryCodeForTypes = false,
    -- stubPath = "/home/thegusbus/stubs/python-type-stubs/stubs",
    python = {
      analysis = {
        autoSearchPaths = true,
        typeCheckingMode = "off",
        diagnosticMode = "off",
      },
    },
  },
})

lspconfig.rust_analyzer.setup({
  cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  -- settings = {
  --   ["rust-analyzer"] = {
  --     checkOnSave = {
  --       command = "clippy",
  --     },
  --   },
  -- },
})

-- Probably want to disable formatting for this lang server
lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

lspconfig.ocamllsp.setup({
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
})

lspconfig.clangd.setup({
  -- TODO: Could include cmd, but not sure those were all relevant flags.
  --    looks like something i would have added while i was floundering
  init_options = { clangdFileStatus = true },
  filetypes = { "c" },
})

-- Add a border to the hover frame.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
  close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
})

-- Autoformatting Setup
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    nix = { "alejandra" },
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
-- ============================================================================
-- require("neodev").setup {
--   -- library = {
--   --   plugins = { "nvim-dap-ui" },
--   --   types = true,
--   -- },
-- }
--
-- local capabilities = nil
-- if pcall(require, "cmp_nvim_lsp") then
--   capabilities = require("cmp_nvim_lsp").default_capabilities()
-- end
--
-- local lspconfig = require "lspconfig"
--
-- -- local servers = {
-- --   nil_ls = true,
-- --   lua_ls = {
-- --     on_attach = custom_attach,
-- --     cmd = { "lua_lsp" },
-- --     server_capabilities = {
-- --       semanticTokensProvider = vim.NIL,
-- --     },
-- --     settings = {
-- -- 	Lua = {
-- -- 	  workspace = { checkThirdParty = false },
-- -- 	  telemetry = { enable = false },
-- --         },
-- --     }
-- --   },
-- --
-- --   -- bashls = true,
-- --   -- pyright = {
-- --   --   capabilities = updated_capabilities,
-- --   --   settings = {
-- --   --     disableLanguageServices = true,
-- --   --     disableOrganizeImports = true,
-- --   --     -- useLibraryCodeForTypes = false,
-- --   --     -- stubPath = "/home/thegusbus/stubs/python-type-stubs/stubs",
-- --   --     python = {
-- --   --       analysis = {
-- --   --         autoSearchPaths = true,
-- --   --         typeCheckingMode = "off",
-- --   --         diagnosticMode = "off",
-- --   --       },
-- --   --     },
-- --   --   },
-- --   -- }
-- --   --
-- --   -- rust_analyzer = {
-- --   --   cmd = { "rustup", "run", "nightly", "rust-analyzer" },
-- --   --   -- settings = {
-- --   --   --   ["rust-analyzer"] = {
-- --   --   --     checkOnSave = {
-- --   --   --       command = "clippy",
-- --   --   --     },
-- --   --   --   },
-- --   --   -- },
-- --   -- }
-- --   -- -- Probably want to disable formatting for this lang server
-- --   -- jsonls = {
-- --   --   settings = {
-- --   --     json = {
-- --   --       schemas = require("schemastore").json.schemas(),
-- --   --       validate = { enable = true },
-- --   --     },
-- --   --   },
-- --   -- },
-- --   --
-- --   -- yamlls = {
-- --   --   settings = {
-- --   --     yaml = {
-- --   --       schemaStore = {
-- --   --         enable = false,
-- --   --         url = "",
-- --   --       },
-- --   --       schemas = require("schemastore").yaml.schemas(),
-- --   --     },
-- --   --   },
-- --   -- },
-- --   --
-- --   -- ocamllsp = {
-- --   --   -- manual_install = true,
-- --   --   settings = {
-- --   --     codelens = { enable = true },
-- --   --     inlayHints = { enable = true },
-- --   --     syntaxDocumentation = { enable = true },
-- --   --   },
-- --   --
-- --   --   filetypes = {
-- --   --     "ocaml",
-- --   --     "ocaml.interface",
-- --   --     "ocaml.menhir",
-- --   --     "ocaml.cram",
-- --   --     "ocaml.mlx",
-- --   --   },
-- --   --
-- --   --   -- TODO: Check if i still need the filtypes stuff i had before
-- --   -- },
-- --   --
-- --   -- clangd = {
-- --   --   -- TODO: Could include cmd, but not sure those were all relevant flags.
-- --   --   --    looks like something i would have added while i was floundering
-- --   --   init_options = { clangdFileStatus = true },
-- --   --   filetypes = { "c" },
-- --   -- },
-- -- }
-- --
-- -- -- local servers_to_install = vim.tbl_filter(function(key)
-- -- --   local t = servers[key]
-- -- --   if type(t) == "table" then
-- -- --     return not t.manual_install
-- -- --   else
-- -- --     return t
-- -- --   end
-- -- -- end, vim.tbl_keys(servers))
-- --
-- -- -- vim.list_extend(ensure_installed, servers_to_install)
-- -- -- require("mason-tool-installer").setup { ensure_installed = ensure_installed }
--
-- local disable_semantic_tokens = {
--   lua = true,
-- }
--
-- local custom_attach = function(client, bufnr)
--   local filetype = vim.api.nvim_buf_get_option(0, "filetype")
--
--   if filetype == "typescript" or filetype == "lua" then
--     client.server_capabilities.semanticTokensProvider = nil
--   end
--
--   if client.name == "ruff_lsp" then
--     client.server_capabilities.hoverProvider = false
--   end
--
--   vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
--   vim.keymap.set("n", "gd", vim.lsp.buf.definition, {  buffer = bufnr })
--   vim.keymap.set("n", "gr", vim.lsp.buf.references, {  buffer = bufnr })
--   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {  buffer = bufnr })
--   vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, {  buffer = bufnr })
--   vim.keymap.set("n", "K", vim.lsp.buf.hover, {  buffer = bufnr })
--
--   vim.keymap.set("n", "<space>vr", vim.lsp.buf.rename, {  buffer = bufnr })
--   vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, {  buffer = bufnr })
--
--   vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, {  buffer = bufnr }, "show signature help")
--
--   vim.keymap.set('<leader>gr', require('telescope.builtin').lsp_references)
--   vim.keymap.set('<leader>ws', require('telescope.builtin').lsp_document_symbols)
--   vim.keymap.set('<leader>wd', require('telescope.builtin').lsp_dynamic_workspace_symbols)
--
--   local filetype = vim.bo[bufnr].filetype
--   if disable_semantic_tokens[filetype] then
--     client.server_capabilities.semanticTokensProvider = nil
--   end
-- end
--
-- -- for name, config in pairs(servers) do
-- --   if config == true then
-- --     config = {}
-- --   end
-- --   config = vim.tbl_deep_extend("force", {}, {
-- --     on_attach = custom_attach,
-- --     capabilities = capabilities,
-- --   }, config)
-- --
-- --   lspconfig[name].setup(config)
-- -- end
--
-- lspconfig.nil_ls.setup{}
--
-- lspconfig.lua_ls.setup({
--   cmd = { "lua_lsp" },
--   on_attach = custom_attach,
--   root_dir = function()
--         return vim.loop.cwd()
--     end,
-- 	cmd = { "lua-lsp" },
--     settings = {
--         Lua = {
--             workspace = { checkThirdParty = false },
--             telemetry = { enable = false },
--         },
--     }
--   capabilities = capabilities,
-- })
--
-- -- Add a border to the hover frame.
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = "single",
--   close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
-- })
--
-- -- Autoformatting Setup
-- require("conform").setup {
--   formatters_by_ft = {
--     lua = { "stylua" },
--     python = { "ruff_format" },
--   },
-- }
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   callback = function(args)
--     require("conform").format {
--       bufnr = args.buf,
--       lsp_fallback = true,
--       quiet = true,
--     }
--   end,
-- })
--
--
-- ============================================================================
