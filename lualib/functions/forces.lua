

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

	if not global.forces[force.name] then
		global.forces[force.name] = {
			name = force.name,
            items = {},
		}
	end 

	if (not firstEvent) then	
		global.forces[force.name].previousProductionStats = global.forces[force.name].currentProductionStats
	end
	global.forces[force.name].currentProductionStats = {}
	
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
		global.forces[force.name].currentProductionStats[item] =
		{
			Name = item,
			amount = produced + (-consumed),
			produced = produced,
			consumed = (-consumed),
			lost = (-lost)
		}
       
		if global.synth.currentProductionStats[item] then 
			global.synth.currentProductionStats[item].amount = global.synth.currentProductionStats[item].amount + global.forces[force.name].currentProductionStats[item].amount
			global.synth.currentProductionStats[item].produced = global.synth.currentProductionStats[item].produced + global.forces[force.name].currentProductionStats[item].produced
			global.synth.currentProductionStats[item].consumed = global.synth.currentProductionStats[item].consumed + global.forces[force.name].currentProductionStats[item].consumed
			global.synth.currentProductionStats[item].lost = global.synth.currentProductionStats[item].lost + global.forces[force.name].currentProductionStats[item].lost
        else 
			global.synth.currentProductionStats[item] = {
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
			global.forces[force.name].currentProductionStats[item] =
			{
				Name = item,
				amount = (-consumed),
				produced = produced,
				consumed = (-consumed),
				lost = (-lost)
			}
            global.forces[force.name].items[item] = {
                amount = (-consumed),
            }

			if global.synth.currentProductionStats[item] then 
				global.synth.currentProductionStats[item].amount = global.synth.currentProductionStats[item].amount + global.forces[force.name].currentProductionStats[item].amount
				global.synth.currentProductionStats[item].produced = global.synth.currentProductionStats[item].produced + global.forces[force.name].currentProductionStats[item].produced
				global.synth.currentProductionStats[item].consumed = global.synth.currentProductionStats[item].consumed + global.forces[force.name].currentProductionStats[item].consumed
				global.synth.currentProductionStats[item].lost = global.synth.currentProductionStats[item].lost + global.forces[force.name].currentProductionStats[item].lost
            else 
				global.synth.currentProductionStats[item] = {
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
		
		global.forces[force.name].currentProductionStats[item] =
		{
			Name = item,
			amount = produced + (-consumed),
			produced = produced,
			consumed = (-consumed),
			lost = (-lost)
		}

		if global.synth.currentProductionStats[item] then 
			global.synth.currentProductionStats[item].amount = global.synth.currentProductionStats[item].amount + global.forces[force.name].currentProductionStats[item].amount
			global.synth.currentProductionStats[item].produced = global.synth.currentProductionStats[item].produced + global.forces[force.name].currentProductionStats[item].produced
			global.synth.currentProductionStats[item].consumed = global.synth.currentProductionStats[item].consumed + global.forces[force.name].currentProductionStats[item].consumed
			global.synth.currentProductionStats[item].lost = global.synth.currentProductionStats[item].lost + global.forces[force.name].currentProductionStats[item].lost
		else 
			global.synth.currentProductionStats[item] = {
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
			global.forces[force.name].currentProductionStats[item] =
			{
				Name = item,
				amount = produced + (-consumed),
				produced = produced,
				consumed = (-consumed),
				lost = (-lost)
			}

			if global.synth.currentProductionStats[item] then 
				global.synth.currentProductionStats[item].amount = global.synth.currentProductionStats[item].amount + global.forces[force.name].currentProductionStats[item].amount
				global.synth.currentProductionStats[item].produced = global.synth.currentProductionStats[item].produced + global.forces[force.name].currentProductionStats[item].produced
				global.synth.currentProductionStats[item].consumed = global.synth.currentProductionStats[item].consumed + global.forces[force.name].currentProductionStats[item].consumed
				global.synth.currentProductionStats[item].lost = global.synth.currentProductionStats[item].lost + global.forces[force.name].currentProductionStats[item].lost
			else 
				global.synth.currentProductionStats[item] = {
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

	global.forces[force.name].kill_count_in = force.kill_count_statistics.input_counts
	global.forces[force.name].kill_count_out = force.kill_count_statistics.output_counts

	for i,entry in pairs(force.kill_count_statistics.input_counts) do 
		if not global.synth.kill_count_in[i] then 
			global.synth.kill_count_in[i] = entry
		else
			global.synth.kill_count_in[i] = global.synth.kill_count_in[i] + entry
		end
	end
	for i,entry in pairs(force.kill_count_statistics.output_counts) do 
		if not global.synth.kill_count_out[i] then 
			global.synth.kill_count_out[i] = entry
		else
			global.synth.kill_count_out[i] = global.synth.kill_count_out[i] + entry
		end
	end

	-- Rocket Launched
	global.forces[force.name].rockets_launched = force.rockets_launched
	global.synth.rockets_launched = global.synth.rockets_launched + force.rockets_launched

	-- Items Launched
	global.forces[force.name].items_launched = {}
	if force.items_launched then
		global.forces[force.name].items_launched = force.items_launched
	end
	for i,entry in pairs(force.items_launched) do 
		if not global.synth.items_launched[i] then 
			global.synth.items_launched[i] = entry
		else
			global.synth.items_launched[i] = global.synth.items_launched[i] + entry
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
	xp.spawner.biter = cumulXp(xp, xp.spawner.biter, global.forces[force.name].kill_count_in["biter-spawner"],11)
	xp.spawner.total = xp.spawner.total + xp.spawner.biter

	xp.spawner.spitter = cumulXp(xp, xp.spawner.spitter, global.forces[force.name].kill_count_in["spitter-spawner"],11)
	xp.spawner.total = xp.spawner.total + xp.spawner.spitter

	--biters
	xp.enemy.biter.small = cumulXp(xp, xp.enemy.biter.small, global.forces[force.name].kill_count_in["small-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.small

	xp.enemy.biter.medium = cumulXp(xp, xp.enemy.biter.medium, global.forces[force.name].kill_count_in["medium-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.medium

	xp.enemy.biter.big = cumulXp(xp, xp.enemy.biter.big, global.forces[force.name].kill_count_in["big-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.big

	xp.enemy.biter.behemoth = cumulXp(xp, xp.enemy.biter.behemoth, global.forces[force.name].kill_count_in["behemoth-biter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.biter.behemoth
	
	--spitters
	xp.enemy.spitter.small = cumulXp(xp, xp.enemy.spitter.small, global.forces[force.name].kill_count_in["small-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.small

	xp.enemy.spitter.medium = cumulXp(xp, xp.enemy.spitter.medium, global.forces[force.name].kill_count_in["medium-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.medium

	xp.enemy.spitter.big = cumulXp(xp, xp.enemy.spitter.big, global.forces[force.name].kill_count_in["big-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.big

	xp.enemy.spitter.behemoth = cumulXp(xp, xp.enemy.spitter.behemoth, global.forces[force.name].kill_count_in["behemoth-spitter"])
	xp.enemy.total = xp.enemy.total + xp.enemy.spitter.behemoth

	--worms
	xp.enemy.worm.small = cumulXp(xp, xp.enemy.worm.small, global.forces[force.name].kill_count_in["small-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.small

	xp.enemy.worm.medium = cumulXp(xp, xp.enemy.worm.medium, global.forces[force.name].kill_count_in["medium-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.medium

	xp.enemy.worm.big = cumulXp(xp, xp.enemy.worm.big, global.forces[force.name].kill_count_in["big-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.big

	xp.enemy.worm.behemoth = cumulXp(xp, xp.enemy.worm.behemoth, global.forces[force.name].kill_count_in["behemoth-worm-turret"])
	xp.enemy.total = xp.enemy.total + xp.enemy.worm.behemoth


	-- envoie de l'xp de la force
	global.forces[force.name].xp = xp

	if global.synth.rockets_launched > 1 then global.synth.xp = global.synth.xp + 1000000 end
	global.synth.xp = global.synth.xp + global.forces[force.name].xp.total
	global.synth.spawner = global.synth.spawner + xp.spawner.total
	global.synth.enemy = global.synth.enemy + xp.enemy.total

end




----------------------------
-- Chargement des fonctions
local flib = {}
flib.count_forces = count_forces
flib.stats_force = stats_force

-- Retourne la liste des fonctions
return flib