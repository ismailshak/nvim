local api = require("utils.api")
if api.is_vscode() then
	return
end

require("custom.options")
require("custom.commands")
require("custom.mappings")
require("custom.lazy")
