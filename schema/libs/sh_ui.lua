fo.ui = fo.ui or {}

-- Fallout colours
local falloutColours = {
	amber = Color(255, 182, 66, 255),
	blue = Color(46, 207, 255, 255),
	green = Color(26, 255, 128, 255),
	white = Color(192, 255, 255 ,255)
}

--Helper UI functions

if CLIENT then
	FORP_CVAR_COLOUR = CreateClientConVar("forp_colour", "amber", true, false, "Changes the UI colour, can be amber, blue, green or white.")

	function SCHEMA:GetColor()
		return falloutColours[FORP_CVAR_COLOUR:GetString()] or falloutColours.amber
	end
end

--Helper UI functions

function fo.ui.DrawWrappedText(lines, font, x, y, gap)
	if ( not gap ) then 
		local gap = 0
	end

	local fontHeight = draw.GetFontHeight( font )
	surface.SetFont(font)

	for _, line in pairs(lines) do
		surface.SetTextPos(x, y)
		surface.DrawText(line)
		y = y + fontHeight + gap
	end
end