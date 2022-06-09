local M = {}

M.load_plugins = function(use)
	use("wbthomason/packer.nvim") -- Package manager

	-- themes
	use("shaunsingh/nord.nvim")

	-- file explorer tree
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		--tag = 'nightly' -- optional, updated every week. (see issue #1193)
	})

	require("plugins.config.nvim-tree")

	-- statusline at the bottom
	use({
		"feline-nvim/feline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	require("plugins.config.statusline").setup()

	-- tree sitter
	use("nvim-treesitter/nvim-treesitter")
	require("plugins.config.tree-sitter")

	-- auto completion
	use("hrsh7th/nvim-cmp") -- the completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp") -- lsp completions
	use("hrsh7th/cmp-nvim-lua") -- lua completions (helps when working in this dir)

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("rafamadriz/friendly-snippets") -- bunch of snippets to use
	require("plugins.config.cmp-conf")

	-- language server
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- lsp installer, instead of using npm global installs
	require("plugins.config.lsp")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	require("plugins.config.telescope")

	-- bufferline
	use("akinsho/bufferline.nvim")
	require("plugins.config.bufferline")

	-- autopairs
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	require("plugins.config.autopairs")

	-- better commenting
	use("numToStr/Comment.nvim") -- regular, language aware autocomment
	use("JoosepAlviste/nvim-ts-context-commentstring") -- for better JSX commenting
	require("plugins.config.comment")

	-- gitsigns
	use("lewis6991/gitsigns.nvim")
	require("plugins.config.gitsigns")

	-- linting & formatting
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	require("plugins.config.null-ls")

	-- tmux navigation
	use "numToStr/Navigator.nvim"
	require("plugins.config.tmux-navigator")
end

return M
