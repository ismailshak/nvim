local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	vim.api.nvim_command("packadd packer.nvim")
	vim.api.nvim_command("PackerSync")
end

-- Autocommand to reload nvim config when this file is saved
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost init.lua source <afile> | PackerInstall
	augroup end
]])

local ok, packer = pcall(require, "packer")
if not ok then
	return
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- Package manager

	-- themes
	require("plugins.colors").setup(use)

	use({ "glepnir/dashboard-nvim" })
	require("plugins.config.dashboard-setup")

	-- tree sitter
	use("nvim-treesitter/nvim-treesitter")
	-- use("nvim-treesitter/playground") -- helpful when updating a theme's highlight groups (:TSHighlightCapturesUnderCursor)
	-- autocloses and autorenames html-like tags
	use("windwp/nvim-ts-autotag")
	require("plugins.config.tree-sitter")

	-- file explorer tree
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		--tag = 'nightly' -- optional, updated every week. (see issue #1193)
	})
	require("plugins.config.nvim-tree")

	-- better vim UI menus
	use({ "stevearc/dressing.nvim" })
	require("plugins.config.ui")

	-- statusline at the bottom
	use({
		"feline-nvim/feline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	require("plugins.config.statusline").setup()

	-- indent blank lines
	use("lukas-reineke/indent-blankline.nvim")
	require("plugins.config.blankline")

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
	use({ "nvim-telescope/telescope-file-browser.nvim" })
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
	use("numToStr/Navigator.nvim")
	require("plugins.config.tmux-navigator")

	-- Diff view
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	require("plugins.config.diff-view")

	-- Togglable terminal
	-- use("akinsho/toggleterm.nvim")
	use("numToStr/FTerm.nvim")
	require("plugins.config.toggle-term")

	-- surround utility
	use("kylechui/nvim-surround")
	require("plugins.config.surround")

	-- sessions
	use("rmagatti/auto-session")
	require("plugins.config.sessions")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
