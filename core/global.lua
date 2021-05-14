if not global.leaderboard then global.leaderboard = {
    previousTick = -1,
    index_force = 0,
    index_decal = 1,
    last_force = false,
    is_start = false,
    surfaces = {}
} end 

if not global.forces then global.forces = {} end
if not global.synth then global.synth = {} end
if not global.xp then global.xp = 0 end
if not global.migration then global.migration = false end