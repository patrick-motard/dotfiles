hyper = { "cmd", "alt" }
leader = { "alt" }

hs.loadSpoon("HSKeybindings")
hs.loadSpoon("ReloadConfiguration")
hs.loadSpoon("KSheet")
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall

hs.window.animationDuration = 0

Install:andUse("FadeLogo", {
	config = { default_run = 1.0 },
	start = true,
})

-- Reload config
hs.hotkey.bind(hyper, "r", "Reload Hammerspoon", function()
	hs.notify.new({ informativeText = "Reloading Hammerspoon." }):send()
	hs.reload()
end)

-- Cheatsheet
require("src/help")
