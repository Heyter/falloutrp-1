function SCHEMA:GetColor(alpha)
    local color = self.ThemeColor

    if ( alpha ) then
        color.a = alpha
    end

    return color
end