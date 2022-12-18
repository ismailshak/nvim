local ok, devicons = pcall(require, "nvim-web-devicons")
if not ok then
	return
end

local testColor = "#bf7344"

local js = {
	icon = devicons.get_icon_by_filetype("javascript"),
	color = testColor,
	name = "JsTest",
}

local ts = {
	--[[ icon = devicons.get_icon_by_filetype("typescript"), ]]
	icon = "T",
	color = testColor,
	name = "TsTest",
}

devicons.setup({
	override = {
		["test.js"] = js,
		["spec.js"] = js,
		["test.ts"] = ts,
		["spec.ts"] = ts,
	},
	default = true,
})
