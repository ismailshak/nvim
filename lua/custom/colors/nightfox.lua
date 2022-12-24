local helpers = require("utils.helpers")
if not helpers.exists("nightfox") then
	return
end

require("nightfox").setup()
