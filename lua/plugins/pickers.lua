local mappings = require("custom.mappings")
local icons = require("utils.icons")

return {
	-- File picker
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			"<leader>ff",
			"<leader>fo",
		},
		config = function()
			mappings.fzf()

			local ignore_list = { ".git", "node_modules", "dist", ".next", "target", "build", "out", "_build", "_opam" }

			local gen_ignore_list = function()
				local args = ""
				for _, dir in ipairs(ignore_list) do
					args = args .. " --exclude " .. dir
				end

				return args
			end

			require("fzf-lua").setup({
				"borderless_full",
				files = {
					prompt = icons.pickers.search .. "  ",
					cwd_prompt = false,
					git_icons = true,
					file_icons = true,
					color_icons = true,
					fd_opts = "--no-ignore --color=never --type f --hidden --follow" .. gen_ignore_list(),
					fzf_opts = {
						["--no-bold"] = "",
						["--margin"] = "1,0",
						["--header"] = "\t",
						["--info"] = "inline-right",
						["--no-separator"] = "",
					},
				},
				winopts = {
					preview = {
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
				},
				fzf_colors = {
					["gutter"] = { "bg", "TelescopePromptNormal" },
					["bg"] = { "bg", "TelescopePromptNormal" },
					["prompt"] = { "fg", "TelescopePromptNormal" },
					["pointer"] = { "fg", "TelescopePromptNormal" },
					["info"] = { "fg", "Comment" },
				},
			})
		end,
	},

	-- Everything else picker
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			mappings.telescope()

			telescope.setup({
				defaults = {
					prompt_prefix = icons.pickers.search .. "  ",
					selection_caret = " ",
					entry_prefix = " ",
					path_display = { "smart" },
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					file_ignore_patterns = { "node_modules", ".git", "dist", ".next", "target", "build" },
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					-- path_display = { "truncate" },
					border = {},
					color_devicons = true,
					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,

							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,

							["<C-c>"] = actions.close,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,

							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.complete_tag,
							["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
						},

						n = {
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["gg"] = actions.move_to_top,
							["G"] = actions.move_to_bottom,

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["?"] = actions.which_key,
						},
					},
				},
				pickers = {
					-- Default configuration for builtin pickers goes here:
					-- picker_name = {
					--   picker_config_key = value,
					--   ...
					-- }
					-- Now the picker_config_key will be applied every time you call this
					-- builtin picker
					--find_files = {
					--	hidden = true, -- enable finding dot files
					--}
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					media_files = {
						-- filetypes whitelist
						-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
						filetypes = { "png", "webp", "jpg", "jpeg", "pdf" },
						find_cmd = "rg", -- find command (defaults to `fd`)
					},
					dotfiles = {
						theme = "ivy",
						layout_strategy = "horizontal",
						layout_config = {
							width = 0.40,
							height = 0.50,
						},
					},
				},
			})

			require("telescope").load_extension("dotfiles") -- this is my custom thing
		end,
	},
}
