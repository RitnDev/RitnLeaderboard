---------------------------------------------------------------------------------------------
local libMod = "__RitnLib__"
local ritnlib = {}
ritnlib.utils  = 		require(libMod .. ".lualib.other-functions")
---------------------------------------------------------------------------------------------

local function getCumul(surface_name)
    local join = global.leaderboard.surfaces[surface_name].join
    local left = global.leaderboard.surfaces[surface_name].left
    return left - join
end


local function createSurfaceTime(surface_name)
    if not global.leaderboard.surfaces[surface_name] then
        global.leaderboard.surfaces[surface_name] = {
				name = surface_name,
                index = game.surfaces[surface_name].index,
                join = 0,
                left = 0,
                total = 0,
                map_used = false,
                players = {},
        }
		print(">> create surface time ! (" .. surface_name .. ")")
    end
end

local function removeSurfaceTime(surface_index)
    for _,surface in pairs(global.leaderboard.surfaces) do 
        if surface.index == surface_index then
            local surface_name = surface.name
            global.leaderboard.surfaces[surface_name] = nil
            print(">> remove surface time ! (" .. surface_name .. ")")
            return
        end
    end
end


local function addPlayer(LuaPlayer)
    local LuaSurface = LuaPlayer.surface
    createSurfaceTime(LuaSurface.name)

    global.leaderboard.surfaces[LuaSurface.name].players[LuaPlayer.name] = {
        name = LuaPlayer.name,
    }
    
    if global.leaderboard.surfaces[LuaSurface.name].map_used == false then 
        global.leaderboard.surfaces[LuaSurface.name].join = game.tick
    end
    global.leaderboard.surfaces[LuaSurface.name].map_used = ritnlib.utils.tableBusy(global.leaderboard.surfaces[LuaSurface.name].players)
end
  
local function removePlayer(LuaPlayer, oldSurface)
    -- 0.3.2
    if not global.leaderboard.surfaces then global.leaderboard.surfaces = {} end 
    if not global.leaderboard.surfaces[oldSurface.name] then return end

    for i,player in pairs(global.leaderboard.surfaces[oldSurface.name].players) do
        if global.leaderboard.surfaces[oldSurface.name].players[i].name == LuaPlayer.name then 
          global.leaderboard.surfaces[oldSurface.name].players[i] = nil
        end 
    end
    
    global.leaderboard.surfaces[oldSurface.name].map_used = ritnlib.utils.tableBusy(global.leaderboard.surfaces[oldSurface.name].players)
    if global.leaderboard.surfaces[oldSurface.name].map_used == false then 
        global.leaderboard.surfaces[oldSurface.name].left = game.tick
        local cumul = getCumul(oldSurface.name)
        local total = global.leaderboard.surfaces[oldSurface.name].total
        global.leaderboard.surfaces[oldSurface.name].total = total + cumul
    end
end





-----------------------------------------------
local flib = {}
flib.createSurfaceTime = createSurfaceTime
flib.removeSurfaceTime = removeSurfaceTime
flib.addPlayer = addPlayer
flib.removePlayer = removePlayer

return flib