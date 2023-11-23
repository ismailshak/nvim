local api = require("utils.api")
local lsp_utils = require("utils.lsp")

--
-- Core functionality
--

return {
	-- Configures lua_ls to support neovim config/plugin development
	{ "folke/neodev.nvim", opts = {} },

	-- Formatting, linting, and code actions
	{
		"jose-elias-alvarez/null-ls.nvim",
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
			"jose-elias-alvarez/null-ls.nvim",
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
					add = { text = "|" },
					change = { text = "|" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┃" },
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
					local gs = package.loaded.gitsigns
					local default_opts = { buffer = bufnr }

					-- Navigation
					api.nmap("]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, "Navigate to next hunk [gitsigns]", { expr = true, buffer = bufnr })

					api.nmap("[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, "Navigate to previous hunk [gitsigns]", { expr = true, buffer = bufnr })

					-- Actions
					api.map(
						{ "n", "v" },
						"<leader>hs",
						":Gitsigns stage_hunk<CR>",
						"Stage hunk under cursor [gitsigns]",
						default_opts
					)
					api.map(
						{ "n", "v" },
						"<leader>hr",
						":Gitsigns reset_hunk<CR>",
						"Reset hunk under cursor [gitsigns]",
						default_opts
					)
					api.nmap("<leader>hS", gs.stage_buffer, "Stage the current buffer [gitsigns]", default_opts)
					api.nmap("<leader>hu", gs.undo_stage_hunk, "Undo staging of hunk [gitsigns]", default_opts)
					api.nmap("<leader>hR", gs.reset_buffer, "Reset the current buffer [gitsigns]", default_opts)
					api.nmap("<leader>hP", gs.preview_hunk, "Previw hunk under cursor [gitsigns]", default_opts)
					api.nmap(
						"<leader>hp",
						gs.preview_hunk_inline,
						"Inline previw hunk under cursor [gitsigns]",
						default_opts
					)
					api.nmap("<leader>hb", function()
						gs.blame_line({ full = true })
					end, "Show blame for line under cursor [gitsigns]", default_opts)
					api.nmap(
						"<leader>tb",
						gs.toggle_current_line_blame,
						"Toggle blame for current line [gitsigns]",
						default_opts
					)
					api.nmap("<leader>hd", gs.diffthis, "Diff this [gitsigns]", default_opts)
					api.nmap("<leader>hd", gs.diffthis, "Diff this [gitsigns]", default_opts)
					api.nmap("<leader>hD", function()
						gs.diffthis("~")
					end, "Diff this ~ [gitsigns]", default_opts)
					api.nmap("<leader>hr", gs.toggle_deleted, "Toggle deleted [gitsigns]", default_opts)

					-- Text object
					api.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Not sure [gitsigns]", default_opts)
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
				-- autotag is enabled by https://github.com/windwp/nvim-ts-autotag
				autotag = {
					enable = true,
				},
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
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
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
