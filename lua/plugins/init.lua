return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
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
	"echasnovski/mini.move",

	-- Startup dashboard
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	-- Fancier statusline
	"nvim-lualine/lualine.nvim",

	-- Sessions
	"rmagatti/auto-session",

	-- Convenience plugins
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPost" },
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
}
