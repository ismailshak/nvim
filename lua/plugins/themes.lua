return {
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			light_style = "day", -- The theme is used when the background is set to light
			sidebars = { "qf", "help", "terminal", "NvimTree" }, -- Set a darker background on sidebar-like windows.
			day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = false },
				keywords = { italic = false },
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "mocha",
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		opts = {
			variant = "main",
			disable_italics = true,
			highlight_groups = {
				["@constant.builtin"] = { fg = "pine" },
				["@function.builtin"] = { fg = "pine" },
				["@variable.builtin"] = { fg = "pine" },
			},
		},
	},
	{ "EdenEast/nightfox.nvim" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "kvrohit/substrata.nvim" },
}
