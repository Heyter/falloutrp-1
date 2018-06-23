fo_ui = fo_ui or {} -- Fuck you vin

function SCHEMA:GetColor(alpha)
    local color = self.ThemeColor

    if ( alpha ) then
        color.a = alpha
    end

    return color
end

--[[ Globals ]]--

-- Fallout colours
FALLOUT_AMBER = Color(255, 182, 66, 255)
FALLOUT_BLUE = Color(46, 207, 255, 255)
FALLOUT_GREEN = Color(26, 255, 128, 255)
FALLOUT_WHITE = Color(192, 255, 255 ,255)

--Helper UI functions

function fo_ui.WrapText(text, font, maxWidth)
	local words = string.Explode( " ", text )
	
	local lines = {}
	local index = 1
	lines[index] = ""
	
	surface.SetFont(font)
	
	for _, word in pairs(words) do
		if ( surface.GetTextSize(line..word) < maxWidth ) then
			lines[index] = lines[index]..word
		else
			index = index + 1
			lines[index] = word
		end
	end
	
	return lines or {}
end

function fo_ui.DrawWrappedText(lines)
	if ( not lines ) then return end
	
	for _, line in pairs(lines) do
		surface.DrawText(line)
	end
end
