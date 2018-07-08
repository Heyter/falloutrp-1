--------------
--[[ INFO ]]--
--------------
<<<<<<< HEAD
=======

>>>>>>> 5eb62f94f06c574a0a656a216ca9b63fa605e1be
SCHEMA.name = "Fallout: New Vegas"
SCHEMA.author = "SuperMicronde, vin, Trip, Otunga"
SCHEMA.desc = "An official NutScript schema"

-----------------------
--[[ GLOBAL TABLES ]]--
-----------------------
<<<<<<< HEAD
=======

>>>>>>> 5eb62f94f06c574a0a656a216ca9b63fa605e1be
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
<<<<<<< HEAD
=======

>>>>>>> 5eb62f94f06c574a0a656a216ca9b63fa605e1be
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
<<<<<<< HEAD
=======

>>>>>>> 5eb62f94f06c574a0a656a216ca9b63fa605e1be
nut.currency.set("","Cap", "Caps")

SCHEMA:DisablePlugin("doors")
SCHEMA:DisablePlugin("crosshair")
SCHEMA:DisablePlugin("storage")

SCHEMA:OverrideConfig("color", forp_amber)
SCHEMA:OverrideConfig("font", "Monofonto")
<<<<<<< HEAD

---------------
--[[ FILES ]]--
---------------
resource.AddWorkshop( "891790188" ) -- Fallout 3 Custom Backpacks
resource.AddWorkshop( "203873185" ) -- Fallout Collection: Aid Props
=======
>>>>>>> 5eb62f94f06c574a0a656a216ca9b63fa605e1be
