local modules = {}
------------------------------------------------------------------------------

-- Inclus les events onInit et onLoad + les ajouts des fonctions d'interfaces.
modules.globals =               require(ritnlib.defines.leaderboard.modules.globals)
modules.events =                require(ritnlib.defines.leaderboard.modules.events)
--modules.commands =              require(ritnlib.defines.leaderboard.modules.commands)
------------------------------------------------------------------------------
modules.leaderboard =           require(ritnlib.defines.leaderboard.modules.leaderboard)
------------------------------------------------------------------------------
return modules