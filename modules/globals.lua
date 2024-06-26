---------------------------------------------------------------------------------------------
-- GLOBALS
---------------------------------------------------------------------------------------------

if global.leaderboard == nil then
    global.leaderboard = {
        previousTick = -1,
        index_decal = 1,
        coeff_decal = 30,
        last_force = false,
        data = {
            forces = {},
            synth = {},
        },
    } 
end

---------------------------------------------------------------------------------------------
-- REMOTE FUNCTIONS INTERFACE
---------------------------------------------------------------------------------------------
local leaderboard_interface = {
    -- nothing
}

--remote.add_interface("RitnLeaderboard", leaderboard_interface)
---------------------------------------------------------------------------------------------
return {}