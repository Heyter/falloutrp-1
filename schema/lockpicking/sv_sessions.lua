local session = {}
session.__index = session

FO_LP.Sessions = FO_LP.Sessions or {}

local function distCheck(ply, door)
	local data = {}
	data.filter = ply
	data.start = ply:GetShootPos()
	data.endpos = data.start + ply:GetAimVector()*FO_LP.MaxLookDistance

	return (util.TraceLine(data).Entity == door)
end

function FO_LP.IsDoorLocked(door)
	return door:GetSaveTable().m_bLocked or door.locked or false
end

function FO_LP.StartSession(door, ply, item)
	local self = setmetatable({}, session)

	-- Change wep to hands and save the old one
	local wep = ply:GetActiveWeapon()
	if (IsValid(wep)) then
		self.OldWep = wep:GetClass()
	end
	self.OldWepRaise = ply:isWepRaised()
	ply:SelectWeapon( "nut_hands" )

	-- Generate LockpickSession values
	self:InitVars(door, ply, item)

	-- Stared action that will launch the lockpicking
	local time = 0.08 * (30 - ply:getChar():getAttrib("lockpicking", 0)) + 1.2
	ply:setAction(L("lpStarting", ply), time)
	ply:doStaredAction(door, function()
		if (IsValid(ply)) then
			-- Insert in the sessions table
			FO_LP.Sessions[self] = true
			self.LastActivity = CurTime()
		
			-- Start Client interface
			netstream.Start(ply, "lpStart", door, item:getID())

			ply:setAction()
		end
	end, time, function()
		if (IsValid(ply)) then
			ply:setAction()
		end

		netstream.Start(ply, "lpStarting", false)
		self:RemoveVars()
	end, maxLookDistance)

	--Play starting sound
	timer.Create("lpEnterSound", time - 1, 1, function()
		self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	-- Freeze player locally and tell him to play the enter sound
	netstream.Start(ply, "lpStarting", true, time - ply:Ping() / 2000)
  
	return self
end

function FO_LP.GetPlayerPickingDoor(door)
	door:RunOnAllDoors(function(entity, args)
		local session = entity.LockpickSession

		if (session) then
			return session.Player
		end
	end)
end

local unlockSize = 4
local weakSize = 40
function session:InitVars(door, ply, item)
	-- Link between Entities/Session
	self.Door = door
	self.Player = ply
	self.Item = item
	ply.LockpickSession = self
	ply.LockpickFreeze = true
	door.LockpickSession = self

	-- Angles
	self.LockAngle = 0
	self.PinAngle = 0

	-- Generate unlock zone
	self.UnlockCenter = math.random(-180, 180)
	self.UnlockLimitA = self.UnlockCenter - unlockSize
	self.UnlockLimitB = self.UnlockCenter + unlockSize
	self.WeakLimitA = self.UnlockCenter - weakSize
	self.WeakLimitB = self.UnlockCenter + weakSize
end

function session:RemoveVars()
	local door = self.Door
	local ply = self.Player

	-- Link between Entities/Session
	if (IsValid(door)) then
		door.LockpickSession = nil
	end
	
	if (IsValid(ply)) then
		ply.LockpickSession = nil
		ply.LockpickFreeze = nil
	end

	FO_LP.Sessions[self] = nil
	self = nil
end

function session:UnlockDoor()
	local door = self.Door

	if (IsValid(door:getDoorPartner())) then
		door:RunOnAllDoors(function(entity, args)
			entity:Fire("unlock")
		end)
	end

	door:RunOnAllDoors(function(entity, args)
		entity:Fire("unlock")
	end)

	self:PlaySound("lockpicking/unlock.wav", 50, 1)
end

function session:StopSound(id)
	self.Door:RunOnAllDoors(function(entity, args)
		if (entity.lockpickSounds && entity.lockpickSounds[id]) then
			entity.lockpickSounds[id]:Stop()
			entity.lockpickSounds[id] = nil
		end
	end)
end

function session:PlaySound(soundName, soundLevel, volume, id)
	self.Door:RunOnAllDoors(function(entity, args)
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		filter:RemovePlayer( self.Player )
		
		local sound = CreateSound(entity, soundName, filter)
		sound:ChangeVolume(volume)
		sound:SetSoundLevel(soundLevel)
		sound:Play()
			
		if (id) then
			if !entity.lockpickSounds then
				entity.lockpickSounds = {}
			end
				
			entity.lockpickSounds[id] = sound
		end
	end)
end

function session:Stop(communicateToClient, failed)
	local ply = self.Player
	local item = self.Item
	
	if (self.ChangingPin) then ply:setAction() end // Stop bobbypin changing action
	if (communicateToClient or true) then netstream.Start(ply, "lpStop", failed) end // Tell the client to close the interface
	
	-- Stop sounds
	self:StopSound("tension")
	timer.Remove("lpEnterSound")
	self:StopSound("enter")

	-- Share rounded bobbypin health to client
	local oldHealth = item:getData("health")
	item:setData("health", math.Round(oldHealth))
	item:setData("health", oldHealth, false)

	-- Unfreeze player and restore his old weapon after the ScreenFade is done
	timer.Simple(FO_LP.FadeTime,function()
		ply.LockpickFreeze = nil
		ply:SelectWeapon(self.OldWep)
		timer.Simple(0.1, function()
			ply:setWepRaised(self.OldWepRaise)
		end)
	end)

	self:RemoveVars()
end

function session:Freeze(state)
	self.IsFreeze = state
end

netstream.Hook("lpRotat", function(ply, state, pickAng)
	local session = ply.LockpickSession
	local latency = ply:Ping() / 2000
	local time = CurTime()

	if (session && !session.IsFreeze) then
		if (state && !session.ChangingPin) then
			if (pickAng && session.LockAngle == 0) then
			
				session.PinAngle = pickAng

				local zone = session:GetLockZone()
				local maxAng = session:GetMaxLockAngle(zone)

				if (!session.OldPinAngle or (session.OldPinAngle != session.PinAngle)) then
					session:MakeShareTable(maxAng)
				end
				session.OldPinAngle = pickAng

				local ang, isLastAng = session:GetClientMaxAng()
				session.LockAngle = math.max(latency * -FO_LP.TurningSpeed, ang)

				-- Avoid spamming requests to know the unlock angle
				if (session.LastRotating && (time - session.LastRotating < FO_LP.SpamTime)) then
					session:Stop()
					return
				end

				session.LastRotating = time
				session.RotatingLock = true
			end
		else
			session.LockAngle = math.min(session.LockAngle + (latency * FO_LP.ReleasingSpeed), 0)
			session.RotatingLock = false
		end

		session.LastActivity = time
	end
end)

function session:ChangePin()
	local ply = self.Player

	self.RotatingLock = false
	self.ChangingPin = true

	local time = 0.06 * (30 - ply:getChar():getAttrib("lockpicking", 0)) + 1.2
	netstream.Start(ply, "lpChange", time - (ply:Ping() / 2000))

	timer.Create("lpEnterSound", time - 1, 1, function()
		self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	ply:setAction(L("lpChange", ply), time, function()
		self.ChangingPin = false
		self:Freeze(false)
	end)
end

function session:Fail()
	self:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)
	
	-- Reinsert another bobbypin
	if (self.Item:breakPin()) then
		self:ChangePin()
	else
		self:Stop(true, true)
	end
end

function session:Success()
	-- Unlock the door
	local door = self.Door

	if (IsValid(door:getDoorPartner())) then
		door:RunOnAllDoors(function(entity, args)
			entity:Fire("unlock")
		end)
	end
	door:RunOnAllDoors(function(entity, args)
		entity:Fire("unlock")
	end)
	self:PlaySound("lockpicking/unlock.wav", 50, 1)

	-- Freeze and stop the session
	self:Freeze(true)
	timer.Simple(0.5, function()
		self:Stop()
	end)
end

netstream.Hook("lpSuccess", function(ply)
	local session = ply.LockpickSession

	if (session) then
		session.AskingSuccess = true
	end

end)

local unlockZone = 1
local weakZoneLeft = 2
local weakZoneRight = 3
local hardZone = 4
function session:GetLockZone()
	local ang = self.PinAngle

	if (ang > self.UnlockLimitA && ang < self.UnlockLimitB) then
		return unlockZone
	elseif (ang > self.WeakLimitA && ang < self.UnlockLimitA) then
		return weakZoneLeft
	elseif (ang < self.WeakLimitB && ang > self.UnlockLimitB) then
		return weakZoneRight
	else
		return hardZone
	end
end

function session:GetMaxLockAngle(zone)
	if (zone == unlockZone) then
		return FO_LP.UnlockMaxAngle
	elseif (zone == weakZoneLeft) then
		return math.min(FO_LP.UnlockMaxAngle * (1 - ((self.UnlockLimitA - self.PinAngle) / (weakSize - unlockSize))), FO_LP.HardMaxAngle)
	elseif (zone == weakZoneRight) then
		return math.min(FO_LP.UnlockMaxAngle * (1 - math.abs((self.UnlockLimitB - self.PinAngle) / (weakSize - unlockSize))), FO_LP.HardMaxAngle)
	else
		return FO_LP.HardMaxAngle
	end
end

function session:StopCheck()
	local ply = self.Player
	local door = self.Door
	local time = CurTime()
	
	if (!IsValid(ply)) then self:Stop() return end
	if (!IsValid(door)) then self:Stop() return end
	if (!self.Item) then self:Stop() return end
	
	-- Avoid afk
	if ((time - self.LastActivity) > 20) then
		ply:ChatPrint("Lockpicking stopped due to inactivity")
		self:Stop()
		return
	end

	-- Check that the player is looking the door and near from it
	if (time > (self.NextDistCheck or 0)) then
		if (!distCheck(ply, door)) then
			ply:ChatPrint("You're too far from the door")
			self:Stop()
		end

		self.NextDistCheck = time + 0.1
	end

end

function session:MakeShareTable(maxAng)

	self.ShareTable = {}

	local angAmount = math.ceil(maxAng / -30)
	local index = 0

	for i=1, angAmount do

		local realAng = ((i - 1) * -30) + (math.max(maxAng - (i-1) * -30, -30))

		if (realAng != FO_LP.HardMaxAngle) then
			index = index + 1
			self.ShareTable[index] = {}
			self.ShareTable[index].RealAng = realAng
		end

	end

	self.ShareTable.AngAmount = index

end

function session:ShareAngle(maxAng)
	if (!self.ShareTable or self.ShareTable.Done) then return end

	local ply = self.Player
	local latency = ply:Ping() / 2000

	local angAmount = self.ShareTable.AngAmount

	if (angAmount != 0) then
		for i=angAmount, 1, -1 do
			local ang = self.ShareTable[i]

			if (!ang.Sent) then
				local realAng = self.ShareTable[i].RealAng

				local curAng = self.LockAngle
				local limit = math.min(realAng + 30, 0)

				if (math.abs((limit - curAng) / FO_LP.TurningSpeed) - 0.12 > latency) then
					ang.Sent = true
					ang.SendTime = SysTime()
					netstream.Start(ply, "lpMax", self.PinAngle, realAng)

					if (i == angAmount) then
						self.ShareTable.Done = true
					end

					break
				end
			end
		end
	end

end

function session:GetClientMaxAng()

	if (self.ShareTable) then
		local ply = self.Player
		local latency = ply:Ping() / 2000

		local angAmount = self.ShareTable.AngAmount
		for i=angAmount, 1, -1 do
			local ang = self.ShareTable[i]
			local realAng = self.ShareTable[i].RealAng
			local isLastAng = (i == angAmount)

			if (ang.Received) then
				return realAng, isLastAng
			end

			if (ang.Sent) then
				if (SysTime() > ang.SendTime + latency) then
					ang.Received = true
					return realAng, isLastAng
				end
			end
		end

		if (angAmount == 0) then
			return FO_LP.HardMaxAngle, true
		end
	end
	
	return FO_LP.HardMaxAngle, false
end

function session:Think()
	-- Checking that everything is alright
	self:StopCheck()

	-- Send max angle little by little to the player
	local zone = self:GetLockZone()
	self:ShareAngle(self:GetMaxLockAngle(zone))

	local curMaxLockAngle, isLastAng = self:GetClientMaxAng()
	local exceedMax
	
	if (self.RotatingLock && !self.ChangingPin) then
		self.LockAngle = self.LockAngle - FO_LP.TurningSpeed * FrameTime()
		
		-- Check if the lock is forced
		if (self.LockAngle < curMaxLockAngle) then
			exceedMax = true
			self.LockAngle = curMaxLockAngle
		end
		
		if (!self.CylinderTurned) then
			self:PlaySound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
			self:PlaySound("lockpicking/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")

			self.CylinderTurned = true
		end
		
	else
		self.LockAngle = self.LockAngle + ( FO_LP.ReleasingSpeed * FrameTime())
		self.LockAngle = math.min(self.LockAngle, 0)

		self.CylinderTurned = false

		self:StopSound("cylinder")
		self:StopSound("squeak")
	end

	if (exceedMax) then

		if (self.AskingSuccess && self.LockAngle == FO_LP.UnlockMaxAngle) then
			self:StopSound("tension")
			self:Success()
		else

			if !self.CylinderStopped then

				self.HoldTime = SysTime()
				self.CylinderStopped = true
				self:PlaySound("lockpicking/picktension.wav", 50, 1, "tension")
				self:PlaySound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)

			end

			if ((SysTime() - self.HoldTime > (self.Player:Ping() / 2000) + 0.1)) then // Avoid stop request time latency
				local item = self.Item

				local newHealth = item:getData("health", 100) - (65 / item.solidity) * FrameTime()
				item:setData("health", newHealth, false)

				if (newHealth <= 0) then
					self:Fail()
				end
			end

		end

	else

		self.CylinderStopped = false
		self.HoldTime = nil
		self:StopSound("tension")

	end
	
end

-- Call Think on every session
local Think = session.Think
hook.Add("Think", "LockpickSessionsThink", function()
	for k, v in pairs(FO_LP.Sessions) do if (!k.IsFreeze) then Think(k) end end
end)

-- Events that stop the sessions
hook.Add("EntityRemoved", "LockpickingStop1", function(door)
	local session = door.LockpickSession

	if (session) then
		session:Stop()
	end
end)

hook.Add("PlayerDeath", "LockpickingStop2", function(ply, inflictor, attacker)
	local session = ply.LockpickSession

	if (session) then
		session:Stop()
	end
end)

hook.Add("PlayerDisconnected", "LockpickingStop3", function(ply)
	local session = ply.LockpickSession

	if (session) then
		session:Stop()
	end
end)

netstream.Hook("lpStop", function(ply)
	local session = ply.LockpickSession

	if (session) then
		session:Stop(false)
	end
end)