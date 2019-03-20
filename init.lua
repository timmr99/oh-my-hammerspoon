--
--   o88               o88    o8       o888
--   oooo  oo oooooo   oooo o888oo      888 oooo  oooo   ooooooo
--    888   888   888   888  888        888  888   888   ooooo888
--    888   888   888   888  888   ooo  888  888   888 888    888
--   o888o o888o o888o o888o  888o 888 o888o  888o88 8o 88ooo88 8o
--

--------------------------------------------------------------------------------
-- Load/Reload applications at specified locations
--------------------------------------------------------------------------------

-- as of 10-24-17
-- hs.application: iTerm2 (0x7fb2129da088)            hs.geometry.rect(    0.0, 1289.0, 1440.0, 1251.0)
-- hs.application: Emacs (0x7fb212962218)             hs.geometry.rect(    0.0,   23.0, 1434.0, 1258.0)
-- hs.application: Evernote (0x7fb2183470e8)          hs.geometry.rect( 1440.0, 1683.0, 1440.0,  873.0)
-- hs.application: Google Chrome (0x7fb21295f518)     hs.geometry.rect(-1440.0,   23.0, 1440.0, 1238.0)
-- hs.application: Microsoft Outlook (0x7fb21813be08) hs.geometry.rect(-1435.0, 1262.0, 1435.0,  650.0)
-- hs.application: HipChat (0x7fb21295a988)           hs.geometry.rect(-1438.0, 1915.0, 1440.0,  642.0)


local windowLayout = {
   ["Emacs"]              = { ["geometery"] = { x =  1280.0, y =    23.0, w =  1280.0, h =  1412.0}, } ,
   ["Evernote"]           = { ["geometery"] = { x =  2560.0, y =   345.0, w =  1440.0, h =   877.0}, } ,
   ["Google Chrome"]      = { ["geometery"] = { x = -1280.0, y =    23.0, w =  1280.0, h =  1417.0}, } ,
   ["HipChat"]            = { ["geometery"] = { x = -2560.0, y =   990.0, w =  1279.0, h =   450.0}, } ,
   ["Microsoft Outlook"]  = { ["geometery"] = { x =  2560.0, y =   345.0, w =  1440.0, h =   877.0}, } ,
   ["Slack"]              = { ["geometery"] = { x = -2560.0, y =    23.0, w =  1279.0, h =   966.0}, } ,
   ["iTerm2"]             = { ["geometery"] = { x =    -0.0, y =    23.0, w =  1277.0, h =  1417.0}, } 
}


hs.alert.closeAll()
hs.application.enableSpotlightForNameSearches(true)

local ignored = require 'ignored'

-- key define
local drible      = {'ctrl', 'cmd'}
local dribleShift = {'ctrl', 'cmd', 'shift'}
local prefix      = {'ctrl', 'alt'}
local prefixShift = {'ctrl', 'alt', 'shift'}
local hyper       = {'ctrl', 'alt', 'cmd'}
local hyperShift  = {'ctrl', 'alt', 'cmd', 'shift'}

-- states
hs.window.animationDuration = 0

-- cli
-- if not hs.ipc.cliStatus() then hs.ipc.cliInstall() end

-- App launched
local function isempty(s)
   return s == nil or s == ''
end

function setAppFrame( appName )
   hs.alert.show(appName)
   print("[************************************************************")
   print(appName)
   if hs.application.launchOrFocus(appName) then
      local app = hs.application.find(appName)
      print(app)
      if app == "Emacs" then
         hs.timer.usleep(3000)
      end
      if not windowLayout[appName].geometery then
         app:mainWindow():setFrame(windowLayout[appName].geometery)
         print('x:', windowLayout[appName].geometery.x,
               ' y:', windowLayout[appName].geometery.y,
               ' w:', windowLayout[appName].geometery.w,
               ' h:', windowLayout[appName].geometery.h)
         app:mainWindow():focus()
      end
   else
      hs.alert.show("Failed to launch " .. appName)
   end
   print("************************************************************]")
end


-- App shortcuts
local keyApp = {
   C = 'Google Chrome',
   E = 'Emacs',
   H = 'HipChat', 
   O = 'Microsoft Outlook',
   S = 'Slack',   
   T = 'iTerm2', 
   Z = 'Evernote',
}

for key, app in pairs(keyApp) do
   print("****************************************\n",key,app,"\n****************************************")
   hs.hotkey.bind(prefixShift, key, function() setAppFrame(app) end)
end

-- Hints
hs.hotkey.bind(drible, 'h', function() 
                  hs.hints.windowHints(getAllValidWindows()) 
end)

hs.hotkey.bind(drible, 'c', function()
                  hs.console.clearConsole()
end)

-- iTunes control
hs.hotkey.bind(dribleShift, '7', function() hs.itunes.previous() end)
hs.hotkey.bind(dribleShift, '8', function() hs.itunes.playpause() end)
hs.hotkey.bind(dribleShift, '9', function() hs.itunes.next() end)


-- Sound
--- dod default_output_audio
dod = hs.audiodevice.defaultOutputDevice()
hs.hotkey.bind(dribleShift, '0', function()
                  is_muted = dod:muted()
                  if is_muted then
                     dod:setMuted(false)
                     hs.alert('Audio is unmuted!')
                  else
                     dod:setMuted(true)
                     hs.alert('Audio is muted!')
                  end
end)
hs.hotkey.bind(dribleShift, '-', function()
                  auv = dod:outputVolume() - 5
                  dod:setVolume(auv)
                  hs.alert('Volume down:' .. auv)
                  print(dod:outputVolume())
end)

hs.hotkey.bind(dribleShift, '=', function()
                  auv = dod:outputVolume() + 5
                  dod:setVolume(auv)
                  hs.alert('Volume up:' .. auv)
                  print(dod:outputVolume())
end)

-- undo
local undo = require 'undo'
hs.hotkey.bind(hyper, 'z', function() undo:undo() end)

-- -- Grids
hs.grid.GRIDWIDTH = 16
hs.grid.GRIDHEIGHT = 8
hs.grid.MARGINX = 0
hs.grid.MARGINY  = 0

local maxWidth      = hs.grid.GRIDWIDTH
local maxHeight     = hs.grid.GRIDHEIGHT

local halfMaxWidth  = hs.grid.GRIDWIDTH / 2
local halfMaxHeight = hs.grid.GRIDHEIGHT / 2

local thrdMaxWidth  = hs.grid.GRIDWIDTH / 3
local thrdMaxHeight = hs.grid.GRIDHEIGHT / 3


local qtrMaxWidth  = hs.grid.GRIDWIDTH / 4
local qtrMaxHeight = hs.grid.GRIDHEIGHT / 4


local moveMaxWidth  = halfMaxWidth + 1
local moveMinWidth  = halfMaxWidth - 1
local moveMaxHighth = halfMaxWidth + 1
local moveMinHighth = halfMaxWidth - 1


-- Move Window
function locationSet(pos_x, pos_y, width, height)
   local w = hs.window.focusedWindow()
   if not w or not w:isStandard() then return end
   local s = w:screen()
   if not s then return end
   if ignored(w) then return end
   local g = hs.grid.get(w)

   if pos_x ~= -1 then 
      g.x = pos_x 
   end
   if pos_y ~= -1 then 
      g.y = pos_y 
   end

   if pos_x + width > hs.grid.GRIDWIDTH then
      g.w = hs.grid.GRIDWIDTH - pos_x
   else
      g.w = width
   end
   
   if pos_y + height > hs.grid.GRIDHEIGHT then
      g.h = hs.grid.GRIDHEIGHT - pos_y
   else
      g.h = height
   end

   undo:addToStack()
   hs.grid.set(w, g, s)
end


function straightlyMove(step_x, step_y)
   local w = hs.window.focusedWindow()
   if not w or not w:isStandard() then return end
   local s = w:screen()
   if not s then return end
   if ignored(w) then return end
   local g = hs.grid.get(w)
   
   -- if moving to the edge
   if step_x < 0 and g.x <= 0 and g.w <= 1 then
      return
   elseif step_y < 0 and g.y <= 0 and g.h <= 1 then
      return
   elseif step_x > 0 and g.x + g.w >= hs.grid.GRIDWIDTH and g.w <= 1 then
      return
   elseif step_y > 0 and g.y + g.h >= hs.grid.GRIDHEIGHT and g.h <= 1 then
      return
   end

   if step_x < 0 and g.x <= 0 then
      g.w = g.w - 1
   elseif step_x > 0 and g.x + g.w >= hs.grid.GRIDWIDTH then
      g.x = g.x + 1
      g.w = g.w - 1
   else
      g.x = g.x + step_x
   end


   if step_y < 0 and g.y <= 0 then
      g.h = g.h - 1
   elseif step_y > 0 and g.y + g.h >= hs.grid.GRIDHEIGHT then
      g.y = g.y + 1
      g.h = g.h - 1
   else
      g.y = g.y + step_y
   end

   undo:addToStack()
   hs.grid.set(w, g, s)
end


function straightlyExtend(step_x, step_y)
   local w = hs.window.focusedWindow()
   if not w or not w:isStandard() then return end
   local s = w:screen()
   if not s then return end
   if ignored(w) then return end
   local g = hs.grid.get(w)
   
   -- if moving to the edge
   if step_x < 0 and g.x <= 0 then
      return
   elseif step_y < 0 and g.y <= 0 then
      return
   elseif step_x > 0 and g.x + g.w >= hs.grid.GRIDWIDTH then
      return
   elseif step_y > 0 and g.y + g.h >= hs.grid.GRIDHEIGHT then
      return
   end

   if step_x < 0 then
      g.x = g.x - 1
      g.w = g.w + 1
   elseif step_x > 0 then
      g.w = g.w + 1
   end

   if step_y < 0 then
      g.y = g.y - 1
      g.h = g.h + 1
   elseif step_y > 0 then
      g.h = g.h + 1
   end

   undo:addToStack()
   hs.grid.set(w, g, s)
end


local topHalf       = hs.hotkey.bind(hyper, 't', function() locationSet(0,0,maxWidth,halfMaxHeight) end)
local bottomHalf    = hs.hotkey.bind(hyper, 'b', function() locationSet(0,halfMaxHeight,maxWidth,halfMaxHeight) end)

local width         = hs.hotkey.bind(hyper, 'w', function() locationSet(0,-1, maxWidth, thrdMaxHeight) end)


local leftTop       = hs.hotkey.bind(hyper, 'u', function() locationSet(0, 0, halfMaxWidth, halfMaxHeight) end)
local rightTop      = hs.hotkey.bind(hyper, 'i', function() locationSet(halfMaxWidth, 0, halfMaxWidth, halfMaxHeight) end)
local leftBottom    = hs.hotkey.bind(hyper, 'j', function() locationSet(0, halfMaxHeight, halfMaxWidth, halfMaxHeight) end)
local rightBottom   = hs.hotkey.bind(hyper, 'k', function() locationSet(halfMaxWidth, halfMaxHeight, halfMaxWidth, halfMaxHeight) end)
local leftHalf      = hs.hotkey.bind(hyper, 'h', function() locationSet(0, 0, halfMaxWidth, hs.grid.GRIDHEIGHT) end)
local rightHalf     = hs.hotkey.bind(hyper, 'l', function() locationSet(halfMaxWidth, 0, halfMaxWidth, hs.grid.GRIDHEIGHT) end)

local fullScreen    = hs.hotkey.bind(hyper, 'f', function() hs.grid.maximizeWindow() end)
local centerScreen  = hs.hotkey.bind(hyper, 'c', function() locationSet(halfMaxWidth / 4, halfMaxHeight / 4, halfMaxWidth * 3 / 2, halfMaxHeight * 3 / 2) end)

local upMove        = hs.hotkey.bind(hyper, 'up', function() straightlyMove(0, -1) end)
local downMove      = hs.hotkey.bind(hyper, 'down', function() straightlyMove(0, 1) end)
local leftMove      = hs.hotkey.bind(hyper, 'left', function() straightlyMove(-1, 0) end)
local rightMove     = hs.hotkey.bind(hyper, 'right', function() straightlyMove(1, 0) end)

local upExtend      = hs.hotkey.bind(hyperShift, 'up', function() straightlyExtend(0, -1) end)
local downExtend    = hs.hotkey.bind(hyperShift, 'down', function() straightlyExtend(0, 1) end)
local leftExtend    = hs.hotkey.bind(hyperShift, 'left', function() straightlyExtend(-1, 0) end)
local rightExtend   = hs.hotkey.bind(hyperShift, 'right', function() straightlyExtend(1, 0) end)


-- Move Screen
hs.hotkey.bind(dribleShift, 'left', function() 
                  local w = hs.window.focusedWindow()
                  if not w then 
                     return
                  end
                  if ignored(w) then return end

                  local s = w:screen():toWest()
                  if s then
                     undo:addToStack()
                     w:moveToScreen(s)
                  end
end)

hs.hotkey.bind(dribleShift, 'right', function() 
                  local w = hs.window.focusedWindow()
                  if not w then 
                     return
                  end
                  if ignored(w) then return end
                  
                  local s = w:screen():toEast()
                  if s then
                     undo:addToStack()
                     w:moveToScreen(s)
                  end
end)

-- split view
SplitModal = require 'split_modal'
local splitModal = SplitModal.new(dribleShift, 'down', undo)

function splitModal:hotkeysToDisable()
   return {hyperUp, hyperRight, hyperLeft}
end

-- App layout
local AppLayout = {}
AppLayout['Safari'] = { large = true, full = true }
AppLayout['Tweetbot'] = { small = true }

function layoutApp(name, app, delayed)
   local conf = AppLayout[name]
   if not conf then return end

   if not delayed and conf.delay then
      print('delay layout '..name..' for '..conf.delay..' secs')
      hs.timer.doAfter(conf.delay, function() 
                          layoutApp(name, app, true)
      end)
      return
   end
   
   if not app then app = hs.appfinder.appFromName(name) end
   local w = nil
   if app then w = app:mainWindow() end
   if not w then return end
   local s = nil
   if conf.small then
      print('move app '..name..' to smallerScreen')
      s = smallerScreen
   end
   if conf.large then
      print('move app '..name..' to largerScreen')
      s = largerScreen
   end
   if s and s ~= w:screen() then w:moveToScreen(s) end

   if conf.full then
      print('maximize app '..name)
      w:maximize()
   end
end

function applicationWatcherCallback(name, event, app)
   if event == hs.application.watcher.launched then
      layoutApp(name, app)
   end
end

local appWatcher = hs.application.watcher.new(applicationWatcherCallback)
appWatcher:start()

-- screen change
function screenChanged()
   local ss = hs.screen.allScreens()
   local count = #ss
   if count ~= lastNumberOfScreens then
      lastNumberOfScreens = count
      local largest = 0
      for i = 1, lastNumberOfScreens do
         local s = ss[i]
         local size = s:frame().w * s:frame().h
         local preSmall = smallerScreen
         smallerScreen = s
         if size > largest then
            largest = size
            largerScreen = s
            if preSmall then smallerScreen = preSmall end
         end
      end
      print('NumberOfScreens '.. lastNumberOfScreens)
      for app, conf in pairs(AppLayout) do
         layoutApp(app, nil, true)
      end
   end
end

screenChanged()

local screenWatcher = hs.screen.watcher.new(screenChanged)
screenWatcher:start()

-- caffeinate
hs.hotkey.bind(dribleShift, 'c', function() 
                  local c = hs.caffeinate
                  if not c then return end
                  if c.get('displayIdle') or c.get('systemIdle') or c.get('system') then
                     if menuCaff then
                        menuCaffRelease()
                     else
                        addMenuCaff()
                        local type
                        if c.get('displayIdle') then type = 'displayIdle' end
                        if c.get('systemIdle') then type = 'systemIdle' end
                        if c.get('system') then type = 'system' end
                        hs.alert('Caffeine already on for '..type)
                     end
                  else
                     acAndBatt = hs.battery.powerSource() == 'Battery Power'
                     c.set('system', true, acAndBatt)
                     hs.alert('Caffeinated '..(acAndBatt and '' or 'on AC Power'))
                     addMenuCaff()
                  end
end)

function addMenuCaff()
   menuCaff = hs.menubar.new()
   menuCaff:setIcon("/Users/2owe/.hammerspoon/caffeine-on.pdf") 
   menuCaff:setClickCallback(menuCaffRelease)
end

function menuCaffRelease()
   local c = hs.caffeinate
   if not c then return end
   if c.get('displayIdle') then
      c.set('displayIdle', false, true)
   end
   if c.get('systemIdle') then
      c.set('systemIdle', false, true)
   end
   if c.get('system') then
      c.set('system', false, true)
   end
   if menuCaff then
      menuCaff:delete()
      menuCaff = nil
   end
   hs.alert('Decaffeinated')
end

-- console
hs.hotkey.bind(hyperShift, ';', hs.openConsole)

-- reload
hs.hotkey.bind(hyper, 'escape', function() hs.reload() end )

function reloadConfig(files)
   doReload = false
   for _,file in pairs(files) do
      if file:sub(-4) == ".lua" then
         doReload = true
      end
   end
   if doReload then
      hs.reload()
   end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- utils
function getAllValidWindows ()
   local allWindows = hs.window.allWindows()
   local windows = {}
   local index = 1
   for i = 1, #allWindows do
      local w = allWindows[i]
      if w:screen() then
         windows[index] = w
         index = index + 1
      end
   end
   return windows
end

--------------------------------------------------------------------------------
-- create watcher for lock/unlock events
--------------------------------------------------------------------------------

hs.hotkey.bind({"alt", "ctrl"}, "D", function()
      hs.caffeinate.logOut()
end)

-- lock screen
hs.hotkey.bind({"alt", "ctrl"},"L", function()
      hs.caffeinate.lockScreen()
end)


secondsSinceEpoch = 0


function didBecomeActive()
   print("*sessionDidBecomeActive")
   currentTime = hs.timer.secondsSinceEpoch()
   delta = currentTime - secondsSinceEpoch
   if delta > 3600 then
      print("Hours: " .. delta/3600)
   elseif delta > 60 then
      print("Minutes: " .. delta/60)
   else
      print("Seconds: " .. delta )
   end

end

function didResign()
   print("*sessionDidResignActive")
   secondsSinceEpoch = hs.timer.secondsSinceEpoch()
end

function eventOccurred(event)

   if event == hs.caffeinate.watcher.screensaverDidStart          then print("screensaverDidStart")
   elseif event == hs.caffeinate.watcher.screensaverDidStop       then print("screensaverDidStop")
   elseif event == hs.caffeinate.watcher.screensaverWillStop      then print("screensaverWillStop")
   elseif event == hs.caffeinate.watcher.screensDidLock           then print("screensDidLock")
   elseif event == hs.caffeinate.watcher.screensDidSleep          then didResign()
   elseif event == hs.caffeinate.watcher.screensDidUnlock         then print("screensDidUnlock")
   elseif event == hs.caffeinate.watcher.screensDidWake           then didBecomeActive()
   elseif event == hs.caffeinate.watcher.sessionDidBecomeActive   then print("sessionDidBecomeActive")
   elseif event == hs.caffeinate.watcher.sessionDidResignActive   then print("sessionDidResignActive")
   elseif event == hs.caffeinate.watcher.systemDidWake            then print("systemDidWake")
   elseif event == hs.caffeinate.watcher.systemWillPowerOff       then print("systemWillPowerOff")
   elseif event == hs.caffeinate.watcher.systemWillSleep          then print("systemWillSleep")
   end
end

local caffeinateWatcher = hs.caffeinate.watcher.new(eventOccurred):start()


-- Get existing window's geometery

hs.hotkey.bind({"cmd","alt","ctrl","shift"},"f12",function()
      for name,other in pairs(windowLayout) do
         local app = hs.application.find(name)
         print(app)
         w = app:mainWindow()
         print(w:frame())
      end
end)

hs.hotkey.bind({"cmd","alt","ctrl","shift"},"f11",function()
      print("****************************************\nLaunch All\n****************************************\n")
      for name,other in pairs(windowLayout) do
         setAppFrame(name)
      end
end)



hs.alert('Hammerspoon', 0.6)
