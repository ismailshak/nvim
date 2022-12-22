-- General Theme Options
-- nord
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = 1
vim.g.nord_bold = 0

-- tokyonight
vim.g.tokyonight_style = "night" -- default "storm"

-- iceberg
-- override some highlight groups
-- adding:
-- gitsigns support
-- fidget support
-- fix some colors (virtual text, functions etc)
-- fix border
vim.cmd([[
  augroup IcebergColors
    autocmd!
    autocmd ColorScheme iceberg hi NonText ctermfg=236 guifg=#323a59
      \ | hi Type ctermfg=110 gui=NONE guifg=#a093c7
      \ | hi Keyword ctermfg=110 gui=NONE guifg=#84a0c6
      \ | hi TSFunction ctermfg=252 guifg=#b4be82
      \ | hi GitSignsChange ctermbg=235 guibg=#1e2132
      \ | hi GitSignsChangeLn ctermbg=235 ctermfg=109 guibg=#1e2132 guifg=#2d539e
      \ | hi GitSignsChangeLn ctermbg=bg ctermfg=109 guibg=#1e2132 guifg=#2d539e
      \ | hi GitSignsChangeDelete ctermbg=235 ctermfg=109 guibg=#1e2132 guifg=#2d539e
      \ | hi! link TSConstructor TSFunction
      \ | hi! link TSProperty TSKeyword
      \ | hi! link NormalFloat Normal
      \ | hi! link FloatBorder Normal
      \ | hi! link FidgetTitle TSKeyword
  augroup END
]])

-- Set theme
vim.cmd("colorscheme iceberg")
