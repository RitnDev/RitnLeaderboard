-- MIGRATION
----------------------------------------------------
local module = {}
module.events = {}



-- Quand un joueur arrive en jeu
local function on_player_joined_game(e)

    -- Récupération de la version du mod actuelle
    local version = game.active_mods.RitnLeaderboard

    pcall(function() 
        if global.mod_version ~= version then 
            global.migration = true
        end
    end)

    if not global.mod_version then
        -- Ajout de la variable global : mod_version
        global.mod_version = "0.0.0"
        global.migration = true
    end

    local pattern = "([^.]*).?([^.]*).?([^.]*)"
    local vX, vY, vZ = string.match(global.mod_version, pattern)

    -- 0.3.x
    if tonumber(vX) <= 0 and tonumber(vY) <= 3 then
        
        -- 0.3.0
        if tonumber(vZ) == 0 then
            pcall(function() 
                if global.leaderboard then
                    if not global.leaderboard.forces then
                        global.leaderboard.forces = {}
                    end
                end
            end)
        end

        if tonumber(vZ) <= (1 or 2) then
            pcall(function() 
                if global.leaderboard then
                    if global.leaderboard.forces then
                        global.leaderboard.forces = nil
                    end
                    if not global.leaderboard.surfaces then
                        global.leaderboard.surfaces = {}
                    end
                end
            end)
        end

        if tonumber(vZ) <= 7 then
            pcall(function() 
                if global.leaderboard then
                    if global.leaderboard.surfaces then
                        for _,surface in pairs(global.leaderboard.surfaces) do 
                            local surface_name = surface.name
                            surface.index = game.surfaces[surface_name].index
                        end
                    end
                end
            end)
        end

    end


    if global.migration == true then
        global.migration = false
        global.mod_version = version
    end
end



module.events[defines.events.on_player_joined_game] = on_player_joined_game
return module