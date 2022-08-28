local M = {}

M.keymap = function(mode, key, binding, opts)
	local options = opts or { noremap = true, silent = true }

	vim.api.nvim_set_keymap(mode, key, binding, options)
end

M.buf_keymap = function(bufnr, mode, key, binding)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, mode, key, binding, opts)
end

return M
