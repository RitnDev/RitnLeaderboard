

--------------------------------------------------------------------------------


local function count_forces()
	local result = 0
	for _,f in pairs(game.forces) do 
		if f.index > result then
			result = f.index
		end
	end
	return result
end

local function cumulXp(xp, data, value, coeff)
	if value ~= nil then
		if coeff == nil then coeff = 1 end
		if xp ~= nil then xp.total = xp.total + (value*coeff) end
		return data + value
	else 
		return data
	end
end


local function stats_force(firstEvent, force)

	if not global.leaderboard.forces[force.name] then
		global.leaderboard.forces[force.name] = {
			name = force.name,
            items = {},
		}
	end 

	if (not firstEvent) then	
		global.leaderboard.forces[force.name].previousProductionStats = global.leaderboard.forces[force.name].currentProductionStats
	end
	global.leaderboard.forces[force.name].currentProductionStats = {}
	
	--game.players.Ritn.print("test 2")

	-- Item production
	-- *******************************************************************************



	for item, produced in pairs(force.item_production_statistics.input_counts) do
		local consumed = 0
		local lost = 0
		
		if force.item_production_statistics.output_counts[item] then
			consumed = force.item_production_statistics.output_counts[item]
		end
		if force.kill_count_statistics.output_counts[item] then
			lost = force.kill_count_statistics.output_counts[item]
		end
		global.leaderboard.forces[force.name].currentProductionStats[item] =
		{
			Name = item,
			amount = produced + (-consumed),
			produced = produced,
			consumed = (-consumed),
			lost = (-lost)
		}
       
		if global.leaderboard.synth.currentProductionStats[item] then 
			global.leaderboard.synth.currentProductionStats[item].amount = global.leaderboard.synth.currentProductionStats[item].amount + global.leaderboard.forces[force.name].currentProductionStats[item].amount
			global.leaderboard.synth.currentProductionStats[item].produced = global.leaderboard.synth.currentProductionStats[item].produced + global.leaderboard.forces[force.name].currentProductionStats[item].produced
			global.leaderboard.synth.currentProductionStats[item].consumed = global.leaderboard.synth.currentProductionStats[item].consumed + global.leaderboard.forces[force.name].currentProductionStats[item].consumed
			global.leaderboard.synth.currentProductionStats[item].lost = global.leaderboard.synth.currentProductionStats[item].lost + global.leaderboard.forces[force.name].currentProductionStats[item].lost
        else 
			global.leaderboard.synth.currentProductionStats[item] = {
				Name = item,
				amount = produced + (-consumed),
				produced = produced,
				consumed = (-consumed),
				lost = (-lost)
			}
		end
	end

	for item, consumed in pairs(force.item_production_statistics.output_counts) do
		local produced = 0
		local lost = 0
		
		if force.kill_count_statistics.output_counts[item] then
			lost = force.kill_count_statistics.output_counts[item]
		end
		if not force.item_production_statistics.input_counts[item] then
			global.leaderboard.forces[force.name].currentProductionStats[item] =
			{
				Name = item,
				amount = (-consumed),
				produced = produced,
				consumed = (-consumed),
				lost = (-lost)
			}
            global.leaderboard.forces[force.name].items[item] = {
                amount = (-consumed),
            }

			if global.leaderboard.synth.currentProductionStats[item] then 
				global.leaderboard.synth.currentProductionStats[item].amount = global.leaderboard.synth.currentProductionStats[item].amount + global.leaderboard.forces[force.name].currentProductionStats[item].amount
				global.leaderboard.synth.currentProductionStats[item].produced = global.leaderboard.synth.currentProductionStats[item].produced + global.leaderboard.forces[force.name].currentProductionStats[item].produced
				global.leaderboard.synth.currentProductionStats[item].consumed = global.leaderboard.synth.currentProductionStats[item].consumed + global.leaderboard.forces[force.name].currentProductionStats[item].consumed
				global.leaderboard.synth.currentProductionStats[item].lost = global.leaderboard.synth.currentProductionStats[item].lost + global.leaderboard.forces[force.name].currentProductionStats[item].lost
            else 
				global.leaderboard.synth.currentProductionStats[item] = {
					Name = item,
					amount = produced + (-consumed),
					produced = produced,
					consumed = (-consumed),
					lost = (-lost)
				}
			end
		end	
	
	end
	-- *******************************************************************************

	-- Fluid production
	for item, produced in pairs(force.fluid_production_statistics.input_counts) do
		local consumed = 0
		local lost = 0
		
		if force.fluid_production_statistics.output_counts[item] then
			consumed = force.fluid_production_statistics.output_counts[item]
		end
		if force.kill_count_statistics.output_counts[item] then
			lost = force.kill_count_statistics.output_counts[item]
		end
		
		global.leaderboard.forces[force.name].currentProductionStats[item] =
		{
			Name = item,
			amount = produced + (-consumed),
			produced = produced,
			consumed = (-consumed),
			lost = (-lost)
		}

		if global.leaderboard.synth.currentProductionStats[item] then 
			global.leaderboard.synth.currentProductionStats[item].amount = global.leaderboard.synth.currentProductionStats[item].amount + global.leaderboard.forces[force.name].currentProductionStats[item].amount
			global.leaderboard.synth.currentProductionStats[item].produced = global.leaderboard.synth.currentProductionStats[item].produced + global.leaderboard.forces[force.name].currentProductionStats[item].produced
			global.leaderboard.synth.currentProductionStats[item].consumed = global.leaderboard.synth.currentProductionStats[item].consumed + global.leaderboard.forces[force.name].currentProductionStats[item].consumed
			global.leaderboard.synth.currentProductionStats[item].lost = global.leaderboard.synth.currentProductionStats[item].lost + global.leaderboard.forces[force.name].currentProductionStats[item].lost
		else 
			global.leaderboard.synth.currentProductionStats[item] = {
				Name = item,
				amount = produced + (-consumed),
				produced = produced,
				consumed = (-consumed),
				lost = (-lost)
			}
		end
	end

	for item, consumed in pairs(force.fluid_production_statistics.output_counts) do
		local produced = 0
		local lost = 0
		if force.kill_count_statistics.output_counts[item] then
			lost = force.kill_count_statistics.output_counts[item]
		end
		if not force.fluid_production_statistics.input_counts[item] then
			global.leaderboard.forces[force.name].currentProductionStats[item] =
			{
				Name = item,
				amount = produced + (-consumed),
				produced = produced,
				consumed = (-consumed),
				lost = (-lost)
			}

			if global.leaderboard.synth.currentProductionStats[item] then 
				global.leaderboard.synth.currentProductionStats[item].amount = global.leaderboard.synth.currentProductionStats[item].amount + global.leaderboard.forces[force.name].currentProductionStats[item].amount
				global.leaderboard.synth.currentProductionStats[item].produced = global.leaderboard.synth.currentProductionStats[item].produced + global.leaderboard.forces[force.name].currentProductionStats[item].produced
				global.leaderboard.synth.currentProductionStats[item].consumed = global.leaderboard.synth.currentProductionStats[item].consumed + global.leaderboard.forces[force.name].currentProductionStats[item].consumed
				global.leaderboard.synth.currentProductionStats[item].lost = global.leaderboard.synth.currentProductionStats[item].lost + global.leaderboard.forces[force.name].currentProductionStats[item].lost
			else 
				global.leaderboard.synth.currentProductionStats[item] = {
					Name = item,
					amount = produced + (-consumed),
					produced = produced,
					consumed = (-consumed),
					lost = (-lost)
				}
			end
		end
	end
	-- *******************************************************************************

	global.leaderboard.forces[force.name].kill_count_in = force.kill_count_statistics.input_counts
	global.leaderboard.forces[force.name].kill_count_out = force.kill_count_statistics.output_counts

	for i,entry in pairs(force.kill_count_statistics.input_counts) do 
		if not global.leaderboard.synth.kill_count_in[i] then 
			global.leaderboard.synth.kill_count_in[i] = entry
		else
			global.leaderboard.synth.kill_count_in[i] = global.leaderboard.synth.kill_count_in[i] + entry
		end
	end
	for i,entry in pairs(force.kill_count_statistics.output_counts) do 
		if not global.leaderboard.synth.kill_count_out[i] then 
			global.leaderboard.synth.kill_count_out[i] = entry
		else
			global.leaderboard.synth.kill_count_out[i] = global.leaderboard.synth.kill_count_out[i] + entry
		end
	end

	-- Rocket Launched
	global.leaderboard.forces[force.name].rockets_launched = force.rockets_launched
	global.leaderboard.synth.rockets_launched = global.leaderboard.synth.rockets_launched + force.rockets_launched

	-- Items Launched
	global.leaderboard.forces[force.name].items_launched = {}
	if force.items_launched then
		global.leaderboard.forces[force.name].items_launched = force.items_launched
	end
	for i,entry in pairs(force.items_launched) do 
		if not global.leaderboard.synth.items_launched[i] then 
			global.leaderboard.synth.items_launched[i] = entry
		else
			global.leaderboard.synth.items_launched[i] = global.leaderboard.synth.items_launched[i] + entry
		end
	end

	-- data xp
	local xp = {
		fusee = 0,
		enemy = {
			biter = {
				small = 0,
				medium = 0,
				big = 0,
				behemoth = 0,
			},
			spitter = {
				small = 0,
				medium = 0,
				big = 0,
				behemoth = 0,
			},
			worm = {
				small = 0,
				medium = 0,
				big = 0,
				behemoth = 0,
			},
			total = 0,
		},
		spawner = {
			biter = 0,
			spitter = 0,
			total = 0,
		},
		total = 0,
	}
	-- rocket launched
	xp.fusee = cumulXp(xp, xp.fusee, force.rockets_launched, 1000)

	-- Spawner
	xp.spawner.biter = cumulXp(xp, xp.spawner.biter, global.leaderboard.forces[force.name].kill_count_in["biter-spawner"],11)
	xp.spawner.total = xp.spawner.total + xp.spawner.biter

	xp.spawner.spitter = cumulXp(xp, xp.spawner.spitter, global.leaderboard.forces[force.name].kill_count_in["spitter-spawner"],11)
	xp.spawner.total = xp.spawner.total + xp.spawner.spitter

	--biters
	xp.enemy.biter.small = cumulXp(xp, xp.enemy.biter.small, global.leaderboard.forces[force.name].kill_count_in["small-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.small

	xp.enemy.biter.medium = cumulXp(xp, xp.enemy.biter.medium, global.leaderboard.forces[force.name].kill_count_in["medium-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.medium

	xp.enemy.biter.big = cumulXp(xp, xp.enemy.biter.big, global.leaderboard.forces[force.name].kill_count_in["big-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.big

	xp.enemy.biter.behemoth = cumulXp(xp, xp.enemy.biter.behemoth, global.leaderboard.forces[force.name].kill_count_in["behemoth-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.behemoth
	
	--spitters
	xp.enemy.spitter.small = cumulXp(xp, xp.enemy.spitter.small, global.leaderboard.forces[force.name].kill_count_in["small-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.small

	xp.enemy.spitter.medium = cumulXp(xp, xp.enemy.spitter.medium, global.leaderboard.forces[force.name].kill_count_in["medium-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.medium

	xp.enemy.spitter.big = cumulXp(xp, xp.enemy.spitter.big, global.leaderboard.forces[force.name].kill_count_in["big-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.big

	xp.enemy.spitter.behemoth = cumulXp(xp, xp.enemy.spitter.behemoth, global.leaderboard.forces[force.name].kill_count_in["behemoth-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.behemoth

	--worms
	xp.enemy.worm.small = cumulXp(xp, xp.enemy.worm.small, global.leaderboard.forces[force.name].kill_count_in["small-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.small

	xp.enemy.worm.medium = cumulXp(xp, xp.enemy.worm.medium, global.leaderboard.forces[force.name].kill_count_in["medium-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.medium

	xp.enemy.worm.big = cumulXp(xp, xp.enemy.worm.big, global.leaderboard.forces[force.name].kill_count_in["big-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.big

	xp.enemy.worm.behemoth = cumulXp(xp, xp.enemy.worm.behemoth, global.leaderboard.forces[force.name].kill_count_in["behemoth-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.behemoth


	-- envoie de l'xp de la force
	global.leaderboard.forces[force.name].xp = xp

	if global.leaderboard.synth.rockets_launched > 1 then global.leaderboard.synth.xp = global.leaderboard.synth.xp + 1000000 end
	global.leaderboard.synth.xp = global.leaderboard.synth.xp + global.leaderboard.forces[force.name].xp.total
	global.leaderboard.synth.spawner = global.leaderboard.synth.spawner + xp.spawner.total
	global.leaderboard.synth.enemy = global.leaderboard.synth.enemy + xp.enemy.total

end




----------------------------
-- Chargement des fonctions
local flib = {}
flib.count_forces = count_forces
flib.stats_force = stats_force

-- Retourne la liste des fonctions
return flib