local M = {}

local utils = require("utils.helpers")
local api = require("utils.api")
local icons = require("utils.icons")

function M.convert_decimal_color(color)
	local hex = string.format("%x", color)
	return "#" .. hex
end

function M.gen_dashboard_footer()
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local branch = api.get_git_branch()
	local dir_line = icons.statusline.dir .. " " .. dir_name
	local branch_line = ""
	if branch ~= "" then
		branch_line = icons.statusline.git_branch .. " " .. branch
	end
	return { "", "", dir_line, "", branch_line }
end

function M.gen_mix_indent_symbol()
	local space_pat = [[\v^ +]]
	local tab_pat = [[\v^\t+]]
	local space_indent = vim.fn.search(space_pat, "nwc")
	local tab_indent = vim.fn.search(tab_pat, "nwc")
	local mixed = (space_indent > 0 and tab_indent > 0)
	local mixed_same_line
	if not mixed then
		mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
		mixed = mixed_same_line > 0
	end
	if not mixed then
		return ""
	end
	if mixed_same_line ~= nil and mixed_same_line > 0 then
		return "MI:" .. mixed_same_line
	end
	local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
	local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
	if space_indent_cnt > tab_indent_cnt then
		return "MI:" .. tab_indent
	else
		return "MI:" .. space_indent
	end
end

function M.gen_diff_symbols()
	---@diagnostic disable-next-line: undefined-field
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

function M.build_diff_opts()
	return {
		"diff",
		source = M.gen_diff_symbols,
		colored = true,
		symbols = {
			added = icons.statusline.git_added .. " ",
			modified = icons.statusline.git_modified .. " ",
			removed = icons.statusline.git_removed .. " ",
		},
	}
end

function M.build_dir_name_icon()
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	return " " .. icons.statusline.dir .. " " .. dir_name .. " "
end

function M.pick_color(is_dark, dark_color, light_color)
	if is_dark then
		return dark_color
	else
		return light_color
	end
end

function M.get_ft_icon_overrides(background)
	local is_dark = background == "dark"
	return {
		[".env-defaults"] = {
			icon = icons.files.env,
			color = M.pick_color(is_dark, "#faf743", "#faf743"),
			cterm_color = "227",
			name = "Env",
		},
		["spec.ts"] = {
			icon = icons.files.typescript,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "SpecTs",
		},
		["test.ts"] = {
			icon = icons.files.typescript,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "TestTs",
		},
		["spec.js"] = {
			icon = icons.files.javascript,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "SpecJs",
		},
		["test.js"] = {
			icon = icons.files.javascript,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "TestJs",
		},
		["spec.jsx"] = {
			icon = icons.files.javascriptreact,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "JavaScriptReactSpec",
		},
		["test.jsx"] = {
			icon = icons.files.javascriptreact,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "JavaScriptReactSpec",
		},
		["spec.tsx"] = {
			icon = icons.files.typescriptreact,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "TypeScriptReactSpec",
		},
		["test.tsx"] = {
			icon = icons.files.typescriptreact,
			color = M.pick_color(is_dark, "#e17833", "#e2a478"),
			name = "TypeScriptReactSpec",
		},
	}
end

M.dashboard_header = {
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[ Neovim - v]] .. utils.nvim_version(),
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[]],
}

return M
