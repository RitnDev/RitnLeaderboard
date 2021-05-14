local events = {}


local function on_player_cheat_mode_enabled(e)
    global.cheatModeActivated = 1
end

local function on_player_died(e)
	global.latestPlayerDeathTick = game.tick
end

local function on_rocket_launched(e)
	if (global.firstRocketLaunchedTick == nil) then
		global.firstRocketLaunchedTick = game.tick
	end
	global.latestRocketLaunchedTick = game.tick
end

local function on_research_finished(event)
	if (global.research == nil) then
		global.research = {}
	end

	global.research[event.research.name .. "#" .. event.research.level] =
		{
			name =event.research.name,
			level=event.research.level,
			force=event.research.force,
			tick=game.tick;
        }
end


--------------------------------------------------

commands.add_command("xp", "", 
  function (e)
	local LuaPlayer = game.players[e.player_index]
	if global.forces ~= nil then
		if global.forces[LuaPlayer.force.name] ~= nil then
			if global.forces[LuaPlayer.force.name].xp ~= nil then
				LuaPlayer.print("-> " .. LuaPlayer.force.name .. " : " .. global.forces[LuaPlayer.force.name].xp.total .. " xp.")
			else
				LuaPlayer.print("-> " .. LuaPlayer.force.name .. " : ??? xp.")
			end 
		end 
	end
  end 
)

commands.add_command("nb_item", "", 
  function (e)
	local LuaPlayer = game.players[e.player_index]
	local itemName = e.parameter
	if itemName == nil then 
		LuaPlayer.print("exemple : /nb_item iron-ore")
		return
	end

	if global.forces ~= nil then
		if global.forces[LuaPlayer.force.name] ~= nil then
			if game.item_prototypes[itemName] then
				if global.forces then
					if global.forces[LuaPlayer.force.name] then
						if global.forces[LuaPlayer.force.name].currentProductionStats then
							if global.forces[LuaPlayer.force.name].currentProductionStats[itemName] then 
								LuaPlayer.print("-> [item=" .. itemName .. "] = " .. global.forces[LuaPlayer.force.name].currentProductionStats[itemName].amount)
							else 
								LuaPlayer.print("-> [item=" .. itemName .. "] = " .. 0)
							end
						end
					end
				end
			end
		end 
	end
  end 
)

commands.add_command("init", "", 
function (e)
	local LuaPlayer = game.players[e.player_index]
	if LuaPlayer.admin == true then 
		global.leaderboard.last_force = false
	end
end 
)

commands.add_command("score", "", 
function (e)
	local LuaPlayer = game.players[e.player_index]local itemName = e.parameter
	if itemName == nil then 
		LuaPlayer.print("exemple : /score iron-ore")
		return
	end
	if LuaPlayer.admin == true then 
		for _,force in pairs(game.forces) do 
			if force.name ~= "enemy" or force.name ~= "neutral" then
				if global.forces then
					if global.forces[force.name] then
						if global.forces[force.name].currentProductionStats then
							if global.forces[force.name].currentProductionStats[itemName] then 
								LuaPlayer.print("-> " .. force.name .. " : [item=" .. itemName .. "] = " .. global.forces[force.name].currentProductionStats[itemName].amount)
							else 
								LuaPlayer.print("-> " .. force.name .. " : [item=" .. itemName .. "] = " .. 0)
							end
						end
					end
				end
			end
		end
	end
end 
)



---------------------------
events[defines.events.on_player_cheat_mode_enabled] = on_player_cheat_mode_enabled
events[defines.events.on_player_died] = on_player_died
events[defines.events.on_rocket_launched] = on_rocket_launched
events[defines.events.on_research_finished] = on_research_finished

return events