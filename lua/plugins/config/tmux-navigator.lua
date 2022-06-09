local status_ok, navigator = pcall(require, "Navigator")
if not status_ok then
	return
end

-- Keybindings
local utils = require("utils.keybindings")

utils.keymap('n', "<c-h>", '<CMD>NavigatorLeft<CR>', {})
utils.keymap('n', "<c-l>", '<CMD>NavigatorRight<CR>', {})
utils.keymap('n', "<c-k>", '<CMD>NavigatorUp<CR>', {})
utils.keymap('n', "<c-j>", '<CMD>NavigatorDown<CR>', {})
utils.keymap('n', "<c-p>", '<CMD>NavigatorPrevious<CR>', {})

-- Configuration
navigator.setup({
  -- When you want to save the modified buffers when moving to tmux
  -- nil - Don't save (default)
  -- 'current' - Only save the current modified buffer
  -- 'all' - Save all the buffers
  auto_save = nil,

  -- Disable navigation when tmux is zoomed in
  disable_on_zoom = false
})

