local ok, session = pcall(require, "auto-session")
if not ok then
	return
end

local utils = require("utils.keybindings")
utils.keymap("n", "<leader>sl", "<CMD>RestoreSession<CR>")

session.setup({
	log_level = "error",
	auto_restore_enabled = false, -- Use dashboard or keymap to restore
	auto_session_suppress_dirs = { "~/" },
	bypass_session_save_file_types = {"dashboard"} -- Don't overwrite session if the dashboard is open
})
