-- Chargement des modules :
local modules = {}

modules.migration =     require("core.migrations")
modules.events =        require("lualib.events")        -- Commande console ici
--modules.forces =       require("lualib.modules.forces") 
modules.players =       require("lualib.modules.players") 
modules.surfaces =       require("lualib.modules.surfaces") 

return modules