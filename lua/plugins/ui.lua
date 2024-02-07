local mappings = require("custom.mappings")
local api = require("utils.api")
local utils = require("utils.helpers")
local ui = require("utils.ui")

return {
	-- All the dev icons that render
	{
		"nvim-tree/nvim-web-devicons",
		priority = 1000,
		lazy = false,
		opts = {
			-- https://github.com/nvim-tree/nvim-web-devicons/blob/defb7da4d3d313bf31982c52fd78e414f02840c9/lua/nvim-web-devicons-light.lua
			override_by_extension = ui.get_ft_icon_overrides(),
		},
	},

	-- Fancier statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		opts = function()
			local branch_color = vim.api.nvim_get_hl(0, { name = "String" })
			branch_color.fg = ui.convert_decimal_color(branch_color.fg)

			return {
				options = {
					globalstatus = true,
					icons_enabled = true,
					theme = "auto",
					component_separators = "|",
					section_separators = "",
					disabled_filetypes = {
						statusline = { "dashboard" },
						winbar = {},
						DiffviewFiles = {},
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { ui.build_dir_name_icon },
					lualine_c = { { "filename", path = 1 }, ui.build_diff_opts() },
					lualine_x = { "diagnostics", "searchcount", "filetype" },
					lualine_y = { { "branch", icon = { "", align = "left", color = branch_color } } },
					lualine_z = { { "location", fmt = utils.trim } },
				},
			}
		end,
	},

	-- Add indentation guides even on blank lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		opts = {
			filetype_exclude = { "dashboard" },
			show_current_context = false,
			show_current_context_start = false,
		},
	},

	-- Context breadcrumbs at the top of the window
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			show_dirname = false,
			show_modified = true,
			exclude_filetypes = { "dashboard", "Trouble", "NvimTree", "Fterm" },
		},
	},

	-- Useful UI for LSP progress
	{
		"j-hui/fidget.nvim",
		lazy = false,

		opts = {
			progress = {
				display = {
					done_icon = "",
					done_style = "TSKeyword",
					group_style = "Type",
					progress_style = "Comment",
				},
			},
			notification = {
				override_vim_notify = true,
				configs = {
					default = utils.merge_tables(require("fidget.notification").default_config, {
						name = "",
						icon = "",
					}),
				},
				view = {
					group_separator = "",
				},
			},
		},
	},

	-- Hook into dark/light mode toggle
	{
		"f-person/auto-dark-mode.nvim",
		event = "VimEnter",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				api.set_bg("dark")
			end,
			set_light_mode = function()
				api.set_bg("light")
			end,
		},
	},

	-- Folds
	-- (this plugin's setup is called by lsp's setup)
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			mappings.ufo()
		end,
	},

	{
		-- Terminal
		"numToStr/FTerm.nvim",
		keys = { "<c-\\>", { "c-\\", mode = "t" } },
		config = function()
			mappings.fterm()

			require("FTerm").setup({
				---Filetype of the terminal buffer
				---@type string
				ft = "Fterm",

				---Command to run inside the terminal
				---NOTE: if given string[], it will skip the shell and directly executes the command
				---@type fun():(string|string[])|string|string[]
				cmd = os.getenv("SHELL"),

				---Neovim's native window border. See `:h nvim_open_win` for more configuration options.
				border = "rounded",

				---Close the terminal as soon as shell/command exits.
				---Disabling this will mimic the native terminal behaviour.
				---@type boolean
				auto_close = true,

				---Highlight group for the terminal. See `:h winhl`
				---@type string
				hl = "Normal",

				---Transparency of the floating window. See `:h winblend`
				---@type integer
				blend = 0,

				---Object containing the terminal window dimensions.
				---The value for each field should be between `0` and `1`
				---@type table<string,number>
				dimensions = {
					height = 0.8, -- Height of the terminal window
					width = 0.8, -- Width of the terminal window
					x = 0.5, -- X axis of the terminal window
					y = 0.5, -- Y axis of the terminal window
				},

				---Callback invoked when the terminal exits.
				---See `:h jobstart-options`
				---@type fun()|nil
				on_exit = nil,

				---Callback invoked when the terminal emits stdout data.
				---See `:h jobstart-options`
				---@type fun()|nil
				on_stdout = nil,

				---Callback invoked when the terminal emits stderr data.
				---See `:h jobstart-options`
				---@type fun()|nil
				on_stderr = nil,
			})
		end,
	},

	-- Prettier navite UI elements
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			input = {
				-- Set to false to disable the vim.ui.input implementation
				enabled = true,

				-- Default prompt string
				default_prompt = "Input:",

				-- Can be 'left', 'right', or 'center'
				prompt_align = "left",

				-- When true, <Esc> will close the modal
				insert_only = true,

				-- When true, input will start in insert mode.
				start_in_insert = true,

				-- These are passed to nvim_open_win
				anchor = "SW",
				border = "rounded",
				-- 'editor' and 'win' will default to being centered
				relative = "cursor",

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				prefer_width = 40,
				width = nil,
				-- min_width and max_width can be a list of mixed types.
				-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
				max_width = { 140, 0.9 },
				min_width = { 20, 0.2 },

				win_options = {
					-- Window transparency (0-100)
					winblend = 10,
					-- Change default highlight groups (see :help winhl)
					winhighlight = "",
				},

				-- Set to `false` to disable
				mappings = {
					n = {
						["<Esc>"] = "Close",
						["<CR>"] = "Confirm",
					},
					i = {
						["<C-c>"] = "Close",
						["<CR>"] = "Confirm",
						["<Up>"] = "HistoryPrev",
						["<Down>"] = "HistoryNext",
					},
				},

				override = function(conf)
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					return conf
				end,

				-- see :help dressing_get_config
				get_config = nil,
			},
			select = {
				-- Set to false to disable the vim.ui.select implementation
				enabled = true,

				-- Priority list of preferred vim.select implementations
				backend = { "telescope", "builtin", "fzf_lua", "fzf", "nui" },

				-- Trim trailing `:` from prompt
				trim_prompt = true,

				-- Options for telescope selector
				-- These are passed into the telescope picker directly. Can be used like:
				-- telescope = require('telescope.themes').get_ivy({...})
				-- telescope = require("telescope.themes").get_cursor({}),

				-- Options for fzf selector
				fzf = {
					window = {
						width = 0.5,
						height = 0.4,
					},
				},

				-- Options for fzf_lua selector
				fzf_lua = {
					winopts = {
						width = 0.5,
						height = 0.4,
					},
				},

				-- Options for nui Menu
				nui = {
					position = "50%",
					size = nil,
					relative = "editor",
					border = {
						style = "rounded",
					},
					buf_options = {
						swapfile = false,
						filetype = "DressingSelect",
					},
					win_options = {
						winblend = 10,
					},
					max_width = 80,
					max_height = 40,
					min_width = 40,
					min_height = 10,
				},

				-- Options for built-in selector
				builtin = {
					-- These are passed to nvim_open_win
					anchor = "NW",
					border = "rounded",
					-- 'editor' and 'win' will default to being centered
					relative = "cursor",

					win_options = {
						-- Window transparency (0-100)
						winblend = 10,
						-- Change default highlight groups (see :help winhl)
						winhighlight = "",
					},

					-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					-- the min_ and max_ options can be a list of mixed types.
					-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
					width = nil,
					max_width = { 140, 0.8 },
					min_width = { 40, 0.2 },
					height = nil,
					max_height = 0.9,
					min_height = { 10, 0.2 },

					-- Set to `false` to disable
					mappings = {
						["q"] = "Close",
						["<Esc>"] = "Close",
						["<C-c>"] = "Close",
						["<CR>"] = "Confirm",
					},

					override = function(conf)
						-- This is the config that will be passed to nvim_open_win.
						-- Change values here to customize the layout
						return conf
					end,
				},

				-- Used to override format_item. See :help dressing-format
				format_item_override = {},

				-- see :help dressing_get_config
				get_config = nil,
			},
		},
	},

	-- Better diff view
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewLog",
			"DiffviewFileHistory",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
		},
		keys = {
			{ "<leader>dv" },
			{ "<leader>df" },
		},
		config = function()
			mappings.diffview()

			local actions = require("diffview.actions")

			require("diffview").setup({
				diff_binaries = false, -- Show diffs for binaries
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				use_icons = true, -- Requires nvim-web-devicons
				icons = { -- Only applies when use_icons is true.
					folder_closed = "",
					folder_open = "",
				},
				signs = {
					fold_closed = "",
					fold_open = "",
				},
				view = {
					-- Configure the layout and behavior of different types of views.
					-- Available layouts:
					--  'diff1_plain'
					--    |'diff2_horizontal'
					--    |'diff2_vertical'
					--    |'diff3_horizontal'
					--    |'diff3_vertical'
					--    |'diff3_mixed'
					--    |'diff4_mixed'
					-- For more info, see ':h diffview-config-view.x.layout'.
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						layout = "diff3_mixed",
					},
				},
				file_panel = {
					listing_style = "tree", -- One of 'list' or 'tree'
					tree_options = { -- Only applies when listing_style is 'tree'
						flatten_dirs = true, -- Flatten dirs that only contain one single dir
						folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
					},
					win_config = { -- See ':h diffview-config-win_config'
						position = "right",
						width = 30,
					},
				},
				file_history_panel = {
					log_options = { -- See ':h diffview-config-log_options'
						git = {
							single_file = {
								diff_merges = "combined",
							},
							multi_file = {
								diff_merges = "first-parent",
							},
						},
					},
					win_config = { -- See ':h diffview-config-win_config'
						position = "bottom",
						height = 16,
					},
				},
				commit_log_panel = {
					win_config = {}, -- See ':h diffview-config-win_config'
				},
				default_args = { -- Default args prepended to the arg-list for the listed commands
					DiffviewOpen = {},
					DiffviewFileHistory = {},
				},
				hooks = {}, -- See ':h diffview-config-hooks'
				keymaps = {
					disable_defaults = false, -- Disable the default keymaps
				},
			})
		end,
	},

	{
		"kyazdani42/nvim-tree.lua",
		cmd = "NvimTreeFindFileToggle",
		keys = "<C-n>",
		config = function()
			mappings.nvim_tree()

			-- each of these are documented in `:help nvim-tree.OPTION_NAME`
			-- nested options are documented by accessing them with `.` (eg: `:help nvim-tree.view.mappings.list`).
			require("nvim-tree").setup({
				auto_reload_on_write = true,
				create_in_closed_folder = false,
				disable_netrw = false,
				hijack_cursor = false,
				hijack_netrw = true,
				hijack_unnamed_buffer_when_opening = false,
				open_on_tab = false,
				sort_by = "name",
				update_cwd = false,
				reload_on_bufenter = false,
				respect_buf_cwd = false,
				view = {
					adaptive_size = false,
					centralize_selection = false,
					width = {
						min = 30,
						max = 40,
						padding = 1,
					},
					-- height = 30,
					hide_root_folder = false,
					side = "right",
					preserve_window_proportions = false,
					number = false,
					relativenumber = false,
					signcolumn = "yes",
					mappings = {
						custom_only = false,
						list = {
							-- user mappings go here
						},
					},
				},
				renderer = {
					add_trailing = false,
					group_empty = false,
					highlight_git = false,
					full_name = false,
					highlight_opened_files = "none",
					root_folder_modifier = ":~",
					indent_markers = {
						enable = false,
						icons = {
							corner = "└ ",
							edge = "│ ",
							item = "│ ",
							none = "  ",
						},
					},
					icons = {
						webdev_colors = true,
						git_placement = "after",
						padding = " ",
						symlink_arrow = " ➛ ",
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								-- unstaged = "✗",
								unstaged = "",
								-- staged = "✓",
								staged = "󰄬",
								unmerged = "",
								renamed = "➜",
								untracked = "+",
								deleted = "",
								ignored = "◌",
							},
						},
					},
					special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
				},
				hijack_directories = {
					enable = true,
					auto_open = true,
				},
				update_focused_file = {
					enable = false,
					update_cwd = false,
					ignore_list = {},
				},
				system_open = {
					cmd = "",
					args = {},
				},
				diagnostics = {
					enable = false,
					show_on_dirs = false,
					icons = {
						hint = "",
						info = "",
						warning = "",
						error = "",
					},
				},
				filters = {
					dotfiles = false,
					custom = {},
					exclude = {},
				},
				git = {
					enable = true,
					ignore = false,
					timeout = 400,
				},
				actions = {
					use_system_clipboard = true,
					change_dir = {
						enable = true,
						global = false,
						restrict_above_cwd = false,
					},
					expand_all = {
						max_folder_discovery = 300,
					},
					file_popup = {
						open_win_config = {
							col = 1,
							row = 1,
							relative = "cursor",
							border = "rounded",
							style = "minimal",
						},
					},
					open_file = {
						quit_on_open = true,
						resize_window = true,
						window_picker = {
							enable = true,
							chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
							exclude = {
								filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
								buftype = { "nofile", "terminal", "help" },
							},
						},
					},
					remove_file = {
						close_window = true,
					},
				},
				trash = {
					cmd = "gio trash",
					require_confirm = true,
				},
				live_filter = {
					prefix = "[FILTER]: ",
					always_show_folders = true,
				},
				log = {
					enable = false,
					truncate = false,
					types = {
						all = false,
						config = false,
						copy_paste = false,
						diagnostics = false,
						git = false,
						profile = false,
						watcher = false,
					},
				},
			})
		end,
	},
}
