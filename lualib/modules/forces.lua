-- PLAYERS
---------------------------------------------------------------------------------------------
local libMod = "__RitnLib__"
local ritnlib = {}
ritnlib.utils  = 		require(libMod .. ".lualib.other-functions")
ritnlib.forces = 		require("lualib.functions.forces")
---------------------------------------------------------------------------------------------

local function ritnPrint(txt)
    ritnlib.utils.ritnPrint(txt)
end



local function on_forces_merged(e)
    local force_name = e.source_name
    local LuaForceDest = e.destination

    if string.sub(force_name,1,5) == "enemy" then return end
    if LuaForceDest.name ~= "player" then
        return
    else 
        global.forces[force_name] = nil
    end 
end




------------------------------------------------------------------------------
local module = {}
module.events = {}
------------------------------------------------------------------------------
module.events[defines.events.on_forces_merged] = on_forces_merged
------------------------------------------------------------------------------
return module