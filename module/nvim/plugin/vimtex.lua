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
    ]])

-- VimTeX toggle delimeter configuration
vim.cmd([[
      let g:vimtex_delim_toggle_mod_list = [
      \ ['\left', '\right'],
      \ ['\big', '\big'],
      \ ['\Big', '\Big'],
      \ ['\bigl', '\bigr'],
      \]
    ]])

-- Disable concealer
-- vim.g.vimtex_syntax_conceal_disable = 0

-- Don't open quickfix for warning messages if no errors are present
vim.g.vimtex_quickfix_open_on_warning = 0

vim.g.vimtex_view_method = "sioyek"
--vim.g.vimgtex_view_sioyek_exe = 'sioyek'

vim.g.vimtex_format_enabled = 1

--Default is 500 lines and gave me lags on missed key presses
vim.g.vimtex_delim_stopline = 80

vim.g.vimtex_subfile_start_local = 1
vim.g.vimtex_view_sioyek_options = "--reuse-window"

--vim.g.vimtex_view_general_viewer = 'sioyek'
--vim.g.vimtex_callback_progpath = '~/bin/nvim'

-- Don't automatically open PDF viewer after first compilation
vim.cmd("let g:vimtex_view_automatic = 0")

vim.g.vimtex_compiler_latexmk = {
  executable = "latexmk",
  options = {
    "-lualatex",
    -- "-pdflatex",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
