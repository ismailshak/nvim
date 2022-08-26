local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
if not configs_ok then
	return
end

configs.setup({
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
		"tsx",
		"markdown",
		"json",
		"yaml",
		"go",
		"gomod",
		"dockerfile",
		"python",
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
		enable_autocmd = true,
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
