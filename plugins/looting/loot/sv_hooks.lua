local PLUGIN = PLUGIN

-- Create a corpse when a player die and transfer his loot in it
function PLUGIN:OnCorpseCreated(corpse, victim, char)
	local victimInventory = char:getInv()
	local victimMoney = char:getMoney()

	local corpseInventory = PLUGIN:CreateInventory(corpse, victimInventory.w, victimInventory.h)

	if ( corpseInventory ) then
		PLUGIN:TransferInventory(victimInventory, corpseInventory)
	end

	PLUGIN:TransferMoney(victim, corpse)

	-- Check that players are near and looking the corpses
	function corpse:EyeTraceCheck()
		if ( CurTime() < (self.NextTraceCheck or 0) ) then return end

		if ( self.Searchers ) then
			for k, _ in pairs(self.Searchers) do
				if ( PLUGIN:EyeTrace(k) ~= self ) then
					PLUGIN:CloseLoot(k, false)
				end
			end
		end
		
		self.NextTraceCheck = CurTime() + 0.1
	end
	hook.Add("Think", corpse, corpse.EyeTraceCheck)
end

-- Attach a new inventory to a corpse
function PLUGIN:CreateInventory(corpse, width, height)
	local inv
	nut.item.newInv(0, "corpse", function(instance)
		instance.w = width
		instance.h = height
		inv = instance
	end)

	corpse:SetVar("LootInv", inv)
	-- Remove inventory from db when the corpse is removed
	corpse:CallOnRemove("RemoveLootInv", function(ent)
		local inv = ent:GetVar("LootInv")
		local invId = inv:getID()

		if ( ( not nut.shuttingDown ) and ( not ent.nutIsSafe and inv ) ) then
			nut.item.inventories[invId] = nil
			nut.db.query("DELETE FROM nut_items WHERE _invID = " .. invId)
			nut.db.query("DELETE FROM nut_inventories WHERE _invID = " .. invId)
		end
	end)

	return inv
end

-- Transfer inventory items to another
function PLUGIN:TransferInventory(from, to)
	if ( not (from and to) ) then return end
	
	local fromSlots = from.slots
	local fromChar = nut.char.loaded[from.owner]
	local fromPlayer = fromChar:getPlayer()

	local toSlots = to.slots

	if ( fromSlots ) then
		for x, items in pairs(fromSlots) do
			for y, item in pairs(items) do
				if ( fromPlayer and item:getData("equip") ) then
					item:call("EquipUn", fromPlayer)
				end

				if ( not toSlots[x] ) then
					toSlots[x] = {}
				end
						
				toSlots[x][y] = item
				fromSlots[x][y] = nil
			end
		end

		-- Sync victim's character inventory
		for k, v in ipairs(fromChar:getInv(true)) do
			if (type(v) == "table") then 
				v:sync(fromPlayer)	
			end
		end
				
	end
end

-- Transfer the money from a character to another
function PLUGIN:TransferMoney(victim, corpse)
	local char = victim:getChar()
	local money = char:getMoney()

	corpse:SetVar("LootMoney", money)
	char:setMoney(0)
end

-- Make know that a player is currently seaching the corpse
function PLUGIN:RegSearcher(corpse, client)
	if ( not corpse.Searchers ) then
		corpse.Searchers = {}
	end
	corpse.Searchers[client] = true

	client:SetVar("LootCorpse", corpse)
end

-- Make know that a player is no longer seaching the corpse
function PLUGIN:UnregSearcher(corpse, client)
	if ( corpse.Searchers ) then
		corpse.Searchers[client] = nil
	end

	client:SetVar("LootCorpse", nil)
end

-- Close corpse loot
function PLUGIN:CloseLoot(client, share)
	local corpse = client:GetVar("LootCorpse")

	if ( IsValid(corpse) ) then

		PLUGIN:UnregSearcher(corpse, client)

		if ( share ) then
			netstream.Start(client, "lootExit")
		end

	end
end

netstream.Hook("lootExit", function(client)
	PLUGIN:CloseLoot(client)
end)

-- Open corpse loot
function PLUGIN:OpenLoot(corpse, client)
	if ( IsValid(corpse) ) then
		local inv = corpse:GetVar("LootInv")

		if ( inv ) then

			PLUGIN:RegSearcher(corpse, client)

			inv:sync(client)
			netstream.Start(client, "lootOpen", inv:getID(), corpse:GetVar("LootMoney"))
		end
	end
end

-- Stared action to open the inventory of a corpse
netstream.Hook("lootOpen", function(client)
	if ( not IsValid(client) ) then return end

	local corpse = PLUGIN:EyeTrace(client)

	if ( IsValid(corpse) and corpse:IsCorpse() ) then

		client:setAction("Searching...", 1)
		client:doStaredAction(corpse, function() 

			if ( IsValid(corpse) ) then
				PLUGIN:OpenLoot(corpse, client)
			end

		end, 1, function()
			if ( IsValid(client) ) then
				client:setAction()
			end

		end, PLUGIN.corpseMaxDist)

	end
end)

-- Send corpse money to all corpse searchers
function PLUGIN:ShareCorpseMoney(corpse)
	local searchers = corpse.Searchers
	
	if ( searchers ) then
		netstream.Start(searchers, "lootMoney", corpse:GetVar("LootMoney"))
	end
end

-- Widthdraw money from loot reserve
function PLUGIN:WidthdrawMoney(client, corpse, amount)
	local oldCorpseMoney = corpse:GetVar("LootMoney")
	
	if ( amount <= oldCorpseMoney ) then
		corpse:SetVar("LootMoney", oldCorpseMoney - amount)
		PLUGIN:ShareCorpseMoney(corpse)

		local char = client:getChar()
		char:giveMoney(amount)
	end
end

netstream.Hook("lootWdMny", function(client, amount)
	if ( not isnumber(amount) ) then return end
	if ( not IsValid(client) ) then return end

	local corpse = client:GetVar("LootCorpse")
	if ( not IsValid(corpse) ) then return end

	PLUGIN:WidthdrawMoney(client, corpse, amount)
end)

-- Deposit money to corpse reserve
function PLUGIN:DepositMoney(client, corpse, amount)
	local char = client:getChar()
	local oldCharMoney = char:getMoney()

	if ( amount <= oldCharMoney ) then
		local oldCorpseMoney = corpse:GetVar("LootMoney")
		corpse:SetVar("LootMoney", oldCorpseMoney + amount)
		PLUGIN:ShareCorpseMoney(corpse)

		char:takeMoney(amount)
	end
end

netstream.Hook("lootDpMny", function(client, amount)
	if ( not isnumber(amount) ) then return end
	if ( not IsValid(client) ) then return end

	local corpse = client:GetVar("LootCorpse")
	if ( not IsValid(corpse) ) then return end

	PLUGIN:DepositMoney(client, corpse, amount)
end)
