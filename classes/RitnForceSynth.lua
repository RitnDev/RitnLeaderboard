-- RitnLeaderboardForceSynth
----------------------------------------------------------------
local util = require(ritnlib.defines.other)
local constants = require(ritnlib.defines.constants)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnLeaderboardForceSynth = ritnlib.classFactory.newclass(function(self)
    --------------------
    self.name = "synth"
    self.index = 0
    --------------------
    self.data_leaderboard = remote.call("RitnCoreGame", "get_data", "leaderboard")
    self.data_leaderboard.name = self.name
    self.data_leaderboard.index = self.index
    self.firstEvent = (global.leaderboard.previousTick < 0)
    self.rForce = nil
    --------------------
    self.stats = {
        production = {
            item = {
                input = {},
                output= {},
            },
            fluid = {
                input = {},
                output= {},
            },
        },
        count = {
            kill = {
                input = {},
                output= {},
            },
            build = {
                input = {},
                output= {},
            },
        }
    }
    self.items_launched = {}
    self.rockets_launched = 0
        --------------------------------------------------
    log('> [RitnLeaderboard] > RitnLeaderboardForce')
end)
----------------------------------------------------------------

-- @Override initLeaderboard() : init data
function RitnLeaderboardForceSynth:initLeaderboard(RitnForce)
    if not global.leaderboard.data.synth.name then 
        global.leaderboard.data.synth = self.data_leaderboard
    else
        self.data_leaderboard = global.leaderboard.data.synth
        self.data_leaderboard.production.previous = global.leaderboard.data.synth.production.current
        self.data_leaderboard.production.current = {}
    end

    -- cas d'initialisation sans passage de RitnForce en parametre
    if RitnForce == nil then return self end 

    if (RitnForce.object_name == "RitnLeaderboardForce") then 
        self.rForce = RitnForce

        self:calculStatsRitnForce("production", "item", "input")
        self:calculStatsRitnForce("production", "item", "output")
        self:calculStatsRitnForce("production", "fluid", "input")
        self:calculStatsRitnForce("production", "fluid", "output")
        self:calculStatsRitnForce("count", "kill", "input")
        self:calculStatsRitnForce("count", "kill", "output")
        self:calculStatsRitnForce("count", "build", "input")
        self:calculStatsRitnForce("count", "build", "output")

        for name, _ in pairs(self.rForce.items_launched) do 
            if (self.items_launched[name]) then 
                self.items_launched[name] = self.items_launched[name] + self.rForce.items_launched[name]
            else
                self.items_launched[name] = self.rForce.items_launched[name]
            end
        end    

        self.rockets_launched = self.rockets_launched + self.rForce.rockets_launched
  
    end
    
    return self
end


-- Load data 
function RitnLeaderboardForceSynth:loadLeaderboard()

    self.data_leaderboard = global.leaderboard.data.synth

    if self.data_leaderboard.gameId == nil then
        -- game uid
        self.data_leaderboard.gameId = util.uuid()
        
        -- active mods
        self.data_leaderboard.active_mods = game.active_mods

        --default_map_gen_settings
        self.data_leaderboard.default_map_gen_settings = game.default_map_gen_settings

        -- difficulty
        self.data_leaderboard.difficulty = game.difficulty

        -- map exchange
        self.data_leaderboard.map_exchange_string = game.get_map_exchange_string()

        -- ticks_played
        self.data_leaderboard.ticks_played = game.ticks_played
    end

    -- current tick
    self.data_leaderboard.currentTick = game.tick

    --Scenario finished
    local finished = 0
    if (game.finished == true) then finished = 1 end
    self.data_leaderboard.game_finished = finished

    -- is_multiplayer game
    self.data_leaderboard.is_multiplayer = remote.call("RitnCoreGame", "isMultiplayer")

    -- previous tick
    if self.firstEvent then 
        self.data_leaderboard.previousTick = 0
    else 
        self.data_leaderboard.previousTick = global.leaderboard.previousTick
    end

    return self
end



-- calcule stats synthese
function RitnLeaderboardForceSynth:calculStats()

	-- production
    self:calculStatsProduction() 

    -- calcul kills 
	self.data_leaderboard.counts.kill.input = self.stats.count.kill.input
    self.data_leaderboard.counts.kill.output = self.stats.count.kill.output


    return self
end



-- calcul stats synthese with RitnLeaderboardForce attached
function RitnLeaderboardForceSynth:calculStatsRitnForce(mainStats, typeStats, target)
    for name, _ in pairs(self.rForce.stats[mainStats][typeStats][target]) do 
        if self.stats[mainStats][typeStats][target][name] then 
            self.stats[mainStats][typeStats][target][name] = self.stats[mainStats][typeStats][target][name] + self.rForce.stats[mainStats][typeStats][target][name]
        else
            self.stats[mainStats][typeStats][target][name] = self.rForce.stats[mainStats][typeStats][target][name]
        end
    end
    return self
end






-- calcul for production stats input
function RitnLeaderboardForceSynth:calculStatsProduction() 
    for name, _ in pairs(self.rForce.data_leaderboard.production.current) do
        if self.data_leaderboard.production.current[name] then
            self.data_leaderboard.production.current[name].amount = self.data_leaderboard.production.current[name].amount + self.rForce.data_leaderboard.production.current[name].amount
            self.data_leaderboard.production.current[name].produced = self.data_leaderboard.production.current[name].produced + self.rForce.data_leaderboard.production.current[name].produced
            self.data_leaderboard.production.current[name].consumed = self.data_leaderboard.production.current[name].consumed + self.rForce.data_leaderboard.production.current[name].consumed
            self.data_leaderboard.production.current[name].lost = self.data_leaderboard.production.current[name].lost + self.rForce.data_leaderboard.production.current[name].lost
        else 
            -- TODO marche po
            if self.rForce.data_leaderboard.production.current[name] then 
                self.data_leaderboard.production.current[name] = self:setProductionStat(
                    name, 
                    self.rForce.data_leaderboard.production.current[name].produced, 
                    self.rForce.data_leaderboard.production.current[name].consumed, 
                    self.rForce.data_leaderboard.production.current[name].lost
                )
            end
        end
	end
    return self
end


-- Calcul d'XP lié au kill (score enemy only)
function RitnLeaderboardForceSynth:calculKillEnemyXp(target, enemySize, complementName)
    local targetKill = enemySize .. constants.strings.hyphen .. target
    if complementName ~= nil then 
        targetKill = targetKill .. constants.strings.hyphen .. complementName 
    end

    self:calculXp(self.data_leaderboard.xp.enemy[target][enemySize], self.stats.count.kill.input[targetKill])
    self.data_leaderboard.xp.enemy.total = self.data_leaderboard.xp.enemy.total + self.data_leaderboard.xp.enemy[target][enemySize]

    return self
end


-- Calcul d'XP lié au kill (score enemy et spawner)
function RitnLeaderboardForceSynth:calculKillXp(dataTotal, data, target, coeff)
    self:calculXp(data, self.stats.count.kill.input[target], coeff)
    dataTotal = dataTotal + data

    return self
end


-- Calcul d'XP
function RitnLeaderboardForceSynth:calculXp(data, value, coeff)
	if value ~= nil then
		if coeff == nil then coeff = 1 end
		self.data_leaderboard.xp.total = self.data_leaderboard.xp.total + (value*coeff)
		data = data + value
	end
    return self
end





-- set unique production stats on data table
function RitnLeaderboardForceSynth:setProductionStat(name, produced, consumed, lost) 
    return {
        name = name,
        amount = produced - consumed - lost,
        produced = produced,
        consumed = consumed,
        lost = lost
    }
end


-- @Override updateLeaderboard() : update leaderboard
function RitnLeaderboardForceSynth:updateLeaderboard()
    global.leaderboard.data.synth = self.data_leaderboard
end

----------------------------------------------------------------
--return RitnLeaderboardForceSynth