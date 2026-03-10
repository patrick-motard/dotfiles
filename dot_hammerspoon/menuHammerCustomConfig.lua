-- MenuHammer config - https://github.com/FryJay/MenuHammer
menuHammerMenuList = {
	mainMenu = {
		parentMenu = nil,
		menuHotkey = { hyper, "m" },
		menuItems = {
			{ cons.cat.action, "", "r", "Reload Hammerspoon", { { cons.act.func, function()
				hs.notify.new({ informativeText = "Reloading Hammerspoon." }):send()
				hs.reload()
			end } } },
			{ cons.cat.action, "", "k", "Show Keybindings", { { cons.act.func, function()
				spoon.HSKeybindings:show()
			end } } },
			{ cons.cat.action, "", "/", "KSheet Toggle", { { cons.act.func, function()
				spoon.KSheet:toggle()
			end } } },
		},
	},
}
