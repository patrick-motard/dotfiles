-- Globals
ergo_hyper = { "alt", "shift", "ctrl", "cmd" }
hyper = { "cmd", "alt" }
meh = { "alt", "shift", "ctrl" }
cmd = { "cmd" }
ctrl = { "ctrl" }
leader = { "alt" }
PYTHON_BINARY = "/usr/local/bin/python3"
cwd = os.getenv("HOME") .. "/.hammerspoon/"

hs.loadSpoon("HSKeybindings")
hs.loadSpoon("ReloadConfiguration")
hs.loadSpoon("KSheet")
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall
-- I'll need to install the arm64 version of this before I can use it.
-- spaces = require("hs._asm.undocumented.spaces")
-- spoon.ReloadConfiguration:start()

-- START OPTIONAL SETTINGS
--
-- Uncomment when debugging:
-- Install.use_syncinstall = true
hs.window.animationDuration = 0
--
-- END OPTIONAL SETTINGS

-- START OPTIONAL MODULES
-- Comment/uncomment modules to enable/disable.

-- Keybinds in 'application' allow you to focus/open apps quickly.
require("src/application")
-- Keybinds in 'window' allow moving windows/apps around on screen
-- and between screens.
require("src/window")
-- Keybind in 'help' enable help menus.
require("src/help")

-- title is optional
function notify(message, title)
	hs.notify.new({ title = title, informativeText = message }):send()
end

hs.hotkey.bind(hyper, "r", "Reload Hammerspoon", function()
	notify("Reloading Hammerspoon.", "Notice")
	hs.reload()
end)

-- This would be the preferred way to enable Caffeine, but the tooltip
-- "Toggle Caffeine" doesn't show up in the help menu.
-- Install:andUse("Caffeine",
--   { hotkeys = { toggle = { hyper, "c", "Toggle Caffeine" }}, start = true}
-- )

-- Disabling caffeine for now.
-- Install:andUse("Caffeine", { start = true})
-- caffeineOn = true
-- hs.hotkey.bind(hyper, "c", 'Toggle Caffeine', function()
--   caffeineOn = not caffeineOn
--   spoon.Caffeine:setState(caffeineOn)
-- end)
-- spoon.Caffeine:setState(caffeineOn)

-- START WORK IN PROGRESS
-- hs.hotkey.bind(hyper, "r", 'wip', function()
--   current_space = spaces.activeSpace()
--   space_name = spaces.spaceName(current_space)
--   text = current_space .. space_name
--   hs.notify.new({title="current space", informativeText=space_name}):send()
-- end)

Install:andUse("FadeLogo", {
	config = {
		default_run = 1.0,
	},
	start = true,
})

function main()
	-- -- space_id = spaces.activeSpace()
	-- space_name = spaces.spaceName(space_id)
	-- text = space_id .. space_name
	-- win = spaces.allWindowsForSpace(space_id)
	-- for i in pairs(win) do print(win[i]) end
	-- apps = hs.application.runningApplications()
	-- for i in pairs(apps) do print(apps[i]) end

	-- out = text
	-- notify(out)
end

-- hs.hotkey.bind(meh, 'd', 'wip', function()
--   main()
-- end)

-- hs.hotkey.bind(hyper, 'w', 'wip', function()
--   space_id = spaces.activeSpace()
--   win = spaces.allWindowsForSpace(space_id)
--   for i in pairs(win) do print(win[i]:title()) end
-- end)

menuHammer = hs.loadSpoon("MenuHammer")
menuHammer:enter()
