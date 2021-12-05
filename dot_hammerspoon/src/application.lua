hs.hotkey.bind(hyper, '1', 'VSCode', function()
  hs.application.launchOrFocus('Visual Studio Code')
end)

hs.hotkey.bind(hyper, '2', 'Iterm', function()
  hs.application.launchOrFocus('Iterm')
end)

hs.hotkey.bind(hyper, '3', 'Firefox', function()
  hs.application.launchOrFocus('Firefox')
end)

hs.hotkey.bind(hyper, '4', 'Slack', function()
  hs.application.launchOrFocus('Slack')
end)

hs.hotkey.bind(hyper, '0', 'Spotify', function()
  hs.application.launchOrFocus('Spotify')
end)

-- Use to get name of application
-- hs.hotkey.bind(hyper, '8', function()
--   print(hs.application.find('code'))
-- end)

