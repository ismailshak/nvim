local M = {}

function M.config(_, opts)
	local lint = require("lint")

	for name, linter in pairs(opts.linters) do
		if type(linter) == "table" and type(lint.linters[name]) == "table" then
			lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
		elseif type(linter) == "function" then
			lint.linters[name] = require("lint.util").wrap(lint.linters[name], linter)
		else
			lint.linters[name] = linter
		end
	end

	lint.linters_by_ft = opts.linters_by_ft

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
		callback = M.debounce(100, M.lint),
	})
end

function M.debounce(ms, fn)
	local timer = vim.loop.new_timer()
	if not timer then
		return fn
	end

	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

---Lint the current buffer
---@see https://github.com/LazyVim/LazyVim/blob/bb36f71b77d8e15788a5b62c82a1c9ec7b209e49/lua/lazyvim/plugins/linting.lua#L30
function M.lint()
	local lint = require("lint")

	-- Use nvim-lint's logic first:
	-- * checks if linters exist for the full filetype first
	-- * otherwise will split filetype by "." and add all those linters
	-- * this differs from conform.nvim which only uses the first filetype that has a formatter
	local names = lint._resolve_linter_by_ft(vim.bo.filetype)

	-- Add fallback linters.
	if #names == 0 then
		vim.list_extend(names, lint.linters_by_ft["_"] or {})
	end

	-- Add global linters.
	vim.list_extend(names, lint.linters_by_ft["*"] or {})

	-- Filter out linters that don't exist or don't match the condition.
	local ctx = { filename = vim.api.nvim_buf_get_name(0) }
	ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
	names = vim.tbl_filter(function(name)
		local linter = lint.linters[name]
		if not linter then
			vim.notify_once("Linter not found: " .. name, vim.log.levels.WARN)
		end

		return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
	end, names)

	-- Run linters.
	if #names > 0 then
		lint.try_lint(names)
	end
end

return M
