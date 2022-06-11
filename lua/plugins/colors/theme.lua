-- this will change the selected theme
local selected_theme = "tokyonight"

local M = {}

local theme_colors = {
	nord = {
		white = "#abb2bf",
		darker_black = "#2a303c",
		black = "#2E3440", --  nvim bg
		black2 = "#343a46",
		one_bg = "#373d49",
		one_bg2 = "#464c58",
		one_bg3 = "#494f5b",
		grey = "#4b515d",
		grey_fg = "#565c68",
		grey_fg2 = "#606672",
		light_grey = "#646a76",
		red = "#BF616A",
		baby_pink = "#de878f",
		pink = "#d57780",
		line = "#414753", -- for lines like vertsplit
		green = "#A3BE8C",
		vibrant_green = "#afca98",
		blue = "#7797b7",
		nord_blue = "#81A1C1",
		yellow = "#EBCB8B",
		sun = "#e1c181",
		purple = "#B48EAD",
		dark_purple = "#a983a2",
		teal = "#6484a4",
		orange = "#e39a83",
		cyan = "#9aafe6",
		statusline_bg = "#333945",
		lightbg = "#3f4551",
		pmenu_bg = "#A3BE8C",
		folder_bg = "#7797b7",
	},
	tokyonight = {
		white = "#c0caf5",
		darker_black = "#16161e",
		black = "#1a1b26", --  nvim bg
		black2 = "#1f2336",
		one_bg = "#24283b",
		one_bg2 = "#414868",
		one_bg3 = "#353b45",
		grey = "#40486a",
		grey_fg = "#565f89",
		grey_fg2 = "#4f5779",
		light_grey = "#545c7e",
		red = "#f7768e",
		baby_pink = "#DE8C92",
		pink = "#ff75a0",
		line = "#32333e", -- for lines like vertsplit
		green = "#9ece6a",
		vibrant_green = "#73daca",
		nord_blue = "#80a8fd",
		blue = "#7aa2f7",
		yellow = "#e0af68",
		sun = "#EBCB8B",
		purple = "#bb9af7",
		dark_purple = "#9d7cd8",
		teal = "#1abc9c",
		orange = "#ff9e64",
		cyan = "#7dcfff",
		statusline_bg = "#1d1e29",
		lightbg = "#32333e",
		pmenu_bg = "#7aa2f7",
		folder_bg = "#7aa2f7",
	},
}

M.colors = theme_colors[selected_theme]

M.get_theme = function()
	return selected_theme
end

return M
