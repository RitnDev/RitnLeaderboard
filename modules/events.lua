---------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------  
local function on_init_mod(event)
    log('RitnLeaderboard -> on_init !')
    -------------------------------------------------------------
    remote.call("RitnCoreGame", "init_data", "leaderboard", {
        index = 0,
		name = "",
		production = {
			current = {},
			previous = {},
		},
		counts = {
			kill = {
				input = {},
				output = {}
			},
			rockets_launched = 0,
			items_launched = {}
		},
		xp = {
			rockets_launched = 0,
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
    })
    -------------------------------------------------------------
    log('on_init : RitnLeaderboard -> finish !')
end



--[[
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
]]

---------------------------
--events[defines.events.on_player_cheat_mode_enabled] = on_player_cheat_mode_enabled
--events[defines.events.on_player_died] = on_player_died
--events[defines.events.on_rocket_launched] = on_rocket_launched

-------------------------------------------
script.on_init(on_init_mod)
-------------------------------------------
return {}