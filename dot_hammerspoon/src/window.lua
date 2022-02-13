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


hs.hotkey.bind(hyper, "i", 'Hints', function()
  hs.hints.showTitleThresh = 10
  -- hs.hints.style = 'vimperator'
  hs.hints.windowHints()
end)

k = hs.hotkey.modal.new(hyper, 'g', 'g mode homie!')

function k:entered() hs.alert'Entered mode' end
function k:exited()
  hs.alert'Exited mode'
end

k:bind('', 'escape', function() k:exit() end)
k:bind('', 'J', 'Pressed J', function()
  print'let the record show that J was pressed'
  k:exit()
end)

k:bind('', 'C', function()
  hs.window.focusedWindow():centerOnScreen(win)
  k:exit()
end)

function coords ()
  return hs.window.focusedWindow(), hs.window.focusedWindow():frame(),
    hs.window.focusedWindow():screen(), hs.window.focusedWindow():screen():frame()
end

-- `thirds` takes in a string `part`, where part is
-- left, center, or right. It will then place the
-- currently focused window on the part passed in. The
-- window is also resized to be maximum height, and
-- 1/3rd width.
function thirds(part)
  local win = hs.window.focusedWindow();
  if not win then return end
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local one_third = max.w / 3
  local x = 0

  if part == 'left' then
    x = 0
  elseif part == 'right' then
    x = one_third * 2
  elseif part == 'center' then
    x = one_third
  end

  f.x = x
  f.y = 0
  f.h = max.h
  f.w = one_third
  win:setFrame(f)
end

hs.hotkey.bind(
  ergo_hyper,
  '1',
  'Window left 1/3',
  function() thirds('left') end
)

hs.hotkey.bind(
  ergo_hyper,
  '2',
  'Window middle 1/3',
  function()
    thirds('center')
  end
)

hs.hotkey.bind(
  ergo_hyper,
  '3',
  'Window right 1/3',
  function()
    thirds('right')
  end
)
