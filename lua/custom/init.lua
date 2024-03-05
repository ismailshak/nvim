local api = require("utils.api")
if api.is_vscode() then
	return
end

require("custom.commands")
require("custom.options")
require("custom.mappings")
require("custom.lazy")
