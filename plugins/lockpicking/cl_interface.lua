local PLUGIN = PLUGIN
local Interface = PLUGIN.interface or {}

function Interface.InitVars()
	self:SetIntFreeze(true)
	self:SetIntSounds({})
	self:SetIntLockAngle(0)
	self:SetIntOldPinRotation(0)
	self:SetIntNextPickSound(1.5)
end

-- Play/stop sounds
function Interface.PlaySound(soundName, soundLevel, volume, id)
	local sound = CreateSound(LocalPlayer(), soundName)
	sound:ChangeVolume(volume)
	sound:SetSoundLevel(soundLevel)
	sound:Play()
		
	if (id) then
		if (!Interface.Sounds) then
			Interface.Sounds = {}
		end
		
		Interface.Sounds[id] = sound
	end
end

function Interface.StopSound(id)
	if (Interface.Sounds && Interface.Sounds[id]) then
		Interface.Sounds[id]:Stop()
		Interface.Sounds[id] = nil
	end
end

-- Start the interface
function Interface.Start()
	fo.ui.LockCursor()
	fo.ui.DarkVignette(true)
	Interface.InitVars()
	Interface.OpenPanel()
end

function Interface.Stop()
	timer.Remove("lpEnterSound")
	Interface.StopSound("enter")

	removeVars()
	timer.Simple(PLUGIN.FadeTime, function()
		LocalPlayer():FreezeMove(false)
		fo.ui.UnlockCursor()
	end)
end

function PLUGIN:PlayerButtonDown(ply, btn)
	if ( Interface.Displaying ) then return end

	if (btn == KEY_A) then
		if (PLUGIN.LockAngle != 0) then return end
		if (PLUGIN.Success) then return end
		if (PLUGIN.ChangingPin) then return end
		if (PLUGIN.LastRotating) && (CurTime() - PLUGIN.LastRotating < PLUGIN.SpamTime + 0.08) then return end

		netstream.Start("lpRotat", true, PLUGIN.PinAngle)
		PLUGIN.LastRotating = CurTime()
				
		PLUGIN.RotatingLock = true

	elseif (btn == KEY_Q) then
		netstream.Start("lpStop")
		stop()
	end
end)

hook.Add("PlayerButtonUp", "lpInputsUp", function(ply, btn)
	if (!PLUGIN.ShouldDisplay) then return end
	if (ply != LocalPlayer()) then return end

	if (btn == KEY_A) then
		if (!PLUGIN.RotatingLock) then return end
		if (PLUGIN.Success) then return end
		if (PLUGIN.ChangingPin) then return end

		netstream.Start("lpRotat", false)
		PLUGIN.RotatingLock = false
	end
end)

netstream.Hook("lpMax", function(pickAng, ang)
	if (tostring(pickAng) == tostring(PLUGIN.PinAngle)) then
		local curTime = CurTime()

		PLUGIN.MaxLockAngle = ang
	end
end)

netstream.Hook("lpStart", function(door, itemId)
	PLUGIN.Item = nut.item.instances[itemId]
	start()
end)

netstream.Hook("lpStop", function(failed)
	stopSound("tension")

	if (failed) then
		playSound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)
	end

	stop()
end)

netstream.Hook("lpStarting", function(state, enterMoment)
	PLUGIN.Freeze = state

	if (state) then
		if (enterMoment) then
			timer.Create("lpEnterSound", enterMoment - 1, 1, function()
				playSound("lockpicking/enter.wav", 50, 1, "enter")
			end)
		end

		if (IsValid(nut.gui.menu)) then
			nut.gui.menu:Remove()
		end
	end
end)

netstream.Hook("lpChange", function(time)

	PLUGIN.ChangingPin = true
	PLUGIN.RotatingLock = false
	playSound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)

	timer.Create("lpEnterSound" ,time - 1, 1, function()
		playSound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	timer.Simple(time, function()
		PLUGIN.ChangingPin = false
	end)

end)

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
		
	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
end

-- Materials
local matLockinside = Material( "vgui/fallout/lockpicking/inner.png" )
local matLock = Material( "vgui/fallout/lockpicking/outer.png" )
local matLockpick = Material( "vgui/fallout/lockpicking/pick.png" )

local scrW
local scrH
local scale
local pickW
local pickH
local lockInnerW
local lockInnerH
local backgroundW
local backgroundH
local lockOuterW
local lockOuterH

hook.Add("LoadFonts", "ChangeLpHudResolutions", function()
	scrW = ScrW()
	scrH = ScrH()

	scale = (scrH/1080) * 0.75
	pickW = 836*scale
	pickH = 38*scale
	lockInnerW = 1037*scale
	lockInnerH = 1037*scale
	backgroundW = 730*scale
	backgroundH = 730*scale
	lockOuterW = 1037*scale
	lockOuterH = 1037*scale
end)

local nextVib = 0
local vib = false
local function display()
	if (!PLUGIN.ShouldDisplay) then return end
	
	-- Draw a black background to avoid transparency behing the lock
	surface.SetDrawColor( color_black )
	surface.DrawRect( (scrW / 2) - (backgroundW / 2), (scrH / 2) - (backgroundH / 2), backgroundW, backgroundH )
	
	-- Draw the outter lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLock )
	surface.DrawTexturedRect( (scrW / 2) - (lockInnerW / 2), (scrH / 2) - (lockInnerH / 2), lockOuterW, lockOuterH)

	PLUGIN.MaxLockAngle = PLUGIN.MaxLockAngle or PLUGIN.HardMaxAngle

	local exceedMax

	if (!PLUGIN.Success) then
		
		if (PLUGIN.RotatingLock && !PLUGIN.ChangingPin) then
			PLUGIN.LockAngle = PLUGIN.LockAngle - (PLUGIN.TurningSpeed * FrameTime())

			if (PLUGIN.LockAngle < PLUGIN.MaxLockAngle) then
				exceedMax = true
				PLUGIN.LockAngle = PLUGIN.MaxLockAngle
			end

			if (!PLUGIN.CylinderTurned) then

				playSound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
				playSound("lockpicking/a/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")

				PLUGIN.CylinderTurned = true
			end

		else
			PLUGIN.LockAngle = PLUGIN.LockAngle + (PLUGIN.ReleasingSpeed * FrameTime())
			PLUGIN.LockAngle = math.min(PLUGIN.LockAngle, 0)

			PLUGIN.CylinderTurned = nil

			stopSound("cylinder")
			stopSound("squeak")
		end

	end

	if (exceedMax) then

		if (PLUGIN.LockAngle <= PLUGIN.UnlockMaxAngle) then

			PLUGIN.Success = true
			netstream.Start("lpSuccess")
			playSound("lockpicking/unlock.wav", 50, 1)

		else

			if (!PLUGIN.CylinderStopped) then

				PLUGIN.CylinderStopped = true
				playSound("lockpicking/picktension.wav", 50, 1, "tension")
				playSound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)

			end

		end
		
	else
		
		PLUGIN.CylinderStopped = false
		stopSound("tension")

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
	surface.DrawTexturedRectRotated( scrW / 2, scrH / 2, lockInnerW, lockInnerH, lockRotationToDraw)
	
	-- Draw the bobbypin
	if (!PLUGIN.RotatingLock && !PLUGIN.Success && !PLUGIN.ChangingPin) then

		local mX, mY = gui.MouseX(), gui.MouseY()
		PLUGIN.PinAngle = math.deg(math.atan2(mY - scrH / 2, mX - scrW / 2))
			
		if (PLUGIN.OldPinRotation != PLUGIN.PinAngle) then

			PLUGIN.MaxLockAngle = nil

			PLUGIN.LastPickMove = CurTime()
			if (CurTime() > PLUGIN.NextPickSound) then
				PLUGIN.NextPickSound = CurTime() + math.Rand(0.5, 1)
				playSound("lockpicking/pickmovement_"..math.random(13)..".wav", 50, 1)
			end
				
			PLUGIN.OldPinRotation = PLUGIN.PinAngle
		end

	end
	if (!PLUGIN.ChangingPin) then
		surface.SetDrawColor( 200, 200, 200, 255 )
		surface.SetMaterial( matLockpick )
		surface.DrawTexturedRectRotatedPoint( scrW / 2, scrH / 2, pickW, pickH, 180 - PLUGIN.PinAngle, pickW / 2, 0 )
	end

	-- Display the key actions
	nut.util.drawText( L"lpKeys", scrW / 2, (scrH / 2) + (lockOuterH / 2), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, "Monofonto18" )
	-- Display the bobbypins left
	nut.util.drawText( L("lpPinsLeft", PLUGIN.Item:GetQuantity()), scrW / 2, (scrH / 2) + (lockOuterH / 2) + 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, "Monofonto18" )

	-- Draw the action bar in this function to make it not hidden
	nut.bar.drawAction()
	
end
hook.Add("HUDPaint", "lpInterface", display)

hook.Add("OnSpawnMenuOpen", "lpRestrictSpawnMenu", function()
	if (PLUGIN.Freeze) then
		return false
	end
end)

hook.Add("CanDrawDoorInfo", "lpHideDoorInfo", function()
	if (PLUGIN.Freeze) then
		return false
	end
end)

hook.Add("CanDrawEntInt", "lpHideDoorInfo", function()
	if (PLUGIN.Freeze) then
		return false
	end
end)

PLUGIN.interface = Interface