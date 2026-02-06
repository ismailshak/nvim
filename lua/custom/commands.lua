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

usercmd("YankRelativePath", "let @+=expand('%:~:.')", {})
usercmd("YankAbsolutePath", "let @+=expand('%:p')", {})

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

local dotfiles = {
	[" zsh"] = "~/.zshrc",
	[" zshenv"] = "~/.zshenv",
	[" git"] = "~/.gitconfig",
	[" tmux"] = "~/.tmux.conf",
	[" AWS config"] = "~/.aws/config",
	[" AWS credentials"] = "~/.aws/credentials",
}

usercmd("Dotfiles", function()
	local items = {}
	for name, _ in pairs(dotfiles) do
		table.insert(items, name)
	end

	require("fzf-lua").fzf_exec(items, {
		prompt = "Dotfiles> ",
		winopts = { height = 0.3, width = 0.3 },
		actions = {
			["default"] = function(selected)
				local path = dotfiles[selected[1]]
				vim.cmd(string.format("edit %s", path))
			end,
		},
	})
end, { nargs = 0 })

usercmd("Color", function(args)
	if args.args == "shade" then
		require("minty.shades").open()
		return
	end

	require("minty.huefy").open()
end, {
	nargs = "?",
	complete = function()
		return {
			"hue",
			"shade",
		}
	end,
})

usercmd("Settings", function()
	require("custom.toggle").toggle()
end, { nargs = 0 })

-- AUTOCOMMANDS --

local autocmd = vim.api.nvim_create_autocmd

-- Set a filetype for terminal buffers
autocmd("TermOpen", {
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.cmd.set("filetype=term")
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

-- Filetypes that should not have typos_lsp attached
local DISABLED_TYPOS_FT = { "dashboard", "term", "toggleterm" }

autocmd("LspAttach", {
	pattern = "*",
	group = CUSTOM_GROUP_ID,
	callback = function(opts)
		local id = opts.data.client_id
		local client = vim.lsp.get_client_by_id(id) or {}

		-- Detach typos_lsp from certain filetypes
		if client.name == "typos_lsp" and utils.contains(DISABLED_TYPOS_FT, vim.bo.filetype) then
			vim.schedule(function()
				vim.lsp.buf_detach_client(opts.buf, id)
			end)
		end
	end,
})

-- Enable cursor line on active window
autocmd("WinEnter", {
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = false
		end
	end,
})

-- Disable cursor line on inactive window
autocmd("WinLeave", {
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})

-- Open dashboard on startup if no files were specified
autocmd("VimEnter", {
	once = true,
	callback = function()
		if vim.fn.argc() > 0 then
			return
		end

		if vim.bo.filetype ~= "" then
			return
		end

		-- https://github.com/nvim-mini/mini.starter/blob/8ee6ce6a4c9be47682516908557cc062c4d595a2/lua/mini/starter.lua#L1446-L1454
		local n_lines = vim.api.nvim_buf_line_count(0)
		if n_lines > 1 then
			return
		end
		local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
		if string.len(first_line) > 0 then
			return
		end

		require("custom.dashboard").open()
	end,
})
