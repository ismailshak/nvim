-- Setup nvim-cmp.
local status_ok, indent = pcall(require, "indent-blankline")
if not status_ok then
	return
end

indent.setup({
	show_current_context = false,
	show_current_context_start = false,
})
