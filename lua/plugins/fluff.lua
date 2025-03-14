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
						action = function()
							require("CopilotChat").toggle({
								window = {
									layout = "float",
									title = "",
									width = 0.8,
									height = 0.8,
									border = "rounded",
								},
							})
						end,
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

	-- Prettier UI for certain things
	-- (syntax highlighting in hover docs)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		tag = "v4.4.7",
		opts = {
			cmdline = { enabled = false },
			messages = { enabled = false },
			popupmenu = { enabled = false },
			notify = { enabled = false },
			lsp = {
				progress = { enabled = false },
				override = {
					-- override the default lsp markdown formatter with Noice
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					-- override the lsp markdown formatter with Noice
					["vim.lsp.util.stylize_markdown"] = true,
					-- override cmp documentation with Noice (needs the other options to work)
					-- ["cmp.entry.get_documentation"] = true, -- TODO: Look into blink.cmp integration later
				},
				hover = {
					enabled = true,
					silent = false, -- set to true to not show a message if hover is not available
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
						luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
					view = nil, -- when nil, use defaults from documentation
					opts = {}, -- merged with defaults from documentation
				},
				message = { enabled = false },
				-- defaults for hover and signature help
				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						border = "single",
					},
				},
			},
			views = {
				hover = {
					size = {
						max_width = 80,
					},
				},
			},
			presets = {
				lsp_doc_border = true, -- add a border to hover docs and signature help
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
