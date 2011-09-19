local oo            = require("loop.simple")
local AppletMeta    = require("jive.AppletMeta")
local appletManager = appletManager
local jiveMain      = jiveMain
local System        = require("jive.System")
local os            = require("os")

module(...)
oo.class(_M, AppletMeta)

function jiveVersion(meta)
   return 1, 1
end

function defaultSettings(meta)
   local defaultSetting = {}

   if os.getenv("SQUEEZEPLAY_ENVIRONMENT") == "development" then
      defaultSetting["url"] = "127.0.0.1"
      defaultSetting["env"] = "development"
   else
      defaultSetting["url"] = "192.168.1.11"
      defaultSetting["env"] = "production"
   end

   defaultSetting["port"] = 3000
   defaultSetting["path"] = "/data.json"

   defaultSetting["debug"] = defaultSetting["env"] .. " - " .. defaultSetting["url"] .. ":" .. defaultSetting["port"] .. defaultSetting["path"]

   return defaultSetting
end

function registerApplet(meta)
   jiveMain:addItem(meta:menuItem('travelInfoApplet', 'home', "TRAVELINFO", function(applet, ...) applet:menu(...) end, 20))
end

function configureApplet()
   
end


