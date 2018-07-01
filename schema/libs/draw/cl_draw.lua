fo.draw = fo.draw or {}

--Helper UI functions
function fo.draw.WrappedText(lines, font, color, x, y, gap)
	local fontHeight = draw.GetFontHeight( font )
	surface.SetFont(font)
	surface.SetTextColor(color)

	for _, line in pairs(lines) do
		surface.SetTextPos(x, y)
		surface.DrawText(line)
		y = y + fontHeight + (gap or 0)
	end
end

function fo.draw.TexturedRectRotated(mat, x, y, w, h, rot, col)
    rot = rot or 0
    col = col or SCHEMA:GetColor()

    surface.SetDrawColor(col)
    surface.SetMaterial(mat)
    surface.DrawTexturedRectRotated(x, y, w, h, rot)
end