hyper = { "cmd", "alt" }

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

menuHammer = hs.loadSpoon("MenuHammer")
menuHammer:enter()
