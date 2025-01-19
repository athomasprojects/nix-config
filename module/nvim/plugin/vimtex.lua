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
-- Not sure we weed to explicitly tell sioyek to reuse the same pdf window...
-- `turn_on_synctex` tells sioyek to start the sioyek instance with synctex mode turned on by default.
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
