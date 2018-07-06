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
    local rot = rot or 0
    local col = col or SCHEMA:GetColor()

    surface.SetDrawColor(col)
    surface.SetMaterial(mat)
    surface.DrawTexturedRectRotated(x, y, w, h, rot)
end

function fo.draw.FalloutBlur(x, y, w, h, thickness)
	local col = Color(0,0,0)
	local thickness = thickness or 16

	for i = 0, thickness do
		local xChange, yChange, wChange, hChange = x + (i * 2), y + (i * 2), w - (i * 4), h - (i * 4)
		draw.RoundedBox(8, xChange, yChange, wChange, hChange, Color(col.r, col.g, col.b, 2 + (i * 4)))

		if i == thickness then
			return xChange, yChange, wChange, hChange -- We return the size of the inner frame so we can use it in panels to make the UI, this might not be the best way.
		end
	end
end