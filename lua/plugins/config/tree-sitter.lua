local configs_ok, configs = pcall(require, "treesitter.cofings")
if not configs_ok then
	return
end

configs.setup({
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
})
