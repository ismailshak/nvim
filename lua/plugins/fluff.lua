local ui = require("utils.ui")
local icons = require("utils.icons")
local mappings = require("custom.mappings")

return {
	-- Startup dashboard
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		opts = {
			theme = "doom",
			hide = {
				tabline = true,
				winbar = true,
				statusline = true,
			},
			preview = {
				file_height = 12,
				file_width = 80,
			},
			config = {
				header = ui.dashboard_header,
				center = {
					{
						icon = "  ",
						desc = "Load last session                       ",
						action = function()
							require("persistence").load({ last = true })
						end,
						icon_hl = "DashboardIcon",
						key = "s",
						keymap = "SPC s l",
					},
					{
						icon = "  ",
						desc = "Find file                               ",
						action = "FzfLua files",
						key = "f",
						keymap = "SPC f f",
					},
					{
						icon = "󰟵  ",
						desc = "Find word                               ",
						action = "FzfLua live_grep",
						key = "g",
						keymap = "SPC f g",
					},
					{
						icon = "  ",
						desc = "Open diff                          ",
						action = "DiffviewOpen",
						key = "d",
						keymap = "SPC d v",
					},
					{
						icon = icons.copilot.response .. "  ",
						desc = "Open copilot",
						key = "c",
						keymap = "SPC c c",
						action = "CodeCompanionChat",
					},
					{
						icon = "  ",
						desc = "Open database",
						action = "DBUIToggle",
						key = "b",
						keymap = "SPC b d",
					},
					{
						icon = "  ",
						desc = "Open doftile                            ",
						action = "Dotfiles",
						key = "o",
					},
				},
				footer = ui.gen_dashboard_footer(),
			},
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		lazy = false,
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			file_types = { "markdown", "codecompanion" },
			render_modes = true,
			completions = { blink = { enabled = true } },
			sign = {
				enabled = false,
			},
			code = {
				border = "thick",
				position = "right",
				width = "full",
				right_pad = 5,
			},
			heading = {
				icons = {
					icons.markdown.h1,
					icons.markdown.h2,
					icons.markdown.h3,
					icons.markdown.h4,
					icons.markdown.h5,
					icons.markdown.h6,
				},
				position = "inline",
			},
			overrides = {
				buftype = {
					nofile = {
						code = { language_icon = false, language_name = false, border = "thin" },
					},
				},
				filetype = {
					codecompanion = {
						code = {
							left_margin = 1,
							left_pad = 1,
							border = "thick",
							position = "left",
							width = "full",
							language_icon = true,
							language_name = true,
						},
						heading = {
							position = "inline",
							-- The chat window sets the prompt headers as h2s
							-- so I'm resetting the header levels here
							-- so that it appears like prompt headers
							-- are separated from the rest of the text
							icons = {
								"",
								"",
								icons.markdown.h1,
								icons.markdown.h2,
								icons.markdown.h3,
								icons.markdown.h4,
							},
							-- visually separating prompt headers from the
							-- rest of the text
							backgrounds = {
								"RenderMarkdownH1Bg",
								"RenderMarkdownH2Bg",
								"",
								"",
								"",
								"",
							},
						},
					},
				},
			},
		},
	},

	-- Dumb but fun buffer animations
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
		keys = "<leader>fml",
		config = function()
			mappings.cellular_automation()
		end,
	},
}
