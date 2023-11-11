return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = {
			auto_refresh = true,
		},
		suggestion = {
			auto_trigger = true,
			accept = false, -- TAB mapping is defined inside `cmp`s "SUPER TAB" mapping
		},
	},
}
