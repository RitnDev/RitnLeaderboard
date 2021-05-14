-- PLAYERS
---------------------------------------------------------------------------------------------
local libMod = "__RitnLib__"
local ritnlib = {}
ritnlib.utils  = 		require(libMod .. ".lualib.other-functions")
ritnlib.surface = 		require("lualib.functions.surfaces")
---------------------------------------------------------------------------------------------

local function ritnPrint(txt)
    ritnlib.utils.ritnPrint(txt)
end




local function on_player_changed_surface(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    local oldSurface = game.surfaces[e.surface_index]
  
    ritnlib.surface.addPlayer(LuaPlayer)
    ritnlib.surface.removePlayer(LuaPlayer, oldSurface)
end


local function on_surface_deleted(e)
    ritnlib.surface.removeSurfaceTime(e.surface_index)
end




------------------------------------------------------------------------------
local module = {}
module.events = {}
------------------------------------------------------------------------------
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_surface_deleted] = on_surface_deleted
------------------------------------------------------------------------------
return module