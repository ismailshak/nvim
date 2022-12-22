local helpers = require("utils.helpers")
if not helpers.exists("Comment") then
	return
end


require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
