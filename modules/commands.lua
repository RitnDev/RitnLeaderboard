-- MODULE : COMMANDS
---------------------------------------------------------------------------------

commands.add_command("xp", "", 
  function (e)
	local LuaPlayer = game.players[e.player_index]
	if global.leaderboard.forces ~= nil then
		if global.leaderboard.forces[LuaPlayer.force.name] ~= nil then
			if global.leaderboard.forces[LuaPlayer.force.name].xp ~= nil then
				LuaPlayer.print("-> " .. LuaPlayer.force.name .. " : " .. global.leaderboard.forces[LuaPlayer.force.name].xp.total .. " xp.")
				return
			end 
		end 
	end
	LuaPlayer.print("-> " .. LuaPlayer.force.name .. " : 0 xp.")
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

	if global.leaderboard.forces ~= nil then
		if global.leaderboard.forces[LuaPlayer.force.name] ~= nil then
			if game.item_prototypes[itemName] then
				if global.leaderboard.forces[LuaPlayer.force.name].production.current then
					if global.leaderboard.forces[LuaPlayer.force.name].production.current[itemName] then 
						LuaPlayer.print("-> [item=" .. itemName .. "] = " .. global.leaderboard.forces[LuaPlayer.force.name].production.current[itemName].amount)
						return
					end
				end
			else 
				log("> is not correct item !")
			end
		end 
	end
	LuaPlayer.print("-> [item=" .. itemName .. "] = " .. 0)
  end 
)

---------------------------------------------------------------------------------
return {}