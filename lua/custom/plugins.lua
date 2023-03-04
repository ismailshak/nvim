local M = {}

M.init = function(use)
	use({ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",
		},
	})

	-- Linting & Formatting
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			-- Bridge to auto install via Mason
			"jayp0521/mason-null-ls.nvim",
		},
	})

	use({ -- Autocompletion
		"hrsh7th/nvim-cmp",
		requires = {
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
	})

	use({ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	-- Motion
	use("ggandor/lightspeed.nvim")
	use("echasnovski/mini.move")

	-- File tree
	use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })

	-- Git related plugins
	use("lewis6991/gitsigns.nvim")
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	-- Terminal
	use("numToStr/FTerm.nvim")

	-- Themes
	use("folke/tokyonight.nvim")
	use("EdenEast/nightfox.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use({ "rose-pine/neovim", as = "rose-pine" })

	-- Startup dashboard (TODO: figure out new config, commit after this introduces major breaking changes)
	use({ "glepnir/dashboard-nvim", commit = "f7d623457d6621b25a1292b24e366fae40cb79ab" })

	-- Fancier statusline
	use("nvim-lualine/lualine.nvim")

	-- Bufferline
	use("akinsho/bufferline.nvim")

	-- Better vim UI
	use("stevearc/dressing.nvim")

	-- Fuzzy Finder (files, lsp, etc)
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-github.nvim",
		},
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- Sessions
	use("rmagatti/auto-session")

	-- Convenience plugins
	use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
	use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
	use("JoosepAlviste/nvim-ts-context-commentstring") -- for better JSX commenting
	use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically
	use("windwp/nvim-ts-autotag") -- autocloses and autorenames html-like tags
	use("windwp/nvim-autopairs") -- autocreates bracket pairs
	use("kylechui/nvim-surround") -- surround utility
	use("folke/zen-mode.nvim")
	use({ -- uses LSP to show code context
		"utilyre/barbecue.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		after = "nvim-web-devicons",
	})
end

return M
