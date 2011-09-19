--[[
=head1 NAME

applets.TravelInfo.TravelApplet - Live Travel Info Applet

=head1 DESCRIPTION

Displays live departure board

=head1 FUNCTIONS

Applet related methods are described in L<jive.Applet>. 

=cut
--]]


-- stuff we use
local oo               = require("loop.simple")
local string           = require("string")
local io               = require("io")
local os               = require("os")
local math             = require("math")

local Applet           = require("jive.Applet")
local Window           = require("jive.ui.Window")
local Textarea         = require('jive.ui.Textarea')
local Label            = require('jive.ui.Label')
local SimpleMenu       = require("jive.ui.SimpleMenu")
local Icon             = require("jive.ui.Icon")
local System           = require("jive.System")
local Surface          = require("jive.ui.Surface")

local RequestJsonRpc   = require("jive.net.RequestJsonRpc")
local SocketHttp       = require("jive.net.SocketHttp")
local jnt              = jnt
local json             = json
local http             = SocketHttp(jnt, "127.0.0.1", 3000, "travelinfo")

local require          = require
local tostring         = tostring
local pairs            = pairs
local ipairs           = ipairs
local table            = table

module(...)
oo.class(_M, Applet)

function menu(self, menuItem)
   local window = Window("window", "Travel")
   local menu   = SimpleMenu("menu")

   -- create a sink to receive JSON
   local function mySink(t, err)
      if err then
         log:error("Could not load TravelInfo data")
         local textarea = Textarea("text", ("Sorry, I couldn't load the list of services"))
         window:addWidget(textarea)
      elseif t then
         for _, entry in pairs(t) do
            local image = Surface:loadImage("applets/TravelInfo/" .. entry.vehicle .. ".png")
            local icon  = Icon("icon", image)
            menu:addItem({
                            text = entry.title,
                            weight = entry.weight,
                            icon = icon,
                            sound = "WINDOWSHOW",
                            callback = function()
                                          self:showEntry(entry)
                                       end
                         })
         end
         menu:setComparator(menu.itemComparatorWeightAlpha)
         window:addWidget(menu)
      end
      window:show()
   end

   local myRequest = RequestJsonRpc(mySink, ('/data.json'))
   http:fetch(myRequest)
end

-- TODO: timer and reload, Comet?
function showEntry(self, entry)
   local window   = Window("text_list", entry.title) 
   local textarea = Textarea("text")

   -- If this menu is added, the textarea widget does not show in the controller
   -- local menu = SimpleMenu("menu", {
   --                            { text = "Back",
   --                              sound = "WINDOWHIDE",
   --                              callback = function()
   --                                            window:hide()
   --                                         end
   --                           }
   --                         })
   -- window:addWidget(menu)

   local function mySink(t, err)
      if err then
         log:error("Could not load TravelInfo data")
         -- TODO: show error message
         textarea:setValue("Sorry, I couldn't load travel info for this service")
      elseif t then
         local e = t[entry.source]
         if e then
            local age_in_seconds = os.time() - e.updated_at
            local age_str = ""
            if age_in_seconds > 120 then
               age_str = math.floor(age_in_seconds / 60) .. " minutes ago"
            else
               age_str = age_in_seconds .. " seconds ago"
            end
            textarea:setValue(e.description .. "\n\n----\n" .. e.departures .. "\n\n----\nUpdated " .. age_str)
         else
            textarea:setvalue("Sorry, there is no travel info for this service")
         end
      end
      window:addWidget(textarea)
      window:show()
   end

   local myRequest = RequestJsonRpc(mySink, ('/data.json'))
   http:fetch(myRequest)
end
