-----------------------------------------
--               DEFINES               --
-----------------------------------------
if not ritnlib then require("__RitnBaseGame__.core.defines") end
require("__RitnLog__.core.defines")
-----------------------------------------
local name = "RitnLeaderboard"
local mod_name = "__"..name.."__"
-----------------------------------------
local defines = {
    name = name,
    directory = mod_name,

    class = {
        force = mod_name .. ".classes.RitnForce",
        synth = mod_name .. ".classes.RitnForceSynth",
    },

    setup = mod_name .. ".core.setup-classes",
    
    modules = {
        core = mod_name .. ".core.modules",
        ----
        globals = mod_name .. ".modules.globals",
        events = mod_name .. ".modules.events",
        commands = mod_name .. ".modules.commands",
        ----
        leaderboard = mod_name .. ".modules.leaderboard",
    },

}

----------------
ritnlib.defines.leaderboard = defines
log('declare : ritnlib.defines.base | '.. ritnlib.defines.leaderboard.name ..' -> finish !')