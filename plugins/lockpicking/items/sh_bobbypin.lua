local PLUGIN = PLUGIN

ITEM.name = "Bobbypin Box"
ITEM.model = "models/ns_fallout/bobbypinbox.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 750
ITEM.solidity = 1
ITEM.isStackable = false
local bobbypinAmount = 4
local bobbypinHealth = 100

function ITEM:SetQuantity(quantity)
	self:setData("quantity", quantity)
end

function ITEM:GetQuantity()
	return self:getData("quantity", bobbypinAmount)
end

function ITEM:initHealth()
	self:setData("health", bobbypinHealth)
end

function ITEM:breakPin()
	local oldQuantity = self:GetQuantity()

	if oldQuantity == 1 then
		self:remove()
		return false
	else
		self:initHealth()
		self:setData("quantity", oldQuantity - 1)
		return true
	end
end

local conditions = {
	[85] = {"lpExcellent", {0, 179, 0}},
	[55] = {"lpWell", {255, 255, 0}},
	[35] = {"lpWeak", {255, 140, 26}},
	[25] = {"lpBad", {255, 51, 0}},
	[0] = {"lpVBad", {102, 0, 0}}
}

function ITEM:getCondition()
	local condition = conditions[0]
	local health = self:getData("health", bobbypinHealth)

	for k, v in SortedPairs(conditions) do
		if (health >= k) then
			condition = v
		else
			break
		end
	end

	return condition[1], condition[2]
end

function ITEM:getDesc()
	local desc = self.desc

	if self:isInBusinnessMenu() then
		return desc
	else
		local newDesc = ""

		if desc && desc != "" && desc != "noDesc" then
			newDesc = desc.."\n"
		end

		local state, color = self:getCondition()
		local localizedText = L("lpCondition", L(state))

		newDesc = newDesc.."<color="..color[1]..", "..color[2]..", "..color[3]..">"..localizedText.."</color>"
		return newDesc
	end
end

function ITEM:paintOver(item, w, h)
	local quantity

	if item:isInBusinnessMenu() then
		quantity = bobbypinAmount
	else
		quantity = item:GetQuantity()
	end
	
	draw.SimpleText(quantity, "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
end

function ITEM:isInBusinnessMenu()
	return (self:getID() == 0)
end

ITEM.functions.use = {
	name = "Pick a lock",
	tip = "useTip",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player
		
		local session = PLUGIN.StartSession(client:GetEyeTrace().Entity, client, item)

		if type(session) == "string" then
			client:notifyLocalized(session)
		else
			item.session = session
		end
		
		return false
	end,
	onCanRun = function(item)
		local ply
		if (SERVER) then
			ply = item.player
		else
			ply = LocalPlayer()
		end

		local data = {}
		data.filter = ply
		data.start = ply:GetShootPos()
		data.endpos = data.start + ply:GetAimVector()*PLUGIN.MaxLookDistance

		local ent = util.TraceLine(data).Entity

		if (!IsValid(ent) or !ent:isDoor()) then
			return false
		end

		if (SERVER) then
			if (!PLUGIN.IsDoorLocked(ent)) then
				ply:notifyLocalized("lpNotLocked")
				return false
			elseif (PLUGIN.GetPlayerPickingDoor(ent)) then
				ply:notifyLocalized("lpAlrLpcked")
				return false
			end
		end
		
	end
}

function ITEM:onRemoved()
	if self.session then
		self.session:Stop()
	end
end