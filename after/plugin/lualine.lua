local helpers = require("utils.helpers")
if not helpers.exists("lualine") then
	return
end

local helpers = require("utils.helpers")

local function dir_name()
	local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	return "  " .. name .. " "
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local function mixed_indent()
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

local diff_opts = {
	"diff",
	source = diff_source,
	colored = true,
	symbols = {
		added = " ",
		modified = " ",
		removed = " ",
	},
}

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = "|",
		section_separators = "",
		disabled_filetypes = {
			statusline = {},
			winbar = {},
			DiffviewFiles = {},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { dir_name },
		lualine_c = { { "filename", path = 1 }, diff_opts },
		lualine_x = { mixed_indent, "diagnostics", "searchcount", "filetype" },
		lualine_y = { "branch" },
		lualine_z = { { "location", fmt = helpers.trim } },
	},
})
