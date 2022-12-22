local M = {}

M.get_default_opts = function(desc)
	return { noremap = true, desc = desc or "", silent = true }
end

M.map = function(mode, key, binding, desc, opts)
	local base = M.get_default_opts(desc)
	for k, v in pairs(opts or {}) do
		base[k] = v
	end -- merge base with incoming opts

	vim.keymap.set(mode, key, binding, base)
end

M.nmap = function(key, binding, desc, opts)
	M.map("n", key, binding, desc, opts)
end

M.vmap = function(key, binding, desc, opts)
	M.map("v", key, binding, desc, opts)
end

M.imap = function(key, binding, desc, opts)
	M.map("i", key, binding, desc, opts)
end

M.tmap = function(key, binding, desc, opts)
	M.map("t", key, binding, desc, opts)
end

return M
