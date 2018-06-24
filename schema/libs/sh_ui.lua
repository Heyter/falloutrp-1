fo.ui = fo.ui or {}

function SCHEMA:GetColor(alpha)
    local color = self.ThemeColor

    if ( alpha ) then
        color.a = alpha
    end

    return color
end

-- Fallout colours
FALLOUT_AMBER = Color(255, 182, 66, 255)
FALLOUT_BLUE = Color(46, 207, 255, 255)
FALLOUT_GREEN = Color(26, 255, 128, 255)
FALLOUT_WHITE = Color(192, 255, 255 ,255)

--Helper UI functions

function fo.ui.DrawWrappedText(lines, font, x, y)
	if ( not lines ) then return end

	local fontHeight = draw.GetFontHeight( font )
	surface.SetFont(font)

	for _, line in pairs(lines) do
		surface.SetTextPos(x, y)
		surface.DrawText(line)
		y = y + fontHeight
	end
end