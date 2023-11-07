return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		show_dirname = false,
		show_modified = true,
		exclude_filetypes = { "dashboard", "Trouble" },
	},
}
