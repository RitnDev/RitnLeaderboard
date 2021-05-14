--Init variable : global
require("core.global")
if script.active_mods["gvv"] then require("__gvv__.gvv")() end
-- Chargement de l'event listener :
local event_listener = require("__RitnLib__/lualib/event-listener")
-- envoie des modules à l'event listener :
event_listener.add_libraries(require("core.modules"))
require("lualib.leaderboard")