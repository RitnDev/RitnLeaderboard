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



local function on_player_joined_game(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    ritnlib.surface.addPlayer(LuaPlayer)
end




local function on_player_left_game(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    ritnlib.surface.removePlayer(LuaPlayer, LuaSurface)
end



------------------------------------------------------------------------------
local module = {}
module.events = {}
------------------------------------------------------------------------------
module.events[defines.events.on_player_joined_game] = on_player_joined_game
module.events[defines.events.on_player_left_game] = on_player_left_game
------------------------------------------------------------------------------
return module