local lsp_utils = require("utils.lsp")

--
-- Core functionality
--

return {
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

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
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
}
