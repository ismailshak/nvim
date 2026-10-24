local mappings = require("custom.mappings")
local api = require("utils.api")
local utils = require("utils.helpers")
local icons = require("utils.icons")
local ui = require("utils.ui")

local ignore_list = {
	"*.bundle.js",
	"*.bundle.js.map",
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
	"public",
	"report",
	"target",
	"*.tsbuildinfo",
}

return {
	-- All the dev icons that render
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy", -- Not needed right away though
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
					lualine_c = { { "filename", path = 1, shorting_target = 100 } },
					lualine_x = { "diagnostics", ui.build_diff_opts(), "searchcount", "filetype" },
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
		event = "VeryLazy",
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
		event = "BufReadPost",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			show_dirname = false,
			show_modified = true,
			-- codediff shows files read from git in "nowrite" buffers
			include_buftypes = { "", "nowrite" },
			exclude_filetypes = { "dashboard", "Trouble", "NvimTree", "term" },
			-- The revision of a file codediff read from git, at the right end of the winbar
			custom_section = function(bufnr)
				local revision = require("utils.tools.codediff").revision(bufnr)
				return revision and { { revision .. " ", "barbecue_dirname" } } or " "
			end,
		},
	},

	-- Useful UI for LSP progress
	{
		"j-hui/fidget.nvim",
		lazy = false,
		opts = function()
			return {
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
			}
		end,
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

	-- Prettier navite UI elements
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Better diff view
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		keys = {
			{ "<leader>dv" },
			{ "<leader>df" },
		},
		config = function()
			mappings.codediff()

			require("codediff").setup({
				diff = {
					highlight_added_deleted_files = true,
					compact = true,
					compact_context_lines = 15,
				},
				explorer = {
					width = 30,
					view_mode = "tree",
				},
				history = {
					height = 16,
				},
				keymaps = {
					view = {
						next_file = "<Tab>",
						prev_file = "<S-Tab>",
					},
				},
			})
			require("utils.tools.codediff").setup_winbars()
		end,
	},

	-- Adds LSP rename handlers to nvim-tree
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Highlight colors in the buffer
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		opts = {
			render = "virtual",
			virtual_symbol = "󱓻",
			virtual_symbol_prefix = "",
			virtual_symbol_suffix = " ",
			virtual_symbol_position = "inline",
			enable_named_colors = true,
			enable_tailwind = true,
			exclude_filetypes = { "lazy" },
			exclude_buftypes = {},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		keys = "<C-n>",
		config = function()
			mappings.nvim_tree()

			require("nvim-tree").setup({
				view = {
					width = { min = 30, max = 40, padding = 1 },
					side = "right",
					preserve_window_proportions = true,
				},
				renderer = {
					root_folder_label = ":~",
					icons = {
						git_placement = "after",
						glyphs = {
							git = icons.tree.git,
						},
					},
				},
				filters = { git_ignored = false },
				actions = {
					file_popup = { open_win_config = { border = "rounded" } },
					open_file = {
						quit_on_open = true,
						window_picker = {
							exclude = { filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" } },
						},
					},
				},
			})

			require("lsp-file-operations").setup()
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
			"<leader>rr",
			"<leader>fd",
			"<leader>fg",
			"<leader>fh",
			"<leader>bb",
			"<leader>?",
			"<leader>fc",
			"<leader>sc",
			"<leader>gb",
			"<leader>gc",
			"<leader>gt",
			"<leader>th",
		},
		cmd = "FzfLua",
		config = function()
			mappings.fzf()

			local fd_opts = "--color=never --type f --no-ignore --hidden --follow"
			local rg_opts =
				"--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --follow"

			for _, dir in ipairs(ignore_list) do
				fd_opts = fd_opts .. " --exclude " .. dir
				rg_opts = rg_opts .. " -g '!" .. dir .. "'"
			end

			require("fzf-lua").setup({
				"borderless-full",
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
					fd_opts = fd_opts,
					actions = {
						["ctrl-g"] = false,
					},
				},
				grep = {
					prompt = icons.pickers.search .. "  ",
					formatter = "path.filename_first",
					header = "\t",
					rg_opts = rg_opts,
				},
				winopts = {
					preview = {
						layout = "vertical",
						vertical = "down:60%",
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
