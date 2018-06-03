function SCHEMA:GetFalloutColor(alpha)
	local tbl = self.falloutColor
	
	return Color(tbl.r, tbl.g, tbl.b, a or 255)
end