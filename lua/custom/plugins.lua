local M = {
	{ "nvim-tree/nvim-web-devicons" },
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",
		},
	},
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},

	-- Linting & Formatting
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Bridge to auto install via Mason
			"jayp0521/mason-null-ls.nvim",
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"hrsh7th/cmp-nvim-lsp", -- lsp completions
			"hrsh7th/cmp-nvim-lua", -- lua completions (helps when working in this dir)
			"hrsh7th/cmp-nvim-lsp-signature-help", -- function signature hints plugin
			"L3MON4D3/LuaSnip", -- snippet engine
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"rafamadriz/friendly-snippets", -- bunch of snippets to use
		},
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},

	-- Motion
	"ggandor/lightspeed.nvim",
	"echasnovski/mini.move",

	-- File tree
	{ "kyazdani42/nvim-tree.lua" },

	-- Git related plugins
	"lewis6991/gitsigns.nvim",
	{ "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },

	-- Terminal
	"numToStr/FTerm.nvim",

	-- Themes
	"folke/tokyonight.nvim",
	"EdenEast/nightfox.nvim",
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "kvrohit/substrata.nvim" },

	-- Startup dashboard
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	-- Fancier statusline
	"nvim-lualine/lualine.nvim",

	-- Bufferline
	-- "akinsho/bufferline.nvim",

	-- Better vim UI
	"stevearc/dressing.nvim",

	-- Fuzzy Finder (files, lsp, etc)
	{
		"ibhagwan/fzf-lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-github.nvim",
		},
	},

	-- Sessions
	"rmagatti/auto-session",

	-- Convenience plugins
	"lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
	"numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
	"JoosepAlviste/nvim-ts-context-commentstring", -- for better JSX commenting
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"windwp/nvim-ts-autotag", -- autocloses and autorenames html-like tags
	"windwp/nvim-autopairs", -- autocreates bracket pairs
	"kylechui/nvim-surround", -- surround utility
	"folke/zen-mode.nvim",
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	},
}

return M
