local api = require("utils.api")
local ui = require("utils.ui")

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
						icon = "󰠵  ",
						desc = "Search buffers                          ",
						action = "Telescope buffers",
						key = "b",
						keymap = "SPC b b",
					},
					{
						icon = "  ",
						desc = "Open doftile                            ",
						action = "Telescope dotfiles",
						key = "d",
						keymap = "SPC f c",
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
			api.nmap("<leader>tt", function()
				trouble.toggle()
			end, "Open default Trouble mode")
			api.nmap("<leader>tw", function()
				trouble.toggle("workspace_diagnostics")
			end, "Open workspace diagnostics in Trouble")
			api.nmap("<leader>td", function()
				trouble.toggle("document_diagnostics")
			end, "Open document diagnostics in Trouble")
			api.nmap("<leader>tq", function()
				trouble.toggle("quickfix")
			end, "Open quickfix in Trouble")
			api.nmap("<leader>tl", function()
				trouble.toggle("loclist")
			end, "Open loclist in Trouble")
			api.nmap("tr", function()
				trouble.toggle("lsp_references")
			end, "Open LSP references in Trouble")

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
			api.nmap("<leader>z", ":lua require('zen-mode').toggle()<CR>", "Toggle zen mode [zen]")

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
}
