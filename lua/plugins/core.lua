local mappings = require("custom.mappings")
local icons = require("utils.icons")
local lsp_utils = require("utils.lsp")

--
-- Core functionality
--

return {
	-- Configures lua_ls to support neovim config/plugin development
	"folke/neodev.nvim",

	-- Formatting, linting, and code actions
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Bridge to auto install via Mason
			"jayp0521/mason-null-ls.nvim",
		},
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"nvimtools/none-ls.nvim",
			"hrsh7th/nvim-cmp",
			"j-hui/fidget.nvim",
		},
		config = function()
			lsp_utils.setup_neodev()
			lsp_utils.configure_diagnostics()
			lsp_utils.configure_floating_window()
			lsp_utils.configure_mason()
			lsp_utils.configure_cmp()
			lsp_utils.setup_lsps()
			lsp_utils.setup_null_ls()
		end,
	},

	-- Save sessions
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			log_level = "error",
			auto_restore_enabled = false, -- Use dashboard or keymap to restore
			auto_session_suppress_dirs = { "~/" },
			bypass_session_save_file_types = { "dashboard" }, -- Don't overwrite session when these file types are focused
		},
	},

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = icons.gutter.added },
					change = { text = icons.gutter.changed },
					delete = { text = icons.gutter.deleted },
					topdelete = { text = icons.gutter.topdelete },
					changedelete = { text = icons.gutter.changedelete },
					untracked = { text = icons.gutter.untracked },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 500,
					ignore_whitespace = false,
				},
				--current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000,
				preview_config = {
					-- Options passed to nvim_open_win
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				yadm = {
					enable = false,
				},
				on_attach = function(bufnr)
					mappings.gitsigns(bufnr)
				end,
			})
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"html",
					"css",
					"javascript",
					"typescript",
					"jsdoc",
					"tsx",
					"markdown",
					"markdown_inline",
					"json",
					"yaml",
					"go",
					"gomod",
					"dockerfile",
					"python",
					"bash",
					"regex",
					"rust",
					"vim",
					"vimdoc", -- https://github.com/nvim-treesitter/nvim-treesitter/issues/2293#issuecomment-1492982270
				},
				highlight = {
					enable = true,
					use_languagetree = true,
				},
				indent = {
					enable = true,
				},
				-- autotag is enabled by https://github.com/windwp/nvim-ts-autotag
				autotag = {
					enable = true,
				},
				-- smart comments are enabled by JoosepAlviste/nvim-ts-context-commentstring
				-- (and integrated with numToStr/Comment.nvim )
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							["aa"] = { query = "@parameter.outer", desc = "Select around parameter" },
							["ia"] = { query = "@parameter.inner", desc = "Select inside parameter" },
							["af"] = { query = "@function.outer", desc = "Select around function" },
							["if"] = { query = "@function.inner", desc = "Select inside function" },
							["ac"] = { query = "@class.outer", desc = "Select around class" },
							["ic"] = { query = "@class.inner", desc = "Select inside class" },
							["ai"] = { query = "@conditional.outer", desc = "Select around conditional" },
							["ii"] = { query = "@conditional.inner", desc = "Select inside conditional" },
							["al"] = { query = "@loop.outer", desc = "Select around loop" },
							["il"] = { query = "@loop.inner", desc = "Select inside loop" },
							["ab"] = { query = "@block.outer", desc = "Select around block" },
							["ib"] = { query = "@block.inner", desc = "Select inside block" },
							["am"] = { query = "@call.outer", desc = "Select around method" },
							["im"] = { query = "@call.inner", desc = "Select inside method" },
							["as"] = { query = "@statement.outer", desc = "Select around statement" },
							["is"] = { query = "@statement.inner", desc = "Select inside statement" },
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- Whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = { query = "@function.outer", desc = "Move to the next function" },
							["]]"] = { query = "@class.outer", desc = "Move to the next class" },
							["]a"] = { query = "@parameter.outer", desc = "Move to the next parameter" },
							["]f"] = { query = "@call.outer", desc = "Move to the next method" },
							["]i"] = { query = "@conditional.outer", desc = "Move to the next conditional" },
							["]l"] = { query = "@loop.outer", desc = "Move to the next loop" },
							["]b"] = { query = "@block.outer", desc = "Move to the next block" },
							["]s"] = { query = "@statement.outer", desc = "Move to the next statement" },
						},
						goto_previous_start = {
							["[m"] = { query = "@function.outer", desc = "Move to the previous function" },
							["[["] = { query = "@class.outer", desc = "Move to the previous class" },
							["[a"] = { query = "@parameter.outer", desc = "Move to the previous parameter" },
							["[f"] = { query = "@call.outer", desc = "Move to the previous method" },
							["[i"] = "@conditional.outer",
							["[l"] = { query = "@loop.outer", desc = "Move to the previous loop" },
							["[b"] = { query = "@block.outer", desc = "Move to the previous block" },
							["[s"] = { query = "@statement.outer", desc = "Move to the previous statement" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sa"] = { query = "@parameter.inner", desc = "Swap current parameter with next" },
						},
						swap_previous = {
							["<leader>sA"] = {
								query = "@parameter.inner",
								desc = "Swap current parameter with previous",
							},
						},
					},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-Space>",
						node_incremental = "<C-Space>",
						scope_incremental = false,
						node_decremental = "<BS>",
					},
				},
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},
			})
		end,
	},
}
