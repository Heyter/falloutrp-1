local INTERFACE = {}
INTERFACE.DrawBlur = true
INTERFACE.HideFalloutHud = true
INTERFACE.LockCursor = true
INTERFACE.infosHeight = 0
INTERFACE.buttonsHeight = 0
INTERFACE.borderW = 0
INTERFACE.borderH = 0

local yScrMargin = 42
local xScrMargin = 42
local xBorderMargin = 5
local yBorderMargin = 5

local lineHeight = 3
local fadeWidth = 30




function INTERFACE:Init()
	if ( fo.ui.interface ) then
		fo.ui.interface:Remove()
	end

	fo.ui.interface = self
	self:SetSize(sW(), sH())

	if ( self.LockCursor ) then
		fo.ui.LockCursor()
	end
end

function INTERFACE:OnRemove()
	fo.ui.UnlockCursor()
end




function INTERFACE:SetBorderSize(w, h)
	self.borderW = w
	self.borderH = h
end

function INTERFACE:GetBorderSize()
	return self.borderW, self.borderH
end

function INTERFACE:GetBorderWide()
	return self.borderW
end

function INTERFACE:GetBorderTall()
	return self.borderH
end

local fadeToTop = Material("forp/ui/interface/shared/line/fade_to_top.png")
local fadeToRight = Material("forp/ui/interface/shared/line/fade_to_right.png")

function INTERFACE:Paint(w, h)
	surface.SetDrawColor( SCHEMA:GetColor() )

	if ( self.borderW >= fadeWidth and self.borderH >= fadeWidth ) then
		local vSolidWidth = self.borderW - fadeWidth
		local hSolidWidth = self.borderH - fadeWidth

		surface.DrawRect( xScrMargin, sH() - yScrMargin - hSolidWidth, lineHeight, hSolidWidth)
		surface.SetMaterial(fadeToTop)
		surface.DrawTexturedRect( xScrMargin, sH() - yScrMargin - hSolidWidth - fadeWidth, lineHeight, fadeWidth )

		surface.DrawRect( xScrMargin, sH() - yScrMargin, vSolidWidth, lineHeight)
		surface.SetMaterial(fadeToRight)
		surface.DrawTexturedRect( xScrMargin + vSolidWidth, sH() - yScrMargin, fadeWidth, lineHeight )
	end

	if ( self.DrawMain ) then
		self:DrawMain()
	end
end




local elementOffset = 0
local textElement = "forpLabel"
local buttonElement = "forpButton"

function INTERFACE:AddInfoTab(title, value)
	local titlePnl = self:Add(textElement); titlePnl:SetText(title or "")
	local valuePnl = self:Add(textElement); valuePnl:SetText(value or "")

	local titleW, titleH = titlePnl:GetSize()
	local valueW, valueH = valuePnl:GetSize()
	titlePnl:SetPos(xScrMargin + xBorderMargin + lineHeight, sH() - titleH - yScrMargin - yBorderMargin - self.infosHeight)
	valuePnl:SetPos(0, sH() - valueH - yScrMargin - yBorderMargin - self.infosHeight)

	valuePnl:SetXEnd(xScrMargin - valueW + self.borderW)
	valuePnl:ApplyXEnd()

	local biggerHeight = math.max(titleH, valueH)
	self.infosHeight = self.infosHeight + biggerHeight + elementOffset

	return titlePnl, valuePnl
end

function INTERFACE:AddButton(title)
	local buttonPnl = self:Add(buttonElement)

	buttonPnl.OnTextChanged = function(this)
		local w = this:GetWide()
		local y = select(2, this:GetPos())
		this:SetPos(sW() - w - xScrMargin - xBorderMargin - lineHeight, y)
	end

	local h = buttonPnl:GetTall()
	self.buttonsHeight = self.buttonsHeight + h + elementOffset

	return buttonPnl
end

vgui.Register("forpInterface", INTERFACE, "Panel")




hook.Add("FalloutHUDShouldDraw", "forp_Interface", function()
	local interface = fo.ui.interface

	if ( IsValid(interface) and interface.HideFalloutHud ) then
		return false
	end
end)

hook.Add("HUDPaintBackground", "forp_Interface", function()
	local interface = fo.ui.interface

	if ( IsValid(interface) and interface.DrawBlur ) then
		Derma_DrawBackgroundBlur(interface)
	end
end)