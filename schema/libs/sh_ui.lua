falloutui = {}

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

function falloutui.DrawBlur(x,y,text,blur,color,font,blurfont)
    local alpha = alpha or 255

    if blur == nil then 
        blur = false 
    end

    if color and color != 0 then
        color = color
    else
        color = SCHEMA:GetColor()
    end

    local normfo, blurfo = "Monofonto24", "Monofonto24_blur"

    if (font and blurfont) then
        normfo = font
        blurfo = blurfont
    end
    
    surface.SetFont(blurfo)
	surface.SetTextColor(color)
    for i =0,3 do
      	surface.SetTextPos(x, y)
        surface.DrawText(text)
    end
    surface.SetFont(normfo)
    surface.SetTextPos(x, y)
    surface.DrawText(text)
end