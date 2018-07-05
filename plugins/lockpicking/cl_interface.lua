local PLUGIN = PLUGIN

PLUGIN.Sounds = PLUGIN.Sounds or {}
PLUGIN.res = PLUGIN.res or {}
local res = PLUGIN.res

function PLUGIN:LoadFonts()
	res.sW = sW()
	res.sH = sH()

	res.scale = (res.sH/1080) * 0.75
	res.pickW = 836 * res.scale
	res.pickH = 38 * res.scale
	res.lockInnerW = 1037 * res.scale
	res.lockInnerH = 1037 * res.scale
	res.backgroundW = 730 * res.scale
	res.backgroundH = 730 * res.scale
	res.lockOuterW = 1037 * res.scale
	res.lockOuterH = 1037 * res.scale
end

function PLUGIN:OpenInterface()
	local interface = vgui.Create("forpLockpick")
	interface:OnInit()

	self.LockAngle = 0
	self.OldPinRotation = 0
	self.NextPickSound = 1.5
end

function PLUGIN:CloseInterface()
	if ( IsValid(PLUGIN.Interface) ) then
		PLUGIN.Interface:Remove()
	end

	self.ShouldDisplay = nil
	self.ChangingPin = nil
	self.CylinderStopped = nil
	self.CylinderTurned = nil
	self.LastRotating = nil
	self.LockAngle = nil
	self.NextPickSound = nil
	self.OldPinRotation = nil
	self.PinAngle = nil
	self.RotatingLock = nil
	self.LastPickMove = nil
	self.Success = nil
end

function PLUGIN:PlaySound(soundName, soundLevel, volume, id)
    local sound = CreateSound(LocalPlayer(), soundName)
	sound:ChangeVolume(volume)
	sound:SetSoundLevel(soundLevel)
	sound:Play()
		
	if (id) then
		PLUGIN.Sounds[id] = sound
    end
end

function PLUGIN:StopSound(id)
	if (PLUGIN.Sounds[id]) then
		PLUGIN.Sounds[id]:Stop()
		PLUGIN.Sounds[id] = nil
	end
end

netstream.Hook("lpMax", function(pickAng, ang)
	if (not IsValid(PLUGIN.Interface)) then return end

	if (tostring(pickAng) == tostring(PLUGIN.PinAngle)) then
		PLUGIN.MaxLockAngle = ang
	end
end)

netstream.Hook("lpStart", function(door, itemId)
	PLUGIN:OpenInterface()
end)

netstream.Hook("lpStop", function(failed)
	PLUGIN:StopSound("tension")

	if (failed) then
		PLUGIN:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)
	end

	PLUGIN:CloseInterface()
end)

netstream.Hook("lpStarting", function(state, enterMoment)
	if (state) then
		if (enterMoment) then
			timer.Create("lpEnterSound", enterMoment - 1, 1, function()
				PLUGIN:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
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
	PLUGIN:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)

	timer.Create("lpEnterSound" ,time - 1, 1, function()
		PLUGIN:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	timer.Simple(time, function()
		PLUGIN.ChangingPin = false
	end)
end)