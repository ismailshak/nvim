local settings = require("custom.settings")
local highlight = require("custom.highlights")
local formatting = require("utils.tools.formatting")
local api = require("utils.api")
local utils = require("utils.helpers")

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
usercmd("TTT", "tabnew | term", {}) -- Open a terminal in a new tab

usercmd("Grep", function(args)
	vim.cmd(string.format("silent grep! %s | copen", args.args))
end, { nargs = "*" })

usercmd("BlamePR", function(args)
	local commit_sha
	local line = vim.fn.line(".")
	local path = vim.fn.expand("%:p")

	if args.args ~= "" then
		commit_sha = args.args
	else
		commit_sha = vim.fn.system(string.format("git blame -s -L %d,%d %s | awk '{print $1}'", line, line, path))
	end

	local repo = vim.fn.system("gh repo view --json nameWithOwner --jq .nameWithOwner")

	local pr_number = vim.fn.system(
		string.format("gh api /repos/%s/commits/%s/pulls --jq '.[0].number'", utils.trim(repo), utils.trim(commit_sha))
	)

	vim.fn.system(string.format("gh pr view --web %s", utils.trim(pr_number)))
end, { nargs = "?" })

usercmd("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	local progress = formatting.format_progress_handler()
	require("conform").format(
		{ async = true, lsp_fallback = false, range = range },
		formatting.format_callback(progress)
	)
end, { range = true })

-- Trim trailing whitespace on save and keep cursor position intact
usercmd("TrimTrailingWhitespace", function(args)
	if vim.bo.filetype == "diff" then
		return
	end

	local start_line = args.line1 or 1
	local end_line = args.line2 or vim.fn.line("$")

	local view = vim.fn.winsaveview()
	vim.cmd(string.format(":%d,%ds/\\s\\+$//ge", start_line, end_line))
	vim.fn.winrestview(view)
end, { range = true })

-- AUTOCOMMANDS --

local autocmd = vim.api.nvim_create_autocmd

-- Set a filetype for terminal buffers
autocmd("TermOpen", {
	callback = function()
		vim.cmd.set("filetype=term")
	end,
})

-- Customize copilot chat buffer
-- since after/ftplugin gets overwritten by the plugin
autocmd("BufEnter", {
	pattern = "copilot-*",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.signcolumn = "no"
	end,
})

autocmd("OptionSet", {
	pattern = "background",
	group = CUSTOM_GROUP_ID,
	callback = function()
		local s = settings.get()
		---@diagnostic disable-next-line: inject-field
		s.background = vim.o.background
		settings.update(s)

		highlight.colorscheme(s.theme, s.background == "dark")
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

autocmd("ColorScheme", {
	pattern = "*",
	group = CUSTOM_GROUP_ID,
	callback = function(arg)
		api.save_colorscheme(arg.match)
		highlight.plugins()
	end,
})
