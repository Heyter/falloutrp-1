local function initVars()
	FO_LP.ShouldDisplay = true
	FO_LP.Freeze = true
	FO_LP.Sounds = {}
	FO_LP.LockAngle = 0
	FO_LP.OldPinRotation = 0
	FO_LP.NextPickSound = 1.5
end

local function removeVars()
	FO_LP.ShouldDisplay = nil
	FO_LP.ChangingPin = nil
	FO_LP.CylinderStopped = nil
	FO_LP.CylinderTurned = nil
	FO_LP.LastRotating = nil
	FO_LP.LockAngle = nil
	FO_LP.NextPickSound = nil
	FO_LP.OldPinRotation = nil
	FO_LP.PinAngle = nil
	FO_LP.RotatingLock = nil
	FO_LP.Sounds = nil
	FO_LP.Item = nil
	FO_LP.LastPickMove = nil
	FO_LP.Success = nil
end

local fadeAlpha = 240
local function fadeIn()
	LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0,0,0,fadeAlpha), FO_LP.FadeTime, 0.5)
	timer.Create("lpFadeIn", FO_LP.FadeTime, 1, function()
		LocalPlayer():ScreenFade(SCREENFADE.STAYOUT, Color(0,0,0,fadeAlpha), 0, 0)
	end)
end

local function fadeOut()
	timer.Remove("lpFadeIn")
	LocalPlayer():ScreenFade(SCREENFADE.PURGE, Color(0,0,0,fadeAlpha), 0, 0)
	LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0,0,0,fadeAlpha), 0, 0)
	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0,0,0,fadeAlpha), FO_LP.FadeTime, 0)
end

FO_LP.EnableScreenClicker = FO_LP.EnableScreenClicker or gui.EnableScreenClicker
local function lockCursor()
	gui.EnableScreenClicker(true)
	gui.EnableScreenClicker = function() end
end

local function unlockCursor()
	gui.EnableScreenClicker = FO_LP.EnableScreenClicker
	gui.EnableScreenClicker(false)
end

-- Play/stop sounds
local function playSound(soundName, soundLevel, volume, id)

	local sound = CreateSound(LocalPlayer(), soundName)
	sound:ChangeVolume(volume)
	sound:SetSoundLevel(soundLevel)
	sound:Play()
		
	if (id) then
		if (!FO_LP.Sounds) then
			FO_LP.Sounds = {}
		end
			
		FO_LP.Sounds[id] = sound
	end

end

local function stopSound(id)

	if (FO_LP.Sounds && FO_LP.Sounds[id]) then
		FO_LP.Sounds[id]:Stop()
		FO_LP.Sounds[id] = nil
	end

end

-- Start the interface
local function start()
	lockCursor()
	initVars()
	fadeIn()
end

local function stop()
	timer.Remove("lpEnterSound")
	stopSound("enter")

	fadeOut()
	removeVars()
	timer.Simple(FO_LP.FadeTime, function()
		FO_LP.Freeze = nil
		unlockCursor()
	end)
end

hook.Add("PlayerButtonDown", "lpInputsDown", function(ply, btn)
	if (!FO_LP.ShouldDisplay) then return end
	if (ply != LocalPlayer()) then return end

	if (btn == KEY_A) then
		if (FO_LP.LockAngle != 0) then return end
		if (FO_LP.Success) then return end
		if (FO_LP.ChangingPin) then return end
		if (FO_LP.LastRotating) && (CurTime() - FO_LP.LastRotating < FO_LP.SpamTime + 0.08) then return end

		netstream.Start("lpRotat", true, FO_LP.PinAngle)
		FO_LP.LastRotating = CurTime()
				
		FO_LP.RotatingLock = true

	elseif (btn == KEY_Q) then
		netstream.Start("lpStop")
		stop()
	end
end)

hook.Add("PlayerButtonUp", "lpInputsUp", function(ply, btn)
	if (!FO_LP.ShouldDisplay) then return end
	if (ply != LocalPlayer()) then return end

	if (btn == KEY_A) then
		if (!FO_LP.RotatingLock) then return end
		if (FO_LP.Success) then return end
		if (FO_LP.ChangingPin) then return end

		netstream.Start("lpRotat", false)
		FO_LP.RotatingLock = false
	end
end)

netstream.Hook("lpMax", function(pickAng, ang)
	if (tostring(pickAng) == tostring(FO_LP.PinAngle)) then
		local curTime = CurTime()

		FO_LP.MaxLockAngle = ang
	end
end)

netstream.Hook("lpStart", function(door, itemId)
	FO_LP.Item = nut.item.instances[itemId]
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
	FO_LP.Freeze = state

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

	FO_LP.ChangingPin = true
	FO_LP.RotatingLock = false
	playSound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)

	timer.Create("lpEnterSound" ,time - 1, 1, function()
		playSound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	timer.Simple(time, function()
		FO_LP.ChangingPin = false
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
	if (!FO_LP.ShouldDisplay) then return end
	
	-- Draw a black background to avoid transparency behing the lock
	surface.SetDrawColor( color_black )
	surface.DrawRect( (scrW / 2) - (backgroundW / 2), (scrH / 2) - (backgroundH / 2), backgroundW, backgroundH )
	
	-- Draw the outter lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLock )
	surface.DrawTexturedRect( (scrW / 2) - (lockInnerW / 2), (scrH / 2) - (lockInnerH / 2), lockOuterW, lockOuterH)

	FO_LP.MaxLockAngle = FO_LP.MaxLockAngle or FO_LP.HardMaxAngle

	local exceedMax

	if (!FO_LP.Success) then
		
		if (FO_LP.RotatingLock && !FO_LP.ChangingPin) then
			FO_LP.LockAngle = FO_LP.LockAngle - (FO_LP.TurningSpeed * FrameTime())

			if (FO_LP.LockAngle < FO_LP.MaxLockAngle) then
				exceedMax = true
				FO_LP.LockAngle = FO_LP.MaxLockAngle
			end

			if (!FO_LP.CylinderTurned) then

				playSound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
				playSound("lockpicking/a/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")

				FO_LP.CylinderTurned = true
			end

		else
			FO_LP.LockAngle = FO_LP.LockAngle + (FO_LP.ReleasingSpeed * FrameTime())
			FO_LP.LockAngle = math.min(FO_LP.LockAngle, 0)

			FO_LP.CylinderTurned = nil

			stopSound("cylinder")
			stopSound("squeak")
		end

	end

	if (exceedMax) then

		if (FO_LP.LockAngle <= FO_LP.UnlockMaxAngle) then

			FO_LP.Success = true
			netstream.Start("lpSuccess")
			playSound("lockpicking/unlock.wav", 50, 1)

		else

			if (!FO_LP.CylinderStopped) then

				FO_LP.CylinderStopped = true
				playSound("lockpicking/picktension.wav", 50, 1, "tension")
				playSound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)

			end

		end
		
	else
		
		FO_LP.CylinderStopped = false
		stopSound("tension")

	end

	-- Lock vibration
	local lockRotationToDraw = FO_LP.LockAngle
	if (exceedMax) then
		if (CurTime() > nextVib) then
			nextVib = CurTime() + 0.035
			vib = !vib
		end

		if (vib) then
			lockRotationToDraw = FO_LP.LockAngle + 1
		end

	end

	-- Draw the inner lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLockinside )
	surface.DrawTexturedRectRotated( scrW / 2, scrH / 2, lockInnerW, lockInnerH, lockRotationToDraw)
	
	-- Draw the bobbypin
	if (!FO_LP.RotatingLock && !FO_LP.Success && !FO_LP.ChangingPin) then

		local mX, mY = gui.MouseX(), gui.MouseY()
		FO_LP.PinAngle = math.deg(math.atan2(mY - scrH / 2, mX - scrW / 2))
			
		if (FO_LP.OldPinRotation != FO_LP.PinAngle) then

			FO_LP.MaxLockAngle = nil

			FO_LP.LastPickMove = CurTime()
			if (CurTime() > FO_LP.NextPickSound) then
				FO_LP.NextPickSound = CurTime() + math.Rand(0.5, 1)
				playSound("lockpicking/pickmovement_"..math.random(13)..".wav", 50, 1)
			end
				
			FO_LP.OldPinRotation = FO_LP.PinAngle
		end

	end
	if (!FO_LP.ChangingPin) then
		surface.SetDrawColor( 200, 200, 200, 255 )
		surface.SetMaterial( matLockpick )
		surface.DrawTexturedRectRotatedPoint( scrW / 2, scrH / 2, pickW, pickH, 180 - FO_LP.PinAngle, pickW / 2, 0 )
	end

	-- Display the key actions
	nut.util.drawText( L"lpKeys", scrW / 2, (scrH / 2) + (lockOuterH / 2), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, "Monofonto18" )
	-- Display the bobbypins left
	nut.util.drawText( L("lpPinsLeft", FO_LP.Item:GetQuantity()), scrW / 2, (scrH / 2) + (lockOuterH / 2) + 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, nil, "Monofonto18" )

	-- Draw the action bar in this function to make it not hidden
	nut.bar.drawAction()
	
end
hook.Add("HUDPaint", "lpInterface", display)

hook.Add("OnSpawnMenuOpen", "lpRestrictSpawnMenu", function()
	if (FO_LP.Freeze) then
		return false
	end
end)

hook.Add("CanDrawDoorInfo", "lpHideDoorInfo", function()
	if (FO_LP.Freeze) then
		return false
	end
end)

hook.Add("CanDrawEntInt", "lpHideDoorInfo", function()
	if (FO_LP.Freeze) then
		return false
	end
end)