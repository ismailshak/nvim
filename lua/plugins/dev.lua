local mappings = require("custom.mappings")
local icons = require("utils.icons")
local settings = require("custom.settings")

-- Core plugins used when actually typing/navigating

return {
	-- Detect tabstop and shiftwidth automatically
	{ "tpope/vim-sleuth", event = "InsertEnter" },

	-- Move around the buffer with ease
	{
		"ggandor/leap.nvim",
		lazy = false, -- Handled by plugin
		config = function()
			mappings.leap()
			require("leap").add_default_mappings()
		end,
	},

	-- GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		keys = { "<leader>cd", "<leader>ce" },
		event = "InsertEnter",
		opts = {
			panel = {
				auto_refresh = true,
			},
			suggestion = {
				auto_trigger = true,
				accept = true, -- TAB mapping is defined inside `cmp`s "SUPER TAB" mapping
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
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		keys = {
			{ "<leader>cc", mode = { "n", "x" } },
			{ "<leader>ch", mode = { "n", "x" } },
			{ "<leader>cv", mode = { "n", "x" } },
			{ "<leader>C", mode = { "n", "x" } },
			{ "<leader>cq", mode = { "n", "x" } },
			{ "<leader>cfh", mode = { "n", "x" } },
			{ "<leader>cfp", mode = { "n", "x" } },
		},
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			question_header = icons.copilot.prompt .. "  ",
			answer_header = icons.copilot.response .. "  ",
			error_header = icons.copilot.error .. "  ",
			separator = "⎯⎯⎯⎯⎯⎯⎯⎯⎯",
			show_help = false,
			show_folds = false,
			auto_insert_mode = true,
			insert_at_end = true,
			window = {
				layout = "vertical",
				width = 0.35,
			},
			mappings = {
				reset = {
					normal = "<C-r>",
					insert = "<C-r>",
				},
			},
		},
		config = function(_, opts)
			mappings.copilot_chat()

			require("CopilotChat").setup(opts)
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
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPost" },
	{
		"numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
		event = "BufReadPost",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		opts = { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() },
	},

	-- Peek definition but does more
	{
		"glepnir/lspsaga.nvim",
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
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- lsp completions
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"hrsh7th/cmp-nvim-lua", -- lua completions (helps when working in this dir)
			-- "hrsh7th/cmp-nvim-lsp-signature-help", -- function signature hints plugin
			{ "L3MON4D3/LuaSnip", submodules = false }, -- snippet engine
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"rafamadriz/friendly-snippets", -- bunch of snippets to use
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			require("luasnip/loaders/from_vscode").lazy_load()
			require("luasnip.loaders.from_snipmate").lazy_load()

			require("CopilotChat.integrations.cmp").setup()

			-- for "super tab" below
			local check_backspace = function()
				local col = vim.fn.col(".") - 1
				return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = {
					["<C-k>"] = cmp.mapping.select_prev_item(), -- move up in the completions menu
					["<C-j>"] = cmp.mapping.select_next_item(), -- move down in the completions menu
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }), -- scroll up in the snippet screen
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }), -- scroll down in the snippets screen
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), -- launch completions menu without typing
					["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
					["<C-e>"] = cmp.mapping({ -- exit the completions menu
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					-- Accept currently selected item. If none selected, `select` first item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					-- super tab, move through menu or move through snippets
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif check_backspace() then
							fallback()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				},
				formatting = {
					expandable_indicator = true,
					fields = { "kind", "abbr" },
					format = function(entry, item)
						local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })

						if entry.source.name == "copilot-chat" then
							item.kind = "Copilot"
						end

						item.kind = icons.kinds[item.kind] or ""
						item.menu = ""

						if color_item.abbr_hl_group then
							item.kind_hl_group = color_item.abbr_hl_group
							item.kind = color_item.abbr
						end

						return item
					end,
				},
				-- order matters, it will appear in that order in the completion menu (using its own custom weighting system)
				sources = {
					{ name = "nvim_lsp" },
					{ name = "vim-dadbod-completion" },
					{ name = "nvim_lua" },
					{ name = "git" },
					{ name = "buffer" },
					{ name = "luasnip" },
					{ name = "path" },
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
				},
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				window = {
					documentation = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
					completion = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
				},
				experimental = {
					ghost_text = false, -- virtual text that spells out the remaining chars for a completion
					native_menu = false,
				},
			})
		end,
	},
}
