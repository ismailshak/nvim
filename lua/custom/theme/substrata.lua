vim.g.substrata_italic_comments = false

vim.cmd([[
  augroup SubstrataColors
    autocmd!
    autocmd ColorScheme substrata hi! link FloatBorder Normal
      \ | hi! link NormalFloat Normal
  augroup END
]])
