hs.hotkey.bind({"shift", "alt", "ctrl"}, "w", function()
  -- hs.alert.show("Hello World!")
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

hyper = { "cmd", "alt" }
meh = { "alt", "shift", "ctrl" }

spaces = require("hs._asm.undocumented.spaces")

hs.hotkey.bind(hyper, "r", function()
  current_space = spaces.activeSpace()
  space_name = spaces.spaceName(current_space)
  text = current_space .. space_name
  -- hs.alert.show("Hello World!")
  hs.notify.new({title="current space", informativeText=space_name}):send()
end)

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- title is optional
function notify(message, title)
  hs.notify.new({title=title, informativeText=message}):send()
end

function main()
  space_id = spaces.activeSpace()
  space_name = spaces.spaceName(space_id)
  text = space_id .. space_name
  win = spaces.allWindowsForSpace(space_id)
  -- for i in pairs(win) do print(win[i]) end

  out = text
  notify("pie")
end

hs.hotkey.bind(meh, 'd', function()
  main()
end)

-- hs.window.animationDuration = 0
hs.hotkey.bind(hyper, "k", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind(hyper, ";", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToScreen(win:screen():next())
end)

hs.hotkey.bind(hyper, "j", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToScreen(win:screen():previous())
end)

hs.hotkey.bind(hyper, "l", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind(hyper, "m", function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)


-- set up your windowfilter
switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)

switcher.ui.textsize = 10
switcher.ui.fontName = 'JetBrains Mono'
-- hs.window.animationDuration = 0

-- bind to hotkeys; WARNING: at least one modifier key is required!
hs.hotkey.bind('alt','tab','Next window',function()switcher:next()end)
hs.hotkey.bind('alt-shift','tab','Prev window',function()switcher:previous()end)

-- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
hs.hotkey.bind('alt','tab','Next window',hs.window.switcher.nextWindow)
-- you can also bind to `repeatFn` for faster traversing
hs.hotkey.bind('alt-shift','tab','Prev window',hs.window.switcher.previousWindow,nil,hs.window.switcher.previousWindow)

hs.hotkey.bind(hyper, 'd', function()
  hs.application.launchOrFocus('Iterm')
end)
