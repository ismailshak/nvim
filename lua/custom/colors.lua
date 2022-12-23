-- General Theme Options
-- nord
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = 1
vim.g.nord_bold = 0

-- tokyonight
vim.g.tokyonight_style = "night" -- default "storm"

-- iceberg
--[[
  override some highlight groups
  adding:
  - fix git diff colors
  - fidget support
  - fix some colors (virtual text, functions etc)
  - fix border
]]--
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

local M = {}
M.theme = "iceberg"

-- Set theme
vim.cmd("colorscheme " .. M.theme)

return M
