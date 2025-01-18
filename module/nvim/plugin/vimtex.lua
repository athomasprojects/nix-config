vim.cmd([[filetype plugin indent on]])

vim.cmd([[
    let g:vimtex_quickfix_ignore_filters = [
          \ 'LaTeX hooks Warning',
          \ 'Underfull \\hbox',
          \ 'Overfull \\hbox',
          \ 'LaTeX Warning: .\+ float specifier changed to',
          \ 'Package siunitx Warning: Detected the "physics" package:',
          \ 'Package hyperref Warning: Token not allowed in a PDF string',
          \ 'Fatal error occurred, no output PDF file produced!',
          \]

    " toggle delimeter configuration
    let g:vimtex_delim_toggle_mod_list = [
      \ ['\left', '\right'],
      \ ['\big', '\big'],
      \ ['\Big', '\Big'],
      \ ['\bigl', '\bigr'],
      \]

    let g:vimtex_indent_enabled = 0
    let g:tex_indent_items=0
    let g:vimtex_indent_lists = []
    let g:vimtex_imaps_enabled = 0
    let g:vimtex_syntax_conceal_disable = 1

    " default is 500 lines, can give lags on missed key presses
    let g:vimtex_delim_stopline = 50

    " don't automatically open PDF viewer after first compilation
    let g:vimtex_view_automatic = 0
]])

-- Don't open quickfix for warning messages if no errors are present
vim.g.vimtex_quickfix_open_on_warning = 0

vim.g.vimtex_view_method = "sioyek"
-- vim.g.vimtex_view_general_viewer = "sioyek"
-- vim.g.vimtex_callback_progpath = "/nix/store/gmcb0b2yqk2373qkq05605cp9s93hnad-neovim-unwrapped-nightly/bin/nvim"

-- vim.g.vimtex_subfile_start_local = 1
-- vim.g.vimtex_view_sioyek_options = "--reuse-window --execute-command turn_on_synctex"
-- vim.g.vimtex_view_sioyek_options = "--execute-command turn_on_synctex"

vim.g.vimtex_compiler_latexmk = {
  executable = "latexmk",
  options = {
    -- "-pdflatex",
    -- "-lualatex",
    -- "-xelatex",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}

local augroup = vim.api.nvim_create_augroup("vimtex", {})

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "bib", "tex" },
--   group = augroup,
--   callback = function()
--     vim.wo.conceallevel = 0
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VimtexEventViewReverse",
--   group = augroup,
--   command = "call b:vimtex.viewer.xdo_focus_vim()",
-- })

-- local augroup = vim.api.nvim_create_augroup("vimtex", {})
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VimtexEventViewReverse",
--   group = augroup,
--   callback = function()
--     vim.system { "open", "${inputs.ghostty}/bin/ghostty" }
--   end,
-- })
