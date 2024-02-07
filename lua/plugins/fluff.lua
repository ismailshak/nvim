local ui = require("utils.ui")
local mappings = require("custom.mappings")

return {
	-- Startup dashboard
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
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
						action = "RestoreSession",
						icon_hl = "DashboardIcon",
						key = "s",
						keymap = "SPC s l",
					},
					{
						icon = "  ",
						desc = "Find file                               ",
						action = "lua require('fzf-lua').files()",
						key = "f",
						keymap = "SPC f f",
					},
					{
						icon = "󰟵  ",
						desc = "Find word                               ",
						action = "Telescope live_grep",
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
						icon = "  ",
						desc = "Open doftile                            ",
						action = "Telescope dotfiles",
						key = "o",
					},
				},
				footer = ui.gen_dashboard_footer(),
			},
		},
	},

	-- Prettier quickfix
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local trouble = require("trouble")
			mappings.trouble()

			trouble.setup({
				severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
				padding = false, -- add an extra new line on top of the list
				action_keys = { -- key mappings for actions in the trouble list
					-- map to {} to remove a mapping, for example:
					-- close = {},
				},
				indent_lines = false, -- adds an indent guide below the fold icons
				use_diagnostic_signs = true, -- enabling this uses the signs defined in the lsp client
			})
		end,
	},

	-- Center buffer and minimize screen noise
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = "<leader>z",
		config = function()
			mappings.zen_mode()

			require("zen-mode").setup({
				window = {
					backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
					-- height and width can be:
					-- * an absolute number of cells when > 1
					-- * a percentage of the width / height of the editor when <= 1
					-- * a function that returns the width or the height
					width = 120, -- width of the Zen window
					height = 1, -- height of the Zen window
					-- by default, no options are changed for the Zen window
					-- uncomment any of the options below, or add other vim.wo options you want to apply
					options = {
						-- signcolumn = "no", -- disable signcolumn
						-- number = false, -- disable number column
						-- relativenumber = false, -- disable relative numbers
						-- cursorline = false, -- disable cursorline
						-- cursorcolumn = false, -- disable cursor column
						-- foldcolumn = "0", -- disable fold column
						-- list = false, -- disable whitespace characters
					},
				},
			})
		end,
	},

	-- Prettier UI for certain things
	-- (syntax highlighting in hover docs)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = { enabled = false },
			messages = { enabled = false },
			popupmenu = { enabled = false },
			notify = { enabled = false },
			lsp = {
				progress = { enabled = false },
				override = {
					-- override the default lsp markdown formatter with Noice
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					-- override the lsp markdown formatter with Noice
					["vim.lsp.util.stylize_markdown"] = false,
					-- override cmp documentation with Noice (needs the other options to work)
					["cmp.entry.get_documentation"] = false,
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
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
				},
				message = { enabled = false },
				-- defaults for hover and signature help
				documentation = {
					view = "hover",
					---@type NoiceViewOptions
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						border = "single",
					},
				},
			},
			presets = {
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
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
