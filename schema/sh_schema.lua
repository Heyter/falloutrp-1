--[[ SCHEMA INFO ]]--

SCHEMA.name = "Fallout: New Vegas"
SCHEMA.author = "Nutscript FalloutRP Team"
SCHEMA.desc = "An official NutScript schema"

--[[ SCHEMA GLOBAL TABLES ]]--

-- Tables
FO_CLTHG = FO_CLTHG or {} -- Clothing
FO_CHRGUI = FO_CHRGUI or  {} -- Char menu
FO_MRGNG = FO_MRGNG or {} -- Merging
FO_AMB = FO_AMB or {} -- Ambience
FO_HUD = FO_HUD or {} -- HUD
FO_BAG = FO_BAG or {} -- Bags outfits
FO_LP = FO_LP or {} -- Lockpicking
loot = loot or {} -- Corpses
clothes = clothes or {} -- Clothing

--[[ SCHEMA INCLUDES ]]--

local Include = nut.util.include
local IncludeDir = nut.util.includeDir

IncludeDir("libs", nil, true)
IncludeDir("meta", nil, true)
IncludeDir("modules", nil, true)
IncludeDir("derma", nil, true)

Include("resources.lua", "server")
Include("fonts.lua", "client")

--[[ SCHEMA CONFIGURATION ]]--

SCHEMA.ThemeColor = Color(255, 185, 100, 255)

nut.currency.set("","Cap", "Caps")

SCHEMA:DisablePlugin("doors")
SCHEMA:DisablePlugin("crosshair")
SCHEMA:DisablePlugin("storage")

SCHEMA:OverrideConfig("color", SCHEMA.ThemeColor)
SCHEMA:OverrideConfig("font", "Monofonto")
