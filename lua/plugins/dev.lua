local mappings = require("custom.mappings")
local settings = require("custom.settings")
local icons = require("utils.icons")
local ui = require("utils.ui")

-- Core plugins used when actually typing/navigating

return {
	-- Detect tabstop and shiftwidth automatically
	{ "tpope/vim-sleuth", event = "InsertEnter" },

	-- Move around the buffers
	{
		"ggandor/leap.nvim",
		lazy = false, -- Handled by plugin
		config = function()
			mappings.leap()
			require("leap").init_highlight(true)
		end,
	},

	-- GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		keys = { "<leader>cd", "<leader>ce" },
		event = "VeryLazy",
		opts = {
			panel = {
				auto_refresh = true,
			},
			suggestion = {
				auto_trigger = true,
				accept = true, -- TAB mapping is defined inside `cmp`s "Tab" mapping
				keymap = {
					accept = "<M-a>",
					accept_word = "<M-w>",
					accept_line = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
		},
		config = function(_, opts)
			mappings.copilot()
			require("copilot").setup(opts)
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
		},
		init = function()
			require("utils.tools.codecompanion"):init()
		end,
		opts = {
			display = {
				chat = {
					intro_message = "",
					show_header_separator = false,
					start_in_insert_mode = true,
					window = {
						opts = {
							number = false,
							signcolumn = "no",
						},
					},
				},
			},
			adapters = {
				http = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "claude-sonnet-4.5",
								},
							},
						})
					end,
				},
			},
			interactions = {
				chat = {
					adapter = "copilot",
					roles = {
						llm = function(adapter)
							return icons.copilot.response .. "  " .. adapter.formatted_name
						end,
						user = icons.copilot.prompt,
					},
				},
			},
		},
		config = function(_, opts)
			mappings.codecompanion()
			require("codecompanion").setup(opts)
		end,
	},

	-- Moving code around
	{
		"echasnovski/mini.move",
		event = "BufReadPost",
		opts = {
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				left = "<A-h>",
				right = "<A-l>",
				down = "<A-j>",
				up = "<A-k>",

				-- Move current line in Normal mode
				line_left = "<A-h>",
				line_right = "<A-l>",
				line_down = "<A-j>",
				line_up = "<A-k>",
			},
		},
	},

	-- Automatically close brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel", "dashboard", "NvimTree", "toggleterm", "term" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
	},

	-- Automatically close html tags
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"html",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
			"vue",
			"tsx",
			"jsx",
			"xml",
			"markdown",
		},
	},

	-- Better code commenting
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufReadPost",
		opts = {
			enable_autocmd = false,
		},
		config = function(_, opts)
			require("ts_context_commentstring").setup(opts)

			local original_get_option = vim.filetype.get_option
			---@diagnostic disable-next-line: duplicate-set-field
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or original_get_option(filetype, option)
			end
		end,
	},

	-- Peek definition but does more
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			mappings.lspsaga()

			require("lspsaga").setup({
				ui = {
					-- Border type can be single, double, rounded, solid, shadow.
					border = "rounded",
					expand = "",
					collapse = "",
				},
				lightbulb = {
					enable = false,
				},
				symbol_in_winbar = {
					enable = false,
				},
				outline = {
					keys = {
						expand_or_jump = "<CR>",
						quit = "q",
					},
				},
			})
		end,
	},

	-- Surround utility like "change surrounding quotes" or "delete surrounding quotes"
	{
		"kylechui/nvim-surround", -- surround utility
		event = "BufReadPost",
		opts = {
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
			},
			aliases = {
				["a"] = ">",
				["b"] = ")",
				["B"] = "}",
				["r"] = "]",
				["q"] = { '"', "'", "`" },
				["s"] = { "}", "]", ")", ">", '"', "'", "`" },
			},
			highlight = {
				duration = 0,
			},
			move_cursor = "begin",
			indent_lines = function(start, stop)
				local b = vim.bo
				-- Only re-indent the selection if a formatter is set up already
				if
					start <= stop and (b.equalprg ~= "" or b.indentexpr ~= "" or b.cindent or b.smartindent or b.lisp)
				then
					vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
				end
			end,
		},
	},

	-- A more powerful undo mechanism
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		event = "BufReadPost",
		keys = "<leader>uu",
		config = function()
			mappings.undotree()

			vim.g.undotree_WindowLayout = 4
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},

	-- `gx` to open links in the browser (since I have netrw disabled)
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		dependencies = { "nvim-lua/plenary.nvim" },
		submodules = false, -- repo has git submodules that are only used for tests
		opts = {
			handler_options = {
				search_engine = "duckduckgo",
			},
		},
	},

	-- Database client
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod" },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		keys = { "<leader>bd" },
		config = function()
			mappings.dadbod()

			vim.g.dbs = settings.get().db_connections
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},

	-- CircleCI integration
	{
		"ismailshak/circleci.nvim",
		lazy = false,
		---@type circleci.Config
		opts = {
			api_token = "CIRCLECI_TOKEN",
		},
		config = function(_, opts)
			vim.keymap.set("n", "<leader>ci", "<cmd>CircleCI panel toggle<cr>", { noremap = true, silent = true })
			require("circleci").setup(opts)
		end,
	},

	-- Autocompletion
	{
		"saghen/blink.cmp",
		lazy = false, -- handled by plugin
		version = "1.*", -- release tags to download pre-built binaries
		-- build = "cargo build --release", -- temporarily build from source until draw support is released
		dependencies = "rafamadriz/friendly-snippets",
		opts = {
			appearance = {
				nerd_font_variant = "mono",
				kind_icons = icons.kinds,
			},
			completion = {
				trigger = {
					show_on_insert_on_trigger_character = false,
				},
				list = {
					selection = { preselect = false, auto_insert = true },
				},
				menu = {
					min_width = 15,
					max_height = 10,
					border = "rounded",
					draw = {
						padding = 1,
						gap = 1,
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
						components = {
							kind_icon = {
								ellipsis = false,
								text = ui.kind_icon_text,
								highlight = ui.kind_icon_highlight,
							},
							label = {
								width = { fill = true, max = 60 },
							},
							label_description = {
								ellipsis = true,
								width = { fill = false, max = 30 },
								highlight = "BlinkCmpLabelDescription",
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						min_width = 10,
						max_width = 60,
						max_height = 20,
						border = "rounded", -- gutter will be disabled when border ~= 'none'
						scrollbar = true,
					},
				},
			},
			sources = {
				providers = {
					snippets = {
						name = "Snippets",
						opts = {
							extended_filetypes = {
								javascriptreact = { "javascript" },
								typescriptreact = { "typescript" },
							},
						},
					},
				},
			},
			keymap = {
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.snippet_forward()
						else
							return cmp.select_next()
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.snippet_backward()
						else
							return cmp.select_prev()
						end
					end,
					"fallback",
				},
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
		},
		opts_extend = { "sources.default" },
	},
}
