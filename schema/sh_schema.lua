SCHEMA.name = "Fallout: New Vegas"
SCHEMA.author = "SuperMicronde and the Lazarus Team"
SCHEMA.desc = "An official NutScript schema"
SCHEMA.falloutColor = {r = 255, g = 185, b = 100} -- Fallout NV desert style

function SCHEMA:GetFalloutColor(alpha)
	local tbl = self.falloutColor
	
	return Color(tbl.r, tbl.g, tbl.b, a or 255)
end

-- Money
nut.currency.set("","Cap", "Caps")

-- Config
nut.config.add("hCrossWhenWep", false, "hCrossWhenWepDesc", nil, {category = "visual"})
nut.config.add("color", SCHEMA:GetFalloutColor(), "The main color theme for the framework.", nil, {category = "appearance"})
nut.config.add("font", "Monofonto", "The font used to display titles.", function(oldValue, newValue)
	if (CLIENT) then
		hook.Run("LoadFonts", newValue, nut.config.get("genericFont"))
	end
end, {category = "appearance"})

-- Disabled plugins
SCHEMA.disabledPlugins = {
	"doors", -- Disables door plugins to use the custom door plugin with teleport integration instead ("doors_with_teleporters_integration" plugin)
	"crosshair", -- Schema use a fallout crosshair so we dont need the nutscript one
	"storage" -- Schema use custom fallout storages
}

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

-- Files
nut.util.includeDir("ambience", nil, true)
nut.util.includeDir("charmenu", nil, true)
nut.util.includeDir("clothing", nil, true)
nut.util.includeDir("mergedbodys", nil, true)
nut.util.includeDir("lockpicking", nil, true)
nut.util.includeDir("loot", nil, true)
nut.util.includeDir("hooks", nil, true)
nut.util.include("cl_fallouthud.lua")
nut.util.include("sv_resources.lua")