local M = {}

M.setup = function(use)
	use("shaunsingh/nord.nvim")
	use("folke/tokyonight.nvim")

	-- general theme options
	vim.g.nord_italic = false

	-- set theme
	local theme = require("plugins.colors.theme").get_theme()
	vim.cmd("colorscheme " .. theme)
end

return M
