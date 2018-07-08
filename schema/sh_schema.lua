--------------
--[[ INFO ]]--
--------------
SCHEMA.name = "Fallout: New Vegas"
SCHEMA.author = "SuperMicronde, vin, Trip, Otunga"
SCHEMA.desc = "An official NutScript schema"

-----------------------
--[[ GLOBAL TABLES ]]--
-----------------------
FO_CLTHG = FO_CLTHG or {} -- Clothing
FO_CHRGUI = FO_CHRGUI or  {} -- Char menu
FO_MRGNG = FO_MRGNG or {} -- Merging
FO_AMB = FO_AMB or {} -- Ambience
FO_HUD = FO_HUD or {} -- HUD
FO_BAG = FO_BAG or {} -- Bags outfits
FO_LP = FO_LP or {} -- Lockpicking
loot = loot or {} -- Corpses
clothes = clothes or {} -- Clothing

------------------
--[[ INCLUDES ]]--
------------------
nut.util.includeDir("libs", nil, true)
nut.util.includeDir("meta", nil, true)
nut.util.includeDir("modules", nil, true)
nut.util.includeDir("derma", nil, true)
nut.util.includeDir("hooks", nil, true)

nut.util.include("resources.lua", "server")
nut.util.include("fonts.lua", "client")

-----------------------
--[[ CONFIGURATION ]]--
-----------------------
nut.currency.set("","Cap", "Caps")

SCHEMA:DisablePlugin("doors")
SCHEMA:DisablePlugin("crosshair")
SCHEMA:DisablePlugin("storage")

SCHEMA:OverrideConfig("color", forp_amber)
SCHEMA:OverrideConfig("font", "Monofonto")

---------------
--[[ FILES ]]--
---------------
resource.AddWorkshop( "891790188" ) -- Fallout 3 Custom Backpacks
resource.AddWorkshop( "203873185" ) -- Fallout Collection: Aid Props