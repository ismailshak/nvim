local feline_status_ok, feline = pcall(require, "feline")
if not feline_status_ok then
	return
end

local colors = require("plugins.colors.nord-colors")

-- contains all options that will be passed to feline
local opt = {}

opt.lsp = require("feline.providers.lsp")
opt.lsp_severity = vim.diagnostic.severity

opt.icons = {
	left = "",
	right = "",
	main_icon = "  ",
	vi_mode_icon = " ",
	position_icon = " ",
}

opt.mode_colors = {
	["n"] = { "NORMAL", colors.red },
	["no"] = { "N-PENDING", colors.red },
	["i"] = { "INSERT", colors.dark_purple },
	["ic"] = { "INSERT", colors.dark_purple },
	["t"] = { "TERMINAL", colors.green },
	["v"] = { "VISUAL", colors.cyan },
	["V"] = { "V-LINE", colors.cyan },
	[""] = { "V-BLOCK", colors.cyan },
	["R"] = { "REPLACE", colors.orange },
	["Rv"] = { "V-REPLACE", colors.orange },
	["s"] = { "SELECT", colors.nord_blue },
	["S"] = { "S-LINE", colors.nord_blue },
	[""] = { "S-BLOCK", colors.nord_blue },
	["c"] = { "COMMAND", colors.pink },
	["cv"] = { "COMMAND", colors.pink },
	["ce"] = { "COMMAND", colors.pink },
	["r"] = { "PROMPT", colors.teal },
	["rm"] = { "MORE", colors.teal },
	["r?"] = { "CONFIRM", colors.teal },
	["!"] = { "SHELL", colors.green },
}

opt.main_icon = {
	provider = opt.icons.main_icon,

	hl = {
		fg = colors.statusline_bg,
		bg = colors.nord_blue,
	},

	right_sep = {
		str = opt.icons.right,
		hl = {
			fg = colors.nord_blue,
			bg = colors.lightbg,
		},
	},
}

opt.file_name = {
	provider = function()
		local filename = vim.fn.expand("%:t")
		local extension = vim.fn.expand("%:e")
		local icon = require("nvim-web-devicons").get_icon(filename, extension)
		if icon == nil then
			icon = " "
			return icon
		end
		return " " .. icon .. " " .. filename .. " "
	end,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
	end,
	hl = {
		fg = colors.white,
		bg = colors.lightbg,
	},

	right_sep = {
		str = opt.icons.right,
		hl = { fg = colors.lightbg, bg = colors.lightbg2 },
	},
}

opt.diff = {
	add = {
		provider = "git_diff_added",
		hl = {
			fg = colors.grey_fg2,
			bg = colors.statusline_bg,
		},
		icon = " ",
	},

	change = {
		provider = "git_diff_changed",
		hl = {
			fg = colors.grey_fg2,
			bg = colors.statusline_bg,
		},
		icon = "  ",
	},

	remove = {
		provider = "git_diff_removed",
		hl = {
			fg = colors.grey_fg2,
			bg = colors.statusline_bg,
		},
		icon = "  ",
	},
}

opt.dir_name = {
	provider = function()
		local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		return "  " .. dir_name .. " "
	end,

	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
	end,

	hl = {
		fg = colors.grey_fg2,
		bg = colors.lightbg2,
	},
	right_sep = {
		str = opt.icons.right,
		hi = {
			fg = colors.lightbg2,
			bg = colors.statusline_bg,
		},
	},
}

opt.diagnostic = {
	error = {
		provider = "diagnostic_errors",
		enabled = function()
			return opt.lsp.diagnostics_exist(opt.lsp_severity.ERROR)
		end,

		hl = { fg = colors.red },
		icon = "  ",
	},

	warning = {
		provider = "diagnostic_warnings",
		enabled = function()
			return opt.lsp.diagnostics_exist(opt.lsp_severity.WARN)
		end,
		hl = { fg = colors.yellow },
		icon = "  ",
	},

	hint = {
		provider = "diagnostic_hints",
		enabled = function()
			return opt.lsp.diagnostics_exist(opt.lsp_severity.HINT)
		end,
		hl = { fg = colors.grey_fg2 },
		icon = "  ",
	},

	info = {
		provider = "diagnostic_info",
		enabled = function()
			return opt.lsp.diagnostics_exist(opt.lsp_severity.INFO)
		end,
		hl = { fg = colors.green },
		icon = "  ",
	},
}

opt.lsp_progress = {
	provider = function()
		local Lsp = vim.lsp.util.get_progress_messages()[1]

		if Lsp then
			local msg = Lsp.message or ""
			local percentage = Lsp.percentage or 0
			local title = Lsp.title or ""
			local spinners = {
				"",
				"",
				"",
			}

			local success_icon = {
				"",
				"",
				"",
			}

			local ms = vim.loop.hrtime() / 1000000
			local frame = math.floor(ms / 120) % #spinners

			if percentage >= 70 then
				return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
			end

			return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
		end

		return ""
	end,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
	end,
	hl = { fg = colors.green },
}

opt.lsp_icon = {
	provider = function()
		if next(vim.lsp.buf_get_clients()) ~= nil then
			return "  LSP"
		else
			return ""
		end
	end,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
	end,
	hl = { fg = colors.grey_fg2, bg = colors.statusline_bg },
}

opt.git_branch = {
	provider = "git_branch",
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
	end,
	hl = {
		fg = colors.grey_fg2,
		bg = colors.statusline_bg,
	},
	icon = "  ",
}

opt.empty_space = {
	provider = " " .. opt.icons.left,
	hl = {
		fg = colors.one_bg2,
		bg = colors.statusline_bg,
	},
}

-- this matches the vi mode color
opt.empty_spaceColored = {
	provider = opt.icons.left,
	hl = function()
		return {
			fg = opt.mode_colors[vim.fn.mode()][2],
			bg = colors.one_bg2,
		}
	end,
}

opt.mode_icon = {
	provider = opt.icons.vi_mode_icon,
	hl = function()
		return {
			fg = colors.statusline_bg,
			bg = opt.mode_colors[vim.fn.mode()][2],
		}
	end,
}

opt.empty_space2 = {
	provider = function()
		return " " .. opt.mode_colors[vim.fn.mode()][1] .. " "
	end,
	hl = {
		fg = opt.mode_colors[vim.fn.mode()][2],
		bg = colors.one_bg,
	},
}

opt.separator_right = {
	provider = opt.icons.left,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
	end,
	hl = {
		fg = colors.grey,
		bg = colors.one_bg,
	},
}

opt.separator_right2 = {
	provider = opt.icons.left,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
	end,
	hl = {
		fg = colors.green,
		bg = colors.grey,
	},
}

opt.position_icon = {
	provider = opt.icons.position_icon,
	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
	end,
	hl = {
		fg = colors.black,
		bg = colors.green,
	},
}

opt.current_line = {
	provider = function()
		local current_line = vim.fn.line(".")
		local total_line = vim.fn.line("$")

		if current_line == 1 then
			return " Top "
		elseif current_line == vim.fn.line("$") then
			return " Bot "
		end
		local result, _ = math.modf((current_line / total_line) * 100)
		return " " .. result .. "%% "
	end,

	enabled = function(winid)
		return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
	end,

	hl = {
		fg = colors.green,
		bg = colors.one_bg,
	},
}

local function add_table(a, b)
	table.insert(a, b)
end

local M = {}
M.setup = function()
	-- components are divided in 3 sections
	local components = {
		active = {},
	}
	local left = {}
	local middle = {}
	local right = {}

	-- left
	add_table(left, opt.main_icon)
	add_table(left, opt.file_name)
	add_table(left, opt.dir_name)
	add_table(left, opt.diff.add)
	add_table(left, opt.diff.change)
	add_table(left, opt.diff.remove)
	add_table(left, opt.diagnostic.error)
	add_table(left, opt.diagnostic.warning)
	add_table(left, opt.diagnostic.hint)
	add_table(left, opt.diagnostic.info)

	-- middle
	add_table(middle, opt.lsp_progress)

	-- right
	--add_table(right, opt.lsp_icon)
	add_table(right, opt.git_branch)
	add_table(right, opt.empty_space)
	add_table(right, opt.empty_spaceColored)
	add_table(right, opt.mode_icon)
	add_table(right, opt.empty_space2)
	add_table(right, opt.separator_right)
	add_table(right, opt.separator_right2)
	add_table(right, opt.position_icon)
	add_table(right, opt.current_line)

	components.active[1] = left
	components.active[2] = middle
	components.active[3] = right

	feline.setup({
		theme = {
			bg = colors.statusline_bg,
			fg = colors.fg,
		},
		components = components,
	})
end

return M
