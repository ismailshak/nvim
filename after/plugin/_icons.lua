-- file is named _icons so that it's loaded before all the other plugin configs

local helpers = require("utils.helpers")
if not helpers.exists("nvim-web-devicons") then
	return
end

-- local ts_icon = "󰛦"
-- local js_icon = "󰌞"
local ts_icon = ""
local js_icon = ""

-- https://github.com/nvim-tree/nvim-web-devicons/blob/defb7da4d3d313bf31982c52fd78e414f02840c9/lua/nvim-web-devicons-light.lua
require("nvim-web-devicons").setup({
	override_by_extension = {
		-- ["ts"] = {
		-- 	icon = ts_icon,
		-- 	color = "#4D93B1",
		-- 	name = "Ts",
		-- },
		-- ["js"] = {
		-- 	icon = js_icon,
		-- 	color = "#C7CC4F",
		-- 	cterm_color = "58",
		-- 	name = "Js",
		-- },
		["spec.ts"] = {
			icon = ts_icon,
			color = "#E17833",
			name = "SpecTs",
		},
		["test.ts"] = {
			icon = ts_icon,
			color = "#E17833",
			name = "TestTs",
		},
		["spec.js"] = {
			icon = js_icon,
			color = "#E17833",
			name = "SpecJs",
		},
		["test.js"] = {
			icon = js_icon,
			color = "#E17833",
			name = "TestJs",
		},
	},
})
