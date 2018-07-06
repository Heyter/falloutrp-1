-- Draw the Cursor

local cursor = Material("forp/cursor.png")

function SCHEMA:DrawOverlay()
	if vgui.CursorVisible() then
		local panel = vgui.GetHoveredPanel()

		if (panel) then
			panel:SetCursor("blank")
		end

		local x, y = input.GetCursorPos()

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(cursor)
		surface.DrawTexturedRect(x, y, 25, 34)
	end
end