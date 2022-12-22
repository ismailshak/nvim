local helpers = require("utils.helpers")
if not helpers.exists("auto-session") then
	return
end

local utils = require("utils.keybindings")
utils.nmap("<leader>sl", "<CMD>RestoreSession<CR>", "Restore last session")

require("auto-session").setup({
	log_level = "error",
	auto_restore_enabled = false, -- Use dashboard or keymap to restore
	auto_session_suppress_dirs = { "~/" },
	bypass_session_save_file_types = { "dashboard" }, -- Don't overwrite session when these file types are focused
})
