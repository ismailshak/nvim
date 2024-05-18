local settings = require("custom.settings")
local utils = require("utils.helpers")

local M = {}

M.notify_title = "Formatting"

function M.init()
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	-- Globals to stop notifications from spamming me
	vim.g.conform_disabled_notify = true
	vim.g.conform_no_formatters_notify = true
end

---Closes the notification handler and reports any errors
---@param handle ProgressHandle
function M.format_callback(handle)
	return function(err)
		if err then
			handle:report({
				title = M.notify_title,
				message = "Error",
				percentage = 100,
			})
			handle:finish()

			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		handle:report({
			title = M.notify_title,
			message = "Done",
			percentage = 100,
		})
		handle:finish()
	end
end

function M.format_progress_handler()
	local progress = require("fidget.progress")

	return progress.handle.create({
		title = M.notify_title,
		message = "Formatting...",
		lsp_client = { name = "conform" },
		percentage = 0,
	})
end

function M.format_on_save(bufnr)
	local path = utils.full_path()
	local disabled_dirs = settings.get().disable_format
	local formatters = require("conform").list_formatters(bufnr)

	if #formatters == 0 then
		if vim.g.conform_no_formatters_notify then
			vim.notify("No formatter found", vim.log.levels.WARN)
			vim.g.conform_no_formatters_notify = false
			return
		end
		return
	end

	for _, dir in ipairs(utils.split(disabled_dirs, ",")) do
		if utils.includes(path, dir) then
			if vim.g.conform_disabled_notify then
				vim.notify("Formatting disabled for this directory", vim.log.levels.INFO)
				vim.g.conform_disabled_notify = false
			end

			return
		end
	end

	local progress = M.format_progress_handler()

	return { timeout_ms = 500, lsp_fallback = false }, M.format_callback(progress)
end

return M
