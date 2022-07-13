local ok, session = pcall(require, "auto-session")
if not ok then
	return
end

session.setup({
	log_level = "info",
	auto_session_suppress_dirs = { "~/" },
})
