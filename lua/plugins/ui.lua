local mappings = require("custom.mappings")
local api = require("utils.api")
local utils = require("utils.helpers")
local icons = require("utils.icons")
local ui = require("utils.ui")

local ignore_list = {
	".git",
	".next",
	".nx",
	"_build",
	"_opam",
	"build",
	"coverage",
	"dist",
	"node_modules",
	"out",
	"target",
}

return {
	-- All the dev icons that render
	{
		"nvim-tree/nvim-web-devicons",
		priority = 1000,
		lazy = false,
		opts = {
			override_by_extension = ui.get_ft_icon_overrides(),
		},
	},

	-- Fancier statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		opts = function()
			local branch_color = api.get_highlight("String")

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
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { ui.build_dir_name_icon },
					lualine_c = { { "filename", path = 1, shorting_target = 100 }, ui.build_diff_opts() },
					lualine_x = { "diagnostics", "searchcount", "filetype" },
					lualine_y = { { "branch", icon = { "", align = "left", color = branch_color } } },
					lualine_z = { { "location", fmt = utils.trim } },
				},
			}
		end,
		config = function(_, opts)
			local iceberg = require("lualine.themes.iceberg_dark")
			-- Change the normal fg because they made it "vibrant"
			-- https://github.com/nvim-lualine/lualine.nvim/pull/1162
			iceberg.normal.c.fg = "#6b7089"
			require("lualine").setup(opts)
		end,
	},

	-- Add indentation guides even on blank lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			exclude = { filetypes = { "dashboard" } },
			indent = { char = "│" },
			scope = { enabled = false },
		},
	},

	-- Context breadcrumbs at the top of the window
	{
		"ismailshak/barbecue.nvim",
		name = "barbecue",
		branch = "cherry-picked", -- Combines 2 open PRs on upstream
		event = "VeryLazy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			show_dirname = false,
			show_modified = true,
			exclude_filetypes = { "dashboard", "Trouble", "NvimTree", "toggleterm", "term" },
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
		enabled = api.get_os() == "macos",
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
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "VimEnter",
		config = function(_, opts)
			require("ufo").setup(opts)
			mappings.ufo()
		end,
	},

	{
		-- Terminal
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = { "<c-\\>", { "c-\\", mode = "t" } },
		cmd = "ToggleTerm",
		opts = {
			shade_terminals = false,
			highlights = {
				FloatBorder = {
					link = "FloatBorder",
				},
			},
			float_opts = {
				border = "rounded",
				width = math.floor(vim.o.columns * 0.8),
				height = math.floor(vim.o.lines * 0.8),
			},
			winbar = {
				enabled = false,
			},
		},
		config = function(_, opts)
			mappings.toggleterm()
			require("toggleterm").setup(opts)
		end,
	},

	-- Prettier navite UI elements
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Review PRs in Neovim
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "petertriho/cmp-git", opts = {} }, -- Mainly for user and PR number auto complete
		},
		opts = {},
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

	-- Adds LSP rename handlers to nvim-tree
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
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
					side = "right",
					preserve_window_proportions = true,
					number = false,
					relativenumber = false,
					signcolumn = "yes",
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

	-- Picker
	-- File picker
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			"<leader>ff",
			"<leader>fo",
			"<leader>fd",
			"<leader>fg",
			"<leader>fh",
			"<leader>bb",
			"<leader>?",
			"<leader>fc",
			"<leader>sc",
		},
		cmd = "FzfLua",
		config = function()
			mappings.fzf()

			local fd_flags = ""
			local rg_flags = "--no-ignore --hidden"

			for _, dir in ipairs(ignore_list) do
				fd_flags = fd_flags .. " --exclude " .. dir
				rg_flags = rg_flags .. " --glob '!" .. dir .. "'"
			end

			require("fzf-lua").setup({
				"borderless_full",
				fzf_opts = {
					["--no-bold"] = "",
					["--margin"] = "1,0",
					["--info"] = "inline-right",
					["--no-separator"] = "",
					["--header"] = "\t",
				},
				files = {
					prompt = icons.pickers.search .. "  ",
					cwd_prompt = false,
					git_icons = true,
					file_icons = true,
					color_icons = true,
					formatter = "path.filename_first",
					fd_opts = require("fzf-lua").defaults.files.fd_opts .. fd_flags,
					actions = {
						["ctrl-g"] = false,
					},
				},
				grep = {
					prompt = icons.pickers.search .. "  ",
					formatter = "path.filename_first",
					header = "\t",
					rg_opts = rg_flags .. require("fzf-lua.defaults").defaults.grep.rg_opts,
				},
				winopts = {
					preview = {
						layout = "vertical",
						winopts = {
							number = false,
						},
					},
				},
				hls = {
					preview_border = "TelescopePreviewBorder",
					preview_normal = "TelescopePreviewNormal",
					normal = "TelescopePromptNormal",
					border = "TelescopePromptNormal",
					title = "TelescopePromptNormal",
					header_text = "TelescopePromptNormal",
				},
				fzf_colors = {
					["gutter"] = { "bg", "TelescopePromptNormal" },
					["bg"] = { "bg", "TelescopePromptNormal" },
					["prompt"] = { "fg", "TelescopePromptNormal" },
					["pointer"] = { "fg", "TelescopePromptNormal" },
					["info"] = { "fg", "Comment" },
					["bg+"] = { "bg", "Visual" },
					["fg+"] = { "fg", "Normal" },
					["hl+"] = { "fg", "Question" },
				},
			})
		end,
	},
}
