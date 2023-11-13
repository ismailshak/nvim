--[[
  Override highlight groups (only fixes dark mode)
  - fix git diff colors
  - fix some colors (virtual text, functions etc)
  - fix border
  - fidget support
  - better completion menu coloring
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
      \ | hi! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
      \ | hi! CmpItemAbbrMatch guibg=NONE guifg=#B78E6F
      \ | hi! CmpItemKindFunction guibg=NONE guifg=#C586C0
      \ | hi! link Identifier TSVariable
      \ | hi! link TSConstructor TSFunction
      \ | hi! link TSProperty TSKeyword
      \ | hi! link NormalFloat Normal
      \ | hi! link FloatBorder Normal
      \ | hi! link DiagnosticFloatingHint Normal
      \ | hi! link FidgetTitle TSKeyword
      \ | hi! link CmpItemKind Normal
      \ | hi! link CmpItemKindKeyword CmpItemKind
      \ | hi! link CmpItemKindVariable CmpItemKind
      \ | hi! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
      \ | hi! link CmpItemKindInterface CmpItemKindAbbrMatch
      \ | hi! link CmpItemKindText CmpItemKindVariable
      \ | hi! link CmpItemKindMethod CmpItemKindFunction
      \ | hi! link CmpItemKindProperty CmpItemKindKeyword
      \ | hi! link CmpItemKindField Keyword
      \ | hi! link CmpItemKindUnit CmpItemKindKeyword
      \ | hi! link rustFuncCall TSFunction
      \ | if &background == 'light'
      \ |   hi DiffAdd guibg=#cbd6bb guifg=NONE
      \ |   hi DiffChange guibg=#cfd7ca guifg=NONE
      \ |   hi DiffDelete guibg=#edbabd guifg=NONE
      \ |   hi DiffText guibg=#c1cdb8 guifg=NONE
      \ | endif
  augroup END
]])

-- Disabling all semantic highlights (I didn't like how rust highlighting looked compared to default)
-- :h lsp-semantic-highlight
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "Iceberg",
	callback = function()
		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end,
})
