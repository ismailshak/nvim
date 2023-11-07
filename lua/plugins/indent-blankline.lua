return {
	"lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
	event = "BufReadPost",
	opts = {
		filetype_exclude = { "dashboard" },
		show_current_context = false,
		show_current_context_start = false,
	},
}
