local M = {}

M.setup = function(use)
	use("folke/tokyonight.nvim")

	-- general theme options
	vim.g.nord_italic = false
	vim.g.nord_uniform_diff_background = 1
	vim.g.nord_bold = 0

	vim.g.tokyonight_style = "night" -- default "storm"

	-- set theme
	local theme = require("plugins.colors.theme").get_theme()
	vim.cmd("colorscheme " .. theme)
end

return M
