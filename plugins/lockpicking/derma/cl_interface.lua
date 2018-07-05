local PLUGIN = PLUGIN
PLUGIN.res = PLUGIN.res or {}
local res = PLUGIN.res

local INTERFACE = {}
INTERFACE.borderW = 448
INTERFACE.borderH = 197
INTERFACE.Sounds = {}

function INTERFACE:OnInit()
	PLUGIN.Interface = self

	local exitBtn = self:AddButton("Exit E)")
	local self = self
    exitBtn.DoClick = function(this)
        self:Remove()
    end

	self:AddInfoTab("Lockpick Skill:", "32")
	self:AddInfoTab("Bobby Pins:", "15")
	self:AddInfoTab("Lock Level:", "Very Easy")
	
    self:AddButton("Force Lock [42%] F)")
end

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
		
	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
end

local matLockinside = Material( "vgui/fallout/lockpicking/inner.png" )
local matLock = Material( "vgui/fallout/lockpicking/outer.png" )
local matLockpick = Material( "vgui/fallout/lockpicking/pick.png" )

local nextVib = 0
local vib = false

function INTERFACE:DrawMain()
	-- Draw a black background to avoid transparency behing the lock
	surface.SetDrawColor( color_black )
	surface.DrawRect( (res.sW / 2) - (res.backgroundW / 2), (res.sH / 2) - (res.backgroundH / 2), res.backgroundW, res.backgroundH )
	
	-- Draw the outter lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLock )
	surface.DrawTexturedRect( (res.sW / 2) - (res.lockInnerW / 2), (res.sH / 2) - (res.lockInnerH / 2), res.lockOuterW, res.lockOuterH)

	PLUGIN.MaxLockAngle = PLUGIN.MaxLockAngle or PLUGIN.HardMaxAngle

	local exceedMax
	if (not PLUGIN.Success) then
		if (PLUGIN.RotatingLock && not PLUGIN.ChangingPin) then
			PLUGIN.LockAngle = PLUGIN.LockAngle - (PLUGIN.TurningSpeed * FrameTime())

			if (PLUGIN.LockAngle < PLUGIN.MaxLockAngle) then
				exceedMax = true
				PLUGIN.LockAngle = PLUGIN.MaxLockAngle
			end

			if (not PLUGIN.CylinderTurned) then
				PLUGIN:PlaySound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
				PLUGIN:PlaySound("lockpicking/a/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")

				PLUGIN.CylinderTurned = true
			end
		else
			PLUGIN.LockAngle = PLUGIN.LockAngle + (PLUGIN.ReleasingSpeed * FrameTime())
			PLUGIN.LockAngle = math.min(PLUGIN.LockAngle, 0)
			PLUGIN.CylinderTurned = nil

			PLUGIN:StopSound("cylinder")
			PLUGIN:StopSound("squeak")
		end
	end

	if (exceedMax) then
		if (PLUGIN.LockAngle <= PLUGIN.UnlockMaxAngle) then
			PLUGIN.Success = true
			netstream.Start("lpSuccess")
			PLUGIN:PlaySound("lockpicking/unlock.wav", 50, 1)
		else
			if (not PLUGIN.CylinderStopped) then
				PLUGIN.CylinderStopped = true

				PLUGIN:PlaySound("lockpicking/picktension.wav", 50, 1, "tension")
				PLUGIN:PlaySound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)
			end
		end
		
	else
		PLUGIN.CylinderStopped = false
		PLUGIN:StopSound("tension")
	end

	-- Lock vibration
	local lockRotationToDraw = PLUGIN.LockAngle
	if (exceedMax) then
		if (CurTime() > nextVib) then
			nextVib = CurTime() + 0.035
			vib = !vib
		end

		if (vib) then
			lockRotationToDraw = PLUGIN.LockAngle + 1
		end
	end

	-- Draw the inner lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLockinside )
	surface.DrawTexturedRectRotated( res.sW / 2, res.sH / 2, res.lockInnerW, res.lockInnerH, lockRotationToDraw)
	
	-- Draw the bobbypin
	if (not PLUGIN.RotatingLock && not PLUGIN.Success && not PLUGIN.ChangingPin) then
		local mX, mY = gui.MouseX(), gui.MouseY()
		PLUGIN.PinAngle = math.deg(math.atan2(mY - res.sH / 2, mX - res.sW / 2))
			
		if (PLUGIN.OldPinRotation != PLUGIN.PinAngle) then
			PLUGIN.MaxLockAngle = nil
			PLUGIN.LastPickMove = CurTime()

			if (CurTime() > PLUGIN.NextPickSound) then
				PLUGIN.NextPickSound = CurTime() + math.Rand(0.5, 1)
				PLUGIN:PlaySound("lockpicking/pickmovement_"..math.random(13)..".wav", 50, 1)
			end
				
			PLUGIN.OldPinRotation = PLUGIN.PinAngle
		end

	end
	if (not PLUGIN.ChangingPin) then
		surface.SetDrawColor( 200, 200, 200, 255 )
		surface.SetMaterial( matLockpick )
		surface.DrawTexturedRectRotatedPoint( res.sW / 2, res.sH / 2, res.pickW, res.pickH, 180 - PLUGIN.PinAngle, res.pickW / 2, 0 )
	end

	nut.bar.drawAction()
end

function PLUGIN:PlayerButtonDown(ply, btn)
	if (btn == KEY_A) then
		if (self.LockAngle ~= 0) then return end
		if (self.Success) then return end
		if (self.ChangingPin) then return end
		if (self.LastRotating and CurTime() - self.LastRotating < self.SpamTime + 0.08) then return end

		netstream.Start("lpRotat", true, self.PinAngle)

		self.LastRotating = CurTime()
		self.RotatingLock = true
	elseif (btn == KEY_Q) then
		netstream.Start("lpStop")
		self:CloseInterface()
	end
end

function PLUGIN:PlayerButtonUp(ply, btn)
	if (btn == KEY_A) then
		if (not self.RotatingLock) then return end
		if (self.Success) then return end
		if (self.ChangingPin) then return end

		netstream.Start("lpRotat", false)

		self.RotatingLock = false
	end
end

vgui.Register("forpLockpick", INTERFACE, "forpInterface")