hs.hotkey.bind(hyper, "1", "VSCode", function()
	hs.application.launchOrFocus("Visual Studio Code")
end)

hs.hotkey.bind(hyper, "2", "Alacritty", function()
	hs.application.launchOrFocus("Alacritty")
end)

hs.hotkey.bind(hyper, "3", "Firefox", function()
	hs.application.launchOrFocus("Firefox")
end)

hs.hotkey.bind(hyper, "4", "Slack", function()
	hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind(hyper, "0", "Spotify", function()
	hs.application.launchOrFocus("Spotify")
end)

hs.hotkey.bind(hyper, "o", "Obsidian", function()
	hs.application.launchOrFocus("Obsidian")
end)

hs.hotkey.bind(hyper, "z", "Zoom", function()
	hs.application.launchOrFocus("Zoom")
end)

-- Use to get name of application
hs.hotkey.bind(hyper, "h", function()
	print(hs.application.find("code"))
end)

hs.hotkey.bind(hyper, "8", "Feishin", function()
	hs.application.launchOrFocus("Feishin")
end)

hs.hotkey.bind(hyper, "t", "Tabs", function()
	app = hs.application.frontmostApplication()
	hs.tabs.enableForApp(app)
end)
