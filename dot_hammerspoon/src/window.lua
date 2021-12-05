hs.hotkey.bind(hyper, 'k', 'Window ← 1/2', function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind(hyper, ";", 'Window → Screen', function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToScreen(win:screen():next())
end)

hs.hotkey.bind(hyper, "j", 'Window ← Screen', function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToScreen(win:screen():previous())
end)

hs.hotkey.bind(hyper, "l", 'Window → 1/2', function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind(hyper, "m", 'Window Maximize', function()
  local win = hs.window.focusedWindow();
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)

-- set up your windowfilter
switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
-- switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)

-- Fields that can be customized on the switcher ui can be found here:
-- https://www.hammerspoon.org/docs/hs.window.switcher.html#ui
switcher.ui.textsize = 10
switcher.ui.showThumbnails = false
-- switcher.ui.showTitles = false
switcher.ui.showSelectedThumbnail = false
switcher.ui.showSelectedTitle = false
-- switcher.ui.fontName = 'JetBrains Mono'

-- bind to hotkeys; WARNING: at least one modifier key is required!
hs.hotkey.bind('alt','tab','Next window',function()switcher:next()end)
hs.hotkey.bind('alt-shift','tab','Prev window',function()switcher:previous()end)

-- -- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
-- hs.hotkey.bind('alt','tab','Next window',hs.window.switcher.nextWindow)
-- -- you can also bind to `repeatFn` for faster traversing
-- hs.hotkey.bind('alt-shift','tab','Prev window',hs.window.switcher.previousWindow,nil,hs.window.switcher.previousWindow)
