--[[
  Override highlight groups
	(only fixes dark mode)
  - fix git diff colors
  - fix some colors (virtual text, functions etc)
  - fix border
	- fidget support
]]
--
vim.cmd([[
  augroup IcebergColors
    autocmd!
    autocmd ColorScheme iceberg hi NonText guifg=#3f4660
      \ | hi Type ctermfg=110 gui=NONE guifg=#a093c7
      \ | hi Keyword ctermfg=110 gui=NONE guifg=#84a0c6
      \ | hi TSFunction ctermfg=252 guifg=#b4be82
      \ | hi DiffAdd guibg=#4c5340 guifg=NONE
      \ | hi DiffChange guibg=#32382e guifg=NONE
      \ | hi DiffDelete guibg=#53343b guifg=NONE
      \ | hi DiffText guibg=#4c5340 guifg=NONE
      \ | hi! link TSConstructor TSFunction
      \ | hi! link TSProperty TSKeyword
      \ | hi! link NormalFloat Normal
      \ | hi! link FloatBorder Normal
      \ | hi! link FidgetTitle TSKeyword
  augroup END
]])
