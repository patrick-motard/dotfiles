--[[

focus.lua

Set application bindings here!

]]--

local Json = require("src/json")
require("table")
require("src/notify")

local FLAGS_bookmark_path = "bookmarks/bookmarks.json"
local FLAGS_completed_colorId = "10"
local FLAGS_completed_color = "#51b749"

local FLAGS_incomplete_colorId = "4"
local FLAGS_incomplete_color = "#ff887c"

-- Iterate over a table in sorted order
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- Function to load a json file into table
local function loadTable(filename)
    local contents = ""
    local myTable = {}
    local file = io.open( cwd..filename, "r" )

    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        myTable = Json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end

local function loadBookmarks()
    local out = {}
    local bookmarks = loadTable(FLAGS_bookmark_path)['bookmarks']
    for k, v in pairs(bookmarks) do
        out[#out + 1] = {title = "Open "..v['title'].."...", fn=function() hs.urlevent.openURL(v['url']) end}
    end
    return out
end

local function refreshMenuTitle(menu, menu_table)
    menu:setMenu(menu_table)
    menu_title = "No tasks found!"
    for k,v in pairs(menu_table) do
        if not v['checked'] and v['summary'] then
            menu_title = v['time'].." - "..v['summary']
            break
        end
    end
    menu:setTitle(menu_title)
end

local function makeDot(hex_color)
    return hs.styledtext.new("●", {color = { hex = hex_color}, font = { size = 11 }})..hs.styledtext.new(" ", hs.styledtext.defaultFonts.menu)
end

local function makeTitle(color, time, title)
    return makeDot(color)..time.." - "..title
end

local function updateEvent(menu, menu_table, event)
    if event['checked'] then
        -- reset to original color
        event['checked'] = false
        event['title'] = makeTitle(FLAGS_incomplete_color, event['time'], event['summary'])
        os.execute(PYTHON_BINARY.." "..cwd.."gcal/gcal.py -u "..event['id'].." "..FLAGS_incomplete_colorId)
    else
        -- set to completed color
        event['checked'] = true
        event['title'] = makeTitle(FLAGS_completed_color, event['time'], event['summary'])
        os.execute(PYTHON_BINARY.." "..cwd.."gcal/gcal.py -u "..event['id'].." "..FLAGS_completed_colorId)
        -- set color to something good
    end
    refreshMenuTitle(menu, menu_table)
end

local menu = hs.menubar.new()
local menu_table = {}

-- Refreshes events and sets menu to first event
local function refreshMenu()
    if not menu then
        return
    end

    -- clear the menu
    menu_table = {}

    -- Execute python script to fetch calendar events
    notify("Google Calendar", "Refreshing events ... ", nil, nil)
    os.execute(PYTHON_BINARY.." "..cwd.."gcal/gcal.py -e")
    print(PYTHON_BINARY.." "..cwd.."gcal/gcal.py -e", nil, nil, nil)

    -- attach bookmarks
    bookmark_menu = loadBookmarks()
    for k, v in pairs(bookmark_menu) do
        menu_table[#menu_table + 1] = v
    end

    events = loadTable("src/gcal/events.json")
    for _, date_events in spairs(events) do
        date = date_events["date"]
        event_list = date_events["events"]

        -- Construct title menu
        menu_table[#menu_table + 1] = {title="-"}
        menu_table[#menu_table + 1] = {title=date}
        menu_table[#menu_table + 1] = {title="-"}
        for k,v in pairs(event_list) do
            local event = {
                title = makeTitle(v['color'], v['time'], v['title']),
                color=v['color'],
                colorId = v['colorId'],
                checked=v['colorId'] == '10',
                time=v['time'],
                summary=v['title'],
                id = v['id'],
            }
            event['fn'] = function() updateEvent(menu, menu_table, event) end
            menu_table[#menu_table + 1] = event
        end
    end
    refreshMenuTitle(menu, menu_table)
end

-- First call initializes menu
refreshMenu()

-- Refreshes menu every 30 minutes
timer = hs.timer.doEvery(3600, refreshMenu)

-- Binds hotkey to refresh menu
hs.hotkey.bind(hyper, "-", refreshMenu)

