-- RitnLeaderboardForce
----------------------------------------------------------------
local constants = require(ritnlib.defines.constants)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLeaderboardForce = ritnlib.classFactory.newclass(RitnCoreForce, function(self, LuaForce)
    RitnCoreForce.init(self, LuaForce)
    self.object_name = "RitnLeaderboardForce"
    --------------------------------------------------
    self.data_leaderboard = remote.call("RitnCoreGame", "get_data", "leaderboard")
    self.data_leaderboard.name = self.name
    self.data_leaderboard.index = self.index
    --------------------------------------------------
    log('> [RitnLeaderboard] > RitnLeaderboardForce')
end)

----------------------------------------------------------------

-- init data
function RitnLeaderboardForce:initLeaderboard()
    if not global.leaderboard.data.forces[self.name] then 
        global.leaderboard.data.forces[self.name] = self.data_leaderboard
    else
        self.data_leaderboard = global.leaderboard.data.forces[self.name]
        self.data_leaderboard.production.previous = self.data_leaderboard.production.current
        self.data_leaderboard.production.current = {}
    end

    self:updateLeaderboard()
    
    return self
end



function RitnLeaderboardForce:calculStats()

	-- Item production
    self:calculStatsProductionInput("item") 
    self:calculStatsProductionOutput("item") 
	-- Fluid production
    self:calculStatsProductionInput("fluid") 
    self:calculStatsProductionOutput("fluid") 

    -- calcul kills 
	self.data_leaderboard.counts.kill.input = self.stats.count.kill.input
    self.data_leaderboard.counts.kill.output = self.stats.count.kill.output

	-- Rocket Launched
    self.data_leaderboard.counts.rockets_launched = self.rockets_launched

	-- Items Launched
	if self.stats.items_launched then
		self.data_leaderboard.counts.items_launched = self.items_launched
	end
  
    -- rocket launched
    self:calculXp(self.data_leaderboard.xp.rockets_launched, self.rockets_launched, 1000)

    -- Spawner
    self:calculKillXp(self.data_leaderboard.xp.spawner.total, self.data_leaderboard.xp.spawner.biter, "biter-spawner", 11)
    self:calculKillXp(self.data_leaderboard.xp.spawner.total, self.data_leaderboard.xp.spawner.spitter, "spitter-spawner", 11)
    

	--biters
    local target = "biter"
    self:calculKillEnemyXp(target, constants.enemy.size.small)
    self:calculKillEnemyXp(target, constants.enemy.size.medium)
    self:calculKillEnemyXp(target, constants.enemy.size.big)
    self:calculKillEnemyXp(target, constants.enemy.size.behemoth)


    --spitters
    local target = "spitter"
    self:calculKillEnemyXp(target, constants.enemy.size.small)
    self:calculKillEnemyXp(target, constants.enemy.size.medium)
    self:calculKillEnemyXp(target, constants.enemy.size.big)
    self:calculKillEnemyXp(target, constants.enemy.size.behemoth)
	
	--worms
    local target = "worm"
    local complement = "turret"
    self:calculKillEnemyXp(target, constants.enemy.size.small,    complement)
    self:calculKillEnemyXp(target, constants.enemy.size.medium,   complement)
    self:calculKillEnemyXp(target, constants.enemy.size.big,      complement)
    self:calculKillEnemyXp(target, constants.enemy.size.behemoth, complement)


    -- update
    self:updateLeaderboard()

    return self
end


-- calcul for production stats input
function RitnLeaderboardForce:calculStatsProductionInput(prod) 
    for name, produced in pairs(self.stats.production[prod]["input"]) do
		local consumed = self:getStatsProduction(name, prod, true) 
		local lost = self:getStatsCountKill(name, true) 
	
        self.data_leaderboard.production.current[name] = self:setProductionStat(name, produced, math.abs(-consumed), math.abs(-lost)) 
	end
    return self
end

-- calcul for production stats output
function RitnLeaderboardForce:calculStatsProductionOutput(prod) 
    for name, consumed in pairs(self.stats.production[prod]["output"]) do
        local produced = 0
		local lost = self:getStatsCountKill(name, true) 

        if not self:getStatsProduction(name, prod) then
            self.data_leaderboard.production.current[name] = self:setProductionStat(name, produced, math.abs(-consumed), math.abs(-lost)) 
		end	
	end
    return self
end


-- Calcul d'XP lié au kill (score enemy only)
function RitnLeaderboardForce:calculKillEnemyXp(target, enemySize, complementName)
    local targetKill = enemySize .. constants.strings.hyphen .. target
    if complementName ~= nil then 
        targetKill = targetKill .. constants.strings.hyphen .. complementName 
    end

    self:calculXp(self.data_leaderboard.xp.enemy[target][enemySize], self.stats.count.kill.input[targetKill])
    self.data_leaderboard.xp.enemy.total = self.data_leaderboard.xp.enemy.total + self.data_leaderboard.xp.enemy[target][enemySize]

    return self
end


-- Calcul d'XP lié au kill (score enemy et spawner)
function RitnLeaderboardForce:calculKillXp(dataTotal, data, target, coeff)
    self:calculXp(data, self.stats.count.kill.input[target], coeff)
    dataTotal = dataTotal + data

    return self
end


-- Calcul d'XP
function RitnLeaderboardForce:calculXp(data, value, coeff)
	if value ~= nil then
		if coeff == nil then coeff = 1 end
		self.data_leaderboard.xp.total = self.data_leaderboard.xp.total + (value*coeff)
		data = data + value
	end
    return self
end





-- set unique production stats on data table
function RitnLeaderboardForce:setProductionStat(name, produced, consumed, lost) 
    return {
        name = name,
        amount = produced - consumed - lost,
        produced = produced,
        consumed = consumed,
        lost = lost
    }
end


-- update leaderboard
function RitnLeaderboardForce:updateLeaderboard()
    global.leaderboard.data.forces[self.name] = self.data_leaderboard
    return self
end

----------------------------------------------------------------
--return RitnLeaderboardForce