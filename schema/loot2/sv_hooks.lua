local entMeta = FindMetaTable("Entity")



-- [[ Corpses entities ]] --

local function GenericInit(corpse)

    corpse:SetNW2Bool("isCorpse", true)

    -- Remove inventory from DB when the corpse is removed
    corpse:CallOnRemove("remLoot", function(ent)
        local invId = ent.inventory

		if (!nut.shuttingDown and !ent.nutIsSafe and index) then
			local item = nut.item.inventories[invId]

			if (item) then
				nut.item.inventories[invId] = nil
				nut.db.query("DELETE FROM nut_items WHERE _invID = "..invId)
				nut.db.query("DELETE FROM nut_inventories WHERE _invID = "..invId)
			end
		end
    end)

    -- Close inventory if player is not looking the corpse
    function corpse:Think()

        if (CurTime() > self.nextThink) then

            for k, v in pairs(self.players or {}) do

                if (!IsValid(k) or !loot.eyeTrace(k) == self) then
                    loot.CloseInv(k, self)
                end

            end

            self.nextThink = CurTime() +  0.2
        end

    end

    corpse.nextThink = 0
    hook.Add("Think", corpse, Think)

end

-- Make a corpse from a player
function entMeta:MakeCorpse()

	local Data = duplicator.CopyEntTable( self )

	local Ent = ents.Create( "prop_ragdoll" )
		duplicator.DoGeneric( Ent, Data )
    Ent:SetNW2Int("corpseEntIndex", self:EntIndex())
	Ent:Spawn()

	Ent.CanConstrain	= false
	Ent.CanTool			= false
	Ent.GravGunPunt		= false
	Ent.PhysgunDisabled	= true

	local Vel = self:GetVelocity()

	local iNumPhysObjects = Ent:GetPhysicsObjectCount()
	for Bone = 0, iNumPhysObjects-1 do

		local PhysObj = Ent:GetPhysicsObjectNum( Bone )
		if ( PhysObj:IsValid() ) then

			local Pos, Ang = self:GetBonePosition( Ent:TranslatePhysBoneToBone( Bone ) )
			PhysObj:SetPos( Pos )
			PhysObj:SetAngles( Ang )
			PhysObj:AddVelocity( Vel )

		end

	end

    Ent:MakeLoot(self)

    GenericInit(Ent)

end

-- Make a corpse from a data table ( used for permanent entities )
function loot.CorpseFromTable(tbl)
	
	local Data = tbl[1]

	local Ent = ents.Create( "prop_ragdoll" )
		duplicator.DoGeneric( Ent, Data )
	Ent:Spawn()

	Ent.CanConstrain	= false
	Ent.CanTool			= false
	Ent.GravGunPunt		= false
	Ent.PhysgunDisabled	= true

	local iNumPhysObjects = Ent:GetPhysicsObjectCount()
	for Bone = 0, iNumPhysObjects-1 do

		local PhysObj = Ent:GetPhysicsObjectNum( Bone )
		if ( PhysObj:IsValid() ) then

			local Pos = tbl[2][Bone][1]
			local Ang = tbl[2][Bone][2]
			PhysObj:SetPos( Pos )
			PhysObj:SetAngles( Ang )

		end

	end
    
    -- Assign inventory to the ent
	Ent.inventory = tbl.inventory

    CorpseInit(Ent)

end

-- Make the corpse when a player dead
local function PlayerDeath( victim, inflictor, attacker )
    local start = SysTime()
	local OldRagdoll = victim:GetRagdollEntity()
	if ( IsValid(OldRagdoll) ) then OldRagdoll:Remove() end

	victim:MakeCorpse()
    print(SysTime() - start)
end

hook.Add("PlayerDeath", "PlayerCorpses", PlayerDeath)

-- Make the corpse when a npc dead
local function OnNPCKilled(npc, attacker, inflictor)

    local start = SysTime()
	if ( !loot.npcLoot[npc:GetClass()] ) then return false end

	npc:MakeCorpse()
    print(SysTime() - start)

end

hook.Add("OnNPCKilled", "NpcCorpses", OnNPCKilled)



-- [[ Looting ]] --

loot.npcLoot = {

    npc_metropolice = {minTry = 0, maxTry = 4, maxRarity = 8, list = {
        
        [0] = {
            {id = "aviators"},
        },

        [2] = {
            {id = "2"},
        },

        [4] = {
            {id = "4"},
            {id = "4"}
        },

        [8] = {
            {id = "8", min = 1, max = 2},
            {id = "8"}
        }

    }, minMoney = 0, maxMoney = 100},

}

local function NewInventory()

    local newInventory
        nut.item.newInv(0, "corpse", function(inv)
            newInventory = inv
        end)

    return newInventory

end

function entMeta:MakeLoot(from)

    local newInventory = NewInventory()
    self.inventory = newInventory:getID()

    if (from:IsPlayer()) then

        local char = from:getChar()
        local inv = char:getInv()

        -- Money
        self:SetNW2Int("lootMoney", char:getMoney())
        char:setMoney(0)
        
        -- Inventory size
        newInventory.w = inv.w
        newInventory.h = inv.h

        -- Transfer item
        local newInvId = newInventory:getID()
        local transfer = nut.meta.item.transfer

        for k, item in pairs(inv:getItems()) do

            if ( item.functions.EquipUn ) then
                item.player = from
                item.functions.EquipUn.onRun(item)
            end

            transfer(item, newInvId, item.gridX, item.gridY)

        end

    else

        newInventory.w = 5
        newInventory.h = 5

        local random = math.random
        local tableRandom = table.Random

        local class = from:GetClass()
        local info = loot.npcLoot[class]

        -- Money
        self:SetNW2Int("lootMoney", random(info.minMoney, info.maxMoney))

        -- Items        
        local rarities = info.list
        local trys = random(info.minTry, info.maxTry)

        for i = 1, trys do

            local rarity = 0
            local itemList

            while (rarity < info.maxRarity) do
                local roll = random(0, 100)

                if (roll > 50) then
                    rarity = rarity + 1
                else
                    break
                end
            end

            for k, v in SortedPairs(rarities) do
                if (rarity >= k) then
                    itemList = k
                else
                    break
                end
                    
            end

            if (itemList) then

                item = tableRandom(rarities[itemList])

                local quantity
                if (item.max) then
                    quantity = random(item.min or 1, item.max)
                else
                    quantity = 1
                end

                newInventory:add(item.id, quantity)
                    
            end

        end

    end

end

local function OpenInv(client, corpse)

    local id = corpse.inventory

    local nutItem = nut.item.inventories
    local nutInventories = nutItem
    
    if (!nutInventories[id]) then
		nutItem.restoreInv(id, 5, 5)
	end
	
	nutInventories[id]:sync(client)
    
    netstream.Start(client, "lOpn", client:EntIndex(), id)

end

netstream.Hook("lOpn", function(client, ent)

    if (!IsValid(client)) then return end
    if (!isnumber(ent)) then return end

    ent = Entity(ent)

    if ( IsValid(ent) && ent:IsCorpse()) then

        client:setAction("Searching...", 1)
	    client:doStaredAction(ent, function() 
            -- On finished
            if IsValid(ent) then
            print(ent)
                OpenInv(client, ent)
            end

        end, 1, function()
            -- On cancel
            if (IsValid(client)) then
                client:setAction()
            end

	    end, 80)

    end

end)