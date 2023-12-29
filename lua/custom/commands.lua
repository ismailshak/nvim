local api = require("utils.api")
local settings = require("custom.settings")
local highlight = require("custom.highlights")

local CUSTOM_GROUP_ID = vim.api.nvim_create_augroup("ShakCommands", { clear = true })

-- USER COMMANDS --

vim.api.nvim_create_user_command("ToggleBackground", api.toggle_bg, {})

-- AUTOCOMMANDS --

vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	group = CUSTOM_GROUP_ID,
	callback = function()
		local s = settings.get()
		---@diagnostic disable-next-line: inject-field
		s.background = vim.opt.background:get()
		settings.update(s)

		highlight.colorscheme(s.theme, s.background == "dark")
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	group = CUSTOM_GROUP_ID,
	callback = function()
		api.save_colorscheme()
		highlight.plugins()
	end,
})

-- Override highlight groups for substrata (installed via plugin manager
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "substrata",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.g.substrata_italic_comments = false
		highlight.substrata()
	end,
})

-- Override highlight groups for nord (/colors/nord.vim)
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "nord",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.g.nord_italic = false
		vim.g.nord_uniform_diff_background = 1
		vim.g.nord_bold = 0
	end,
})

-- Override highlight groups for iceberg (/colors/iceberg.vim)
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "iceberg",
	group = CUSTOM_GROUP_ID,
	callback = function()
		local is_dark = settings.get().background == "dark"
		highlight.iceberg(is_dark)
	end,
})
