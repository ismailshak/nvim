local mappings = require("custom.mappings")
local dap = require("utils.tools.dap")
local utils = require("utils.helpers")
local icons = require("utils.icons")
local formatting = require("utils.tools.formatting")
local installer = require("utils.tools.installer")
local lint = require("utils.tools.lint")
local lsp = require("utils.tools.lsp")

--
-- Core functionality
--

return {
	-- Configures lua_ls to support neovim config/plugin development
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- See the configuration section for more details
				-- `${3rd}/luv` is the luv type library bundled with lua_ls. Loaded when a file mentions `vim.uv`.
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter" },
		opts = {
			linters_by_ft = {
				markdown = { "markdownlint" },
				sh = { "shellcheck" },
				go = { "golangcilint" },
			},
			linters = {
				markdownlint = {
					args = { "--disable", "MD013", "MD033", "--" },
				},
			},
		},
		config = lint.config,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		dependencies = {
			"j-hui/fidget.nvim",
		},
		opts = {
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
				css = { "prettier" },
				graphql = { "prettier" },
				go = { "goimports" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				just = { "just" },
				less = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				mysql = { "sql_formatter" },
				ocaml = { "ocamlformat" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				sql = { "sql_formatter" },
				svelte = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = formatting.format_on_save,
		},
		init = formatting.init,
	},

	-- Lua-based Typescript LSP
	{
		"pmizio/typescript-tools.nvim",
		pin = true, -- replaced by tsc and vtsls after the nvim 0.12 upgrade
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			publish_diagnostic_on = "change",
			expose_as_code_action = "all",
		},
	},

	-- Rust tools
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		opts = {
			tools = {
				float_win_config = {
					border = "rounded",
					max_width = utils.percentage_as_width(70),
					max_height = utils.percentage_as_width(20),
				},
				hover_actions = {
					replace_builtin_hover = false,
				},
			},
			server = {
				default_settings = require("utils.tools.settings.rust-analyzer").settings,
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = opts
		end,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			-- Exposing cmd so that it can be triggered by a new installation to grab all required tooling
			-- Pinned until the mason v2 upgrade
			{ "WhoIsSethDaniel/mason-tool-installer.nvim", cmd = "MasonToolsInstallSync", pin = true },

			{ "williamboman/mason.nvim", version = "^1" }, -- Install LSPs and tools to neovim's stdpath
			{ "williamboman/mason-lspconfig.nvim", version = "^1" }, -- Closes gap between mason.nvim and lspconfig
			"j-hui/fidget.nvim", -- Notification UI for LSP messages
		},
		config = function()
			installer.setup_mason()
			lsp.setup_lsp()
		end,
	},

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		keys = {
			"<leader>du",
			"<leader>dd",
			"<leader>dt",
			"<leader>db",
			"<leader>dc",
			"<leader>dl",
		},
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
			},
			{
				"leoluz/nvim-dap-go",
				keys = {
					"<leader>du",
					"<leader>dd",
					"<leader>dt",
					"<leader>db",
					"<leader>dc",
					"<leader>dl",
				},
				ft = "go",
			},
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			dap.setup_dap()
			mappings.dap()

			dap.setup_dap_ui()
			mappings.dap_ui()
		end,
	},

	-- Save sessions
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			need = 1,
			branch = true,
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
				on_attach = function(bufnr)
					mappings.gitsigns(bufnr)
				end,
			})
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- registers filetype-to-parser aliases when it loads and does not support lazy loading
		build = ":TSUpdate",
		config = function()
			-- `:TSUpdate` only updates installed parsers, so a new machine needs this list. `install` is async and
			-- skips parsers that are already installed.
			require("nvim-treesitter").install({
				"bash",
				"css",
				"dockerfile",
				"go",
				"gomod",
				"graphql",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"just",
				"lua",
				"markdown",
				"markdown_inline",
				"ocaml",
				"python",
				"query",
				"regex",
				"rust",
				"sql",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
					if not lang or not vim.treesitter.language.add(lang) then
						return
					end

					vim.treesitter.start(ev.buf, lang)

					-- nvim-treesitter's indentexpr only knows languages that have an indents query
					if vim.treesitter.query.get(lang, "indents") then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			-- The mappings are buffer-local so that buffers without textobject queries keep the default `]a` and
			-- `]l` mappings. This autocmd is created after the ftplugin one, so these mappings replace the `]]` and
			-- `]m` mappings of the go, rust and python ftplugins.
			local function attach(buf)
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				local ok, query = pcall(vim.treesitter.query.get, lang or "", "textobjects")
				if ok and query then
					mappings.treesitter_textobjects(buf)
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterTextobjects", { clear = true }),
				callback = function(ev)
					attach(ev.buf)
				end,
			})

			-- Buffers opened before this plugin loaded
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					attach(buf)
				end
			end
		end,
	},
}
