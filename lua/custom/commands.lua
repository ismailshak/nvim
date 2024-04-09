local api = require("utils.api")
local settings = require("custom.settings")
local highlight = require("custom.highlights")

local CUSTOM_GROUP_ID = vim.api.nvim_create_augroup("ShakCommands", { clear = true })

-- USER COMMANDS --

local usercmd = vim.api.nvim_create_user_command

usercmd("ToggleBackground", api.toggle_bg, {})

usercmd("DeleteAllMarks", function()
	vim.cmd("delmarks!") -- Delete all lowercase marks
	vim.cmd("delmarks A-Z0-9") -- Delete remaining marks
end, {})

usercmd("T", "sp | term", {}) -- Open a terminal in a horizontal split
usercmd("TT", "vsp | term", {}) -- Open a terminal in a vertical split

-- AUTOCOMMANDS --

local autocmd = vim.api.nvim_create_autocmd

-- Set a filetype for terminal buffers
autocmd("TermOpen", {
	callback = function()
		vim.cmd.set("filetype=term")
	end,
})

-- Trim trailing whitespace on save and keep cursor position intact
autocmd("BufWritePre", {
	pattern = "*",
	group = CUSTOM_GROUP_ID,
	callback = function()
		if vim.bo.filetype == "diff" then
			return
		end

		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

autocmd("OptionSet", {
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

autocmd("ColorScheme", {
	pattern = "*",
	group = CUSTOM_GROUP_ID,
	callback = function(arg)
		api.save_colorscheme(arg.match)
		highlight.plugins()
	end,
})

-- Override highlight groups for substrata (installed via plugin manager
autocmd("ColorScheme", {
	pattern = "substrata",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.g.substrata_italic_comments = false
		highlight.substrata()
	end,
})

-- Override highlight groups for nord (/colors/nord.vim)
autocmd("ColorScheme", {
	pattern = "nord",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.g.nord_italic = false
		vim.g.nord_uniform_diff_background = 1
		vim.g.nord_bold = 0
	end,
})

-- Override highlight groups for iceberg (/colors/iceberg.vim)
autocmd("ColorScheme", {
	pattern = "iceberg",
	group = CUSTOM_GROUP_ID,
	callback = function()
		local is_dark = settings.get().background == "dark"
		highlight.iceberg(is_dark)
	end,
})
