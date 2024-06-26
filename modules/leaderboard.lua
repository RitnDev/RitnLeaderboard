-- INITIALISATION
---------------------------------------------------------------------------------------------
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)


local function on_tick(event)

	-- 
	if event.tick % 3600 == (global.leaderboard.coeff_decal*global.leaderboard.index_decal) then
		
		-- si on a pas encore atteint la dernier force de la liste
		if global.leaderboard.last_force == false then
			local nb_forces = remote.call("RitnCoreGame", "get_values", "forces")
			
			-- si c'est le premier passage on initialise la synthese des stats global
			if global.leaderboard.index_decal == 1 then
				if (global.leaderboard.previousTick < 0) then
					local rForceSynth = RitnLeaderboardForceSynth():initLeaderboard()
				end
			end

			
			-- liste des force dans global.core.forces
			local forces = remote.call("RitnCoreGame", "get_forces")
			
			-- récupération du nom de la force se trouvant à l'index_decal dans global.core.forces
			-- ex: index = 1 
			-- | global.core.forces = { "player": {name: "player", ...}, ... } 
			-- | return : "player"
			local force_name = string.defaultValue(table.getIndex(forces, global.leaderboard.index_decal))
			
			-- on vérifie que cette force est bien dans la liste
			if (forces[force_name]) then 

				-- On récupère l'index de la force sélectionnée
				local index = forces[force_name].index

				-- Calcule des stats pour la force sélectionnée
				local rForce = RitnLeaderboardForce(game.forces[index])
				rForce:initLeaderboard():calculStats()

				-- mise à jour des statistiques global à toutes les forces
				RitnLeaderboardForceSynth():initLeaderboard(rForce):calculStats()	

				-- On a récupérer les stats de toutes les forces listés
				if global.leaderboard.index_decal == nb_forces then
					global.leaderboard.last_force = true
				end

			end

			-- increment index de decallage
			if global.leaderboard.index_decal == 64 then 
				global.leaderboard.index_decal = 1
			else 
				-- On incrémente l'index de décallage
				global.leaderboard.index_decal = global.leaderboard.index_decal + 1
			end
		end

	end

	if event.tick % 3600 == 0 then 
		local is_start = remote.call("RitnCoreGame", "isStart")
		if is_start and global.leaderboard.last_force then
			
			local firstEvent = (global.leaderboard.previousTick < 0)
			
			-- chargement des stats globals avant envoie dans les logs
			local rForceSynth = RitnLeaderboardForceSynth():loadLeaderboard()


--[[

			-- Player list
			local players = {}
			global.players_online = 0
			for _, player in pairs(game.players) do
				players[player.name] = {
					name =player.name,
					online_time=player.online_time,
					last_online=player.last_online,
					online=player.connected
				}
				if player.connected then global.players_online = global.players_online + 1 end
			end

						
			output = writeToOutput(output, "players=" .. game.table_to_json(players) .. ",\r\n");
		
			
			-- Pollution
			output = writeToOutput(output, "pollution_in=" .. game.table_to_json(game.pollution_statistics.input_counts) .. ",\r\n");
			output = writeToOutput(output, "pollution_out=" .. game.table_to_json(game.pollution_statistics.output_counts) .. ",\r\n");

]]

			-- Update previous.
			global.leaderboard.previousTick = game.tick

			-- Write output to file
			if (not firstEvent) then

				local rLog = RitnLog("leaderboard"):setModName("RitnLeaderboard")
				rLog:setData(rForceSynth.data_leaderboard):trace()

			end
			
			-- réinitilisation des valeurs de calcul
			global.leaderboard.last_force = false
			global.leaderboard.index_decal = 1
		end
    end
end


script.on_event({defines.events.on_tick}, on_tick)

--------------------------------------------------
return {}