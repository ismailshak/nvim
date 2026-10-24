---@alias background 'dark' | 'light'

---@alias theme
---| 'iceberg'
---| 'oxocarbon'
---| 'nord'
---| 'rose-pine'
---| 'carbonfox'
---| 'nightfox'
---| 'dayfox'
---| 'catppuccin'
---| 'substrata'

---@class Settings
---@field public background background
---@field public copilot boolean
---@field public theme theme
---@field public disable_format string[]: List of directories where formatting will not run on save (e.g. {"node_modules", "my_folder/dist"})
---@field public repo_paths table<string, string>: Local checkout of each remote repository, keyed by `owner/repo`. A `*` in the key matches any repository name and is substituted into the path. Passed to atlas.nvim as `pulls.repo_config.paths`, which uses it to check out pull requests and open the Branches and Tags pages. Local settings add to these entries.
---@field public github_exclude_orgs string[]: GitHub organizations removed from the atlas.nvim pull request views. Each name is added to the view's search as `-org:<name>`. Set it in local settings for an organization whose SAML single sign-on the `gh` token is not authorized for, since GitHub fails the whole search when any result is in that organization.

---@type Settings
local M = {
	background = "dark",
	copilot = true,
	theme = "iceberg",
	disable_format = {},
	repo_paths = {
		["ismailshak/*"] = "~/code/*",
	},
	github_exclude_orgs = {},
}

return M
