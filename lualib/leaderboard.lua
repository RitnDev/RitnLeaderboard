-- INITIALISATION
---------------------------------------------------------------------------------------------
local libMod = "__RitnLib__"
local ritnlib = {}
ritnlib.utils  = 		require(libMod .. ".lualib.other-functions")
ritnlib.forces = 		require("lualib.functions.forces")
---------------------------------------------------------------------------------------------
local output
local decal = 30


local function ritnPrint(txt)
    ritnlib.utils.ritnPrint(txt)
end



local function on_tick(event)

	if not global.forces then global.forces = {amount = 0} end
	if not global.synth then global.synth = {} end


	if event.tick % 3600 == (decal*global.leaderboard.index_decal) then

		--ritnPrint("test")
		
		if global.leaderboard.last_force == false then
			local nb_forces = ritnlib.forces.count_forces()

			if global.leaderboard.index_force < nb_forces then
				global.leaderboard.index_force = global.leaderboard.index_force + 1
			end

			if global.leaderboard.index_force == nb_forces then
				global.leaderboard.last_force = true
			end

			local firstEvent = (global.leaderboard.previousTick == nil);

			if global.leaderboard.index_decal == 1 then
				if (not firstEvent) then
				global.synth.previousProductionStats = global.synth.currentProductionStats
				end
				global.synth.currentProductionStats = {}
				global.synth.kill_count_in = {}
				global.synth.kill_count_out = {}
				global.synth.rockets_launched = 0
				global.synth.enemy = 0
				global.synth.spawner = 0
				global.synth.xp = 0
				global.synth.items_launched = {}
				global.is_start = true
			end

			if not game.forces[global.leaderboard.index_force] then
				global.leaderboard.index_decal = global.leaderboard.index_decal + 1
				return 
			end
			if string.sub(game.forces[global.leaderboard.index_force].name, 1, 5) == "enemy" then
				global.leaderboard.index_decal = global.leaderboard.index_decal + 1
				return 
			end
			if game.forces[global.leaderboard.index_force].name == "neutral" then
				global.leaderboard.index_decal = global.leaderboard.index_decal + 1
				return 
			end
			
			ritnlib.forces.stats_force(firstEvent, game.forces[global.leaderboard.index_force])
			global.leaderboard.index_decal = global.leaderboard.index_decal + 1
		end

	end

	if event.tick % 3600 == 0 then 
		if global.is_start == true then
			if output == nil then output = "" end
			output = ""
			output = ritnlib.utils.writeToOutput(output, "currentTick=" .. game.tick .. "\r\n")
			
			local firstEvent = (global.leaderboard.previousTick == nil);

			-- GameId
			if (global.gameId == nil) then
				global.gameId = ritnlib.utils.uuid();
			end

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

						
			output = ritnlib.utils.writeToOutput(output, "players=" .. game.table_to_json(players) .. "\r\n");
		
			
			-- Pollution
			output = ritnlib.utils.writeToOutput(output, "pollution_in=" .. game.table_to_json(game.pollution_statistics.input_counts) .. "\r\n");
			output = ritnlib.utils.writeToOutput(output, "pollution_out=" .. game.table_to_json(game.pollution_statistics.output_counts) .. "\r\n");
			

			-- Killed/Lost
			output = ritnlib.utils.writeToOutput(output, "kill_count_in=" .. game.table_to_json(global.synth.kill_count_in) .. "\r\n");
			output = ritnlib.utils.writeToOutput(output, "kill_count_out=" .. game.table_to_json(global.synth.kill_count_out) .. "\r\n");

			-- Rockets launched
			output = ritnlib.utils.writeToOutput(output, "rockets_launched=" .. global.synth.rockets_launched .. "\r\n");
			
			-- Launched items
			output = ritnlib.utils.writeToOutput(output, "items_launched=" .. game.table_to_json(global.synth.items_launched) .. "\r\n");

			-- Active mods
			output = ritnlib.utils.writeToOutput(output, "active_mods=" .. game.table_to_json(game.active_mods) .. "\r\n")	
			--Map generator settings
			output = ritnlib.utils.writeToOutput(output, "default_map_gen_settings=" .. game.table_to_json(game.default_map_gen_settings) .. "\r\n");

			--Scenario finished
			local finished = 0
			if (game.finished == true) then
				finished = 1
			end
			output = ritnlib.utils.writeToOutput(output, "finished=" .. finished .. "\r\n");
			
			--Is multiplayer
			local multiplayer = 0
			if (game.is_multiplayer() == true) then
				multiplayer = 1
			end
			output = ritnlib.utils.writeToOutput(output, "is_multiplayer=" .. multiplayer .. "\r\n");

			--Difficulty settings
			output = ritnlib.utils.writeToOutput(output, "difficulty=" .. game.difficulty .. "\r\n");
			
			--Map_exchange string
			output = ritnlib.utils.writeToOutput(output, "map_exchange_string=" .. game.get_map_exchange_string() .. "\r\n");
			
			--Ticks played
			output = ritnlib.utils.writeToOutput(output, "ticks_played=" .. game.ticks_played .. "\r\n");

			-- Write Previous game tick
			if (not firstEvent) then
				output = ritnlib.utils.writeToOutput(output, "previousTick=" .. global.leaderboard.previousTick .. "\r\n");
			end

			--Write globals
			output = ritnlib.utils.writeToOutput(output, "globals=" .. game.table_to_json(global) .. "\r\n")
			

			-- [KEEP AT THE BOTTOM!]

			-- Update previous.
			global.leaderboard.previousTick = game.tick

			-- Write output to file
			if (not firstEvent) then
				game.write_file('factorio-leaderboard/factorio_leaderboard.stats', output, false)
				--print("> RitnLeaderboard : write file OK !")
			end

			-- test :
			--ritnPrint("---")

			global.leaderboard.last_force = false
			global.leaderboard.index_decal = 1
			global.leaderboard.index_force = 0
		end
    end
end


script.on_event({defines.events.on_tick}, on_tick)
