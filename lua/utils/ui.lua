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
	local dir_line = "󰉖 " .. dir_name
	local branch_line = ""
	if branch ~= "" then
		branch_line = " " .. branch
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
			added = " ",
			modified = " ",
			removed = " ",
		},
	}
end

function M.build_dir_name_icon()
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	return " 󰉖 " .. dir_name .. " "
end

function M.get_ft_icon_overrides()
	return {
		-- Original settings for these commented out below
		-- ["ts"] = {
		-- 	icon = ts_icon,
		-- 	color = "#4D93B1",
		-- 	name = "Ts",
		-- },
		-- ["js"] = {
		-- 	icon = js_icon,
		-- 	color = "#C7CC4F",
		-- 	cterm_color = "58",
		-- 	name = "Js",
		-- },
		["spec.ts"] = {
			icon = icons.files.typescript,
			color = "#E17833",
			name = "SpecTs",
		},
		["test.ts"] = {
			icon = icons.files.typescript,
			color = "#E17833",
			name = "TestTs",
		},
		["spec.js"] = {
			icon = icons.files.javascript,
			color = "#E17833",
			name = "SpecJs",
		},
		["test.js"] = {
			icon = icons.files.javascript,
			color = "#E17833",
			name = "TestJs",
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
