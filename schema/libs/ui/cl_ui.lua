fo.ui = fo.ui or {}

function sW(num)
	local scrW = ScrW()

	if ( num ) then
		scrW = scrW * num
	end

	return scrW
end

function sH(num)
	local scrH = ScrH()

	if ( num ) then
		scrH = scrH * num
	end

	return scrH
end

-- Fallout colours
forp_amber = Color(255, 182, 66, 255)
forp_white = Color(192, 255, 255 ,255)
forp_green = Color(26, 255, 128, 255)
forp_blue = Color(46, 207, 255, 255)
forp_red = Color(249, 65, 41)

-- Not exact but nice
forp_amber_grey = Color(78, 57, 25, 255)
forp_white_grey = Color(92, 114, 107, 255)
forp_green_grey = Color(23, 117, 60, 255)
forp_blue_grey = Color(31, 96, 112, 255)

FORP_CVAR_COLOUR = CreateClientConVar("forp_colour", "amber", true, false, "Changes the hud colour, can be amber, white, green or blue.")

function SCHEMA:GetColor()
	return fo.ui.GetHUDColor()
end

function SCHEMA:GetFalloutColor()
	return fo.ui.GetHUDColor()
end

local hudColors = {
	amber = forp_amber,
	white = forp_white,
	green = forp_green,
	blue = forp_blue
}

local hudGreyColors = {
	amber = forp_amber_grey,
	white = forp_white_grey,
	green = forp_green_grey,
	blue = forp_blue_grey
}

function fo.ui.GetHUDColor()
	return hudColors[FORP_CVAR_COLOUR:GetString()] or forp_amber
end

function fo.ui.GetHUDGreyColor()
	return hudGreyColors[FORP_CVAR_COLOUR:GetString()] or forp_amber_grey
end

--Helper UI functions
function fo.ui.DrawWrappedText(lines, font, color, x, y, gap)
	local fontHeight = draw.GetFontHeight( font )
	surface.SetFont(font)
	surface.SetTextColor(color)

	for _, line in pairs(lines) do
		surface.SetTextPos(x, y)
		surface.DrawText(line)
		y = y + fontHeight + (gap or 0)
	end
end

-- Show cursor and disable gui.EnableScreenClicker 
fo.ui.oldEnableScreenClicker = fo.ui.oldEnableScreenClicker or gui.EnableScreenClicker
function fo.ui.LockCursor()
	gui.EnableScreenClicker(true)
	gui.EnableScreenClicker = function() end
end
-- Hide cursor and enable gui.EnableScreenClicker 
function fo.ui.UnlockCursor()
	gui.EnableScreenClicker = fo.ui.oldEnableScreenClicker
	gui.EnableScreenClicker(false)
end