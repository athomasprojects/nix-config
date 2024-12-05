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

  if client.name == "ruff" then
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

  vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "show signature help" })

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

lspconfig.ruff.setup({
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

lspconfig.ols.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  -- filetypes = { "odin" },
})

lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "zig", "zir" },
})

lspconfig.clangd.setup({
  -- TODO: Could include cmd, but not sure those were all relevant flags.
  --    looks like something i would have added while i was floundering
  init_options = { clangdFileStatus = true },
  -- filetypes = { "c", "cpp" },
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
    odin = { "odinfmt" },
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
