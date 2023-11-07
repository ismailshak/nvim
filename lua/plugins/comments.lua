return {
	{
		"numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
		event = "BufReadPost",
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		opts = { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() },
	},
}
