local playerMeta = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

function playerMeta:SetEyeMaterial(eyemat)
	local index, material = 3, nut.util.getMaterial("models/lazarus/shared/"..eyemat)
	if (self:GetGender() == "female") then
		index = 1
	end
end

function Entity:IsFemale()
	local model = self:GetModel():lower()

	return model:find("female") or model:find("alyx") or model:find("mossman") or nut.anim.getModelClass(model) == "citizen_female"
end

function Entity:GetGender()
	if self:IsFemale() then
		return "female"
	else
		return "male"
	end
end

function playerMeta:IsRagdolled()
	local index = self:getNetVar("ragdoll", -1)
		local entity = Entity(index)

		if (SERVER) then
			return IsValid(entity), entity
		end

		return IsValid(entity) or index > 0, entity
end

function playerMeta:IsFalloutHuman()
	return FO_MRGNG.SkinTones[string.lower(self:GetModel())] != nil 
end

FO_MRGNG.SkinTones = {}
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/male_african.mdl"] = 3
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/male_asian.mdl"] = 7
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/male_caucasian.mdl"] = 1
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/male_hispanic.mdl"] = 5
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/female_african.mdl"] = 3
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/female_asian.mdl"] = 7
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/female_caucasian.mdl"] = 1
FO_MRGNG.SkinTones["models/lazarusroleplay/heads/female_hispanic.mdl"] = 5

function Entity:GetSkinTone()
	if FO_MRGNG.SkinTones[self:GetModel()] then
		return FO_MRGNG.SkinTones[self:GetModel()]
	elseif self:getChar() then
		if self:getChar():getData("facemap") then
			return self:getChar():getData("facemap") - 1
		else
			return 0
		end
	else
		return 0
	end
end

function playerMeta:GetRace()
	local race = "caucasian"

	if (FO_MRGNG.SkinTones[self:GetModel()]) and (FO_MRGNG.SkinTones[self:GetModel()] == 3) then
		race = "african"
	elseif (FO_MRGNG.SkinTones[self:GetModel()]) and (FO_MRGNG.SkinTones[self:GetModel()] == 7) then
		race = "asian"
	elseif (FO_MRGNG.SkinTones[self:GetModel()]) and (FO_MRGNG.SkinTones[self:GetModel()] == 1) then
		race = "caucasian"
	elseif (FO_MRGNG.SkinTones[self:GetModel()]) and (FO_MRGNG.SkinTones[self:GetModel()] == 5) then
		race = "hispanic"
	end

	return race
end

local holdTypes = {
	weapon_physgun = "smg",
	weapon_physcannon = "smg",
	weapon_stunstick = "melee",
	weapon_crowbar = "melee",
	weapon_stunstick = "melee",
	weapon_357 = "pistol",
	weapon_pistol = "pistol",
	weapon_smg1 = "smg",
	weapon_ar2 = "smg",
	weapon_crossbow = "smg",
	weapon_shotgun = "shotgun",
	weapon_frag = "grenade",
	weapon_slam = "grenade",
	weapon_rpg = "shotgun",
	weapon_bugbait = "melee",
	weapon_annabelle = "shotgun",
	gmod_tool = "pistol"
}

-- We don't want to make a table for all of the holdtypes, so just alias them.
local translateHoldType = {
	melee2 = "melee",
	fist = "melee",
	knife = "melee",
	physgun = "smg",
	crossbow = "ar2",
	slam = "grenade",
	passive = "normal",
	rpg = "shotgun"
}

--[[
	Purpose: Returns the weapon's holdtype for stuff like animation by either returning the holdtype
	from the table if it exists or if it is a SWEP return that one or fallback on normal.
--]]
function nut.util.GetHoldType(weapon)
	local holdType = holdTypes[weapon:GetClass()]

	if (holdType) then
		return holdType
	elseif (weapon.HoldType) then
		return translateHoldType[weapon.HoldType] or weapon.HoldType
	else
		return "normal"
	end
end

WEAPON_LOWERED = 1
WEAPON_RAISED = 2

local math_NormalizeAngle = math.NormalizeAngle
local string_find = string.find
local string_lower = string.lower
local getAnimClass = nut.anim.getModelClass
local getHoldType = nut.util.GetHoldType
local config = nut.config

local Length2D = FindMetaTable("Vector").Length2D

local NORMAL_HOLDTYPES = {
	normal = true,
	fist = true,
	melee = true,
	revolver = true,
	pistol = true,
	slam = true,
	knife = true,
	grenade = true
}

nut.config.add("allowEarGrab", false, "ShrekIsLife")

function FO_MRGNG:GrabEarAnimation(client)
	if (config.get("allowEarGrab")) then
		return self.BaseClass:GrabEarAnimation(client)
	end
end

hook.Add("IsFalloutModel", "blacktea_is_a_tea", function(ply)
	if ply:IsFalloutHuman() then
		return true
	end
end)

local animClasses = {
	["models/lazarusroleplay/heads/female_african.mdl"] = "fallout_female",
	["models/lazarusroleplay/heads/female_asian.mdl"] = "fallout_female",
	["models/lazarusroleplay/heads/female_caucasian.mdl"] = "fallout_female",
	["models/lazarusroleplay/heads/female_hispanic.mdl"] = "fallout_female",
	["models/lazarusroleplay/heads/male_african.mdl"] = "fallout_male",
	["models/lazarusroleplay/heads/male_asian.mdl"] = "fallout_male",
	["models/lazarusroleplay/heads/male_caucasian.mdl"] = "fallout_male",
	["models/lazarusroleplay/heads/male_hispanic.mdl"] = "fallout_male"
}

hook.Add("CalcMainActivity", "useFalloutModelsAnimations", function(client, velocity)
	local model = client:GetModel()
	local weapon = client:GetActiveWeapon()
	local holdType = "normal"
	local state = WEAPON_LOWERED
	local action = "idle"
	local length2D = Length2D(velocity)

	if (length2D >= config.get("runSpeed") - 10) then
		action = "run"
	elseif (length2D >= 5) then
		action = "walk"
	end

	if (IsValid(weapon)) then
		holdType = getHoldType(weapon)

		if (weapon.IsAlwaysRaised or ALWAYS_RAISED[weapon:GetClass()]) then
			state = WEAPON_RAISED
		end
	end

	if (client:isWepRaised()) then
		state = WEAPON_RAISED
	end

	if (!hook.Run("IsFalloutModel", client)) then
		local class = getAnimClass(string_lower(model))
		local calcIdeal, calcOverride = GAMEMODE.BaseClass:CalcMainActivity(client, velocity)
		client.CalcIdeal = calcIdeal
		client.CalcSeqOverride = calcOverride

		return client.CalcIdeal, client.CalcSeqOverride
	end
	
	local class = animClasses[model]

	if (client:getChar() and client:Alive()) then
		client.CalcSeqOverride = -1

		if (client:Crouching()) then
			action = action.."_crouch"
		end
		
		local animClass = nut.anim[class]

		if (!animClass) then
			class = "citizen_male"
		end

		if (!animClass[holdType]) then
			holdType = "normal"
		end

		if (!animClass[holdType][action]) then
			action = "idle"
		end

		local animation = animClass[holdType][action]
		local value = ACT_IDLE

		if (!client:OnGround()) then
			client.CalcIdeal = animClass.glide or ACT_GLIDE
		elseif (client:InVehicle()) then
			client.CalcIdeal = animClass.normal.idle_crouch[1]
		elseif (animation) then
			value = animation[state]

			if (type(value) == "string") then
				client.CalcSeqOverride = client:LookupSequence(value)
			else
				client.CalcIdeal = value
			end
		end

		local override = client:getNetVar("seq")

		if (override) then
			client.CalcSeqOverride = client:LookupSequence(override)
		end

		if (CLIENT) then
			client:SetIK(false)
		end

		local eyeAngles = client:EyeAngles()
		local yaw = velocity:Angle().yaw
		local normalized = math_NormalizeAngle(yaw - eyeAngles.y)

		client:SetPoseParameter("move_yaw", normalized)
		
		if client.nutForceSeq then
			return client.CalcIdeal, client.nutForceSeq or ACT_IDLE, client.CalcSeqOverride or -1
		end

		return client.CalcIdeal or ACT_IDLE, client.CalcSeqOverride or -1
	end
end)