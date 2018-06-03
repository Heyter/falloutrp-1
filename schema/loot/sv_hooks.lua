local Corpse = {}
Corpse.__index = Corpse

loot.Corpses = loot.Corpses or {}
loot.CorpseId = loot.CorpseId or 1

local function GetCorpse(id)
    return loot.Corpses[id]
end


--[[ Corpse vars ]]--

function Corpse:SetEntity(ent)

    ent:SetNW2Int("corpseId", self:GetID())
    self.entity = ent

end

function Corpse:GetEntity()

    return self.entity

end

AccessorFunc( Corpse, "inv", "Inv" )
AccessorFunc( Corpse, "searchers", "Searchers" )
AccessorFunc( Corpse, "nextTrace", "NextTrace" )
AccessorFunc( Corpse, "id", "ID" )

---------------------


--[[ Meta tables ]]--

local plyMeta = FindMetaTable("Player")
local entMeta = FindMetaTable("Entity")

---------------------


--[[ Player vars ]]--

AccessorFunc( plyMeta, "lootSearchedCorpse", "SearchedCorpse" )

---------------------


--[[ Entity vars ]]--

AccessorFunc( entMeta, "lootCorpse", "Corpse" )

---------------------


--[[ Corpse creation/deletion ]]--

local function InitVars(corpse)

    corpse:SetID(loot.CorpseId)
    loot.CorpseId = loot.CorpseId + 1

    corpse:SetSearchers({})
    corpse:SetNextTrace(0)

end

function Corpse:New(entCreationFunc)

    local self = setmetatable({}, Corpse)

    InitVars(self)

    loot.Corpses[self:GetID()] = self

        function self:Think()

            if ( #self:GetSearchers() > 0 ) then

                if ( CurTime() > self:GetNextTrace() ) then

                    for k, v in pairs (self:GetSearchers()) do

                        if ( loot.EyeTrace(k) != self ) then

                            self:SetSearchState(k, false)

                        end

                    end

                    self:SetNextTrace( CurTime() + 0.15 )
                end

            end

        end
        hook.Add("Think", self, self.Think)


        -- Entity creation
        local corpseEnt = ents.Create( "prop_ragdoll" )

        corpseEnt:CallOnRemove("removeCorpse", function(ent)
            local corpse = ent:GetCorpse()
            
            if ( corpse ) then
                corpse:Delete()
            end
        end)

        self:SetEntity(corpseEnt)

        if (entCreationFunc) then
            entCreationFunc( self, corpseEnt )
        end
        --

    return self

end

function Corpse:Delete()

    local entity = self:GetEntity()
    local inv = self:GetInv()

    if ( IsValid(entity) ) then
        entity:Remove()
    end

    if (inv) then
		local inventory = nut.item.inventories[inv]

		if (inventory) then
			nut.item.inventories[inv] = nil
			nut.db.query("DELETE FROM nut_items WHERE _invID = "..inv)
			nut.db.query("DELETE FROM nut_inventories WHERE _invID = "..inv)
		end
	end

    self = nil

end

function entMeta:MakeCorpse()

    local entity = Corpse:New(
        
        function(corpse, newEnt)

            local Data = duplicator.CopyEntTable( self )
                duplicator.DoGeneric( newEnt, Data )
            newEnt:Spawn()
        
            newEnt.CanConstrain	= false
            newEnt.CanTool			= false
            newEnt.GravGunPunt		= false
            newEnt.PhysgunDisabled	= true

            local Vel = self:GetVelocity()

            local iNumPhysObjects = newEnt:GetPhysicsObjectCount()
            for Bone = 0, iNumPhysObjects-1 do

                local PhysObj = newEnt:GetPhysicsObjectNum( Bone )
                if ( PhysObj:IsValid() ) then

                    local Pos, Ang = self:GetBonePosition( newEnt:TranslatePhysBoneToBone( Bone ) )
                    PhysObj:SetPos( Pos )
                    PhysObj:SetAngles( Ang )
                    PhysObj:AddVelocity( Vel )

                end

            end

            corpse:LootFromVictim(self)

        end
        
    )

    return entity

end


function loot.CorpseFromData(tbl)

    local entity = Corpse:New(

        function(corpse, newEnt)

            local Data = tbl[1]

            local newEnt = ents.Create( "prop_ragdoll" )
                duplicator.DoGeneric( newEnt, Data )
            newEnt:Spawn()

            newEnt.CanConstrain	= false
            newEnt.CanTool			= false
            newEnt.GravGunPunt		= false
            newEnt.PhysgunDisabled	= true

            local iNumPhysObjects = newEnt:GetPhysicsObjectCount()
            for Bone = 0, iNumPhysObjects-1 do

                local PhysObj = newEnt:GetPhysicsObjectNum( Bone )
                if ( PhysObj:IsValid() ) then

                    local Pos = tbl[2][Bone][1]
                    local Ang = tbl[2][Bone][2]
                    PhysObj:SetPos( Pos )
                    PhysObj:SetAngles( Ang )

                end

            end

            self:SetInv(tbl[3])

        end

    )

    return entity

end


-- [[ Loot creation ]] --

function Corpse:LootFromVictim(victim)

    local entity = self:GetEntity()

    local newInventory
        nut.item.newInv(0, "corpse", function(inv)
            newInventory = inv
        end)

    self:SetInv( newInventory:getID() )

    if (victim:IsPlayer()) then

        local char = victim:getChar()
        local inv = char:getInv()

        -- Money
        entity:SetNW2Int("lootMoney", char:getMoney())
        char:setMoney(0)
        
        -- Inventory size
        local w = inv.w
        local h = inv.h

        newInventory.w = w
        newInventory.h = h

        -- Transfer item
        local newInvId = newInventory:getID()

        local transfer = nut.meta.item.transfer
        local getData = nut.meta.item.getData
        local call = nut.meta.item.call

        for k, v in ipairs(inv.slots) do
            for k2, v2 in ipairs(v) do
                if ( getData(v2, "equip")) then
                    call(v2, "EquipUn", victim)
                end

                transfer(v2, newInvId, item.gridX, item.gridY)
            end
	    end

    else

        newInventory.w = 5
        newInventory.h = 5

        local random = math.random
        local tableRandom = table.Random

        local class = victim:GetClass()
        local info = loot.npcLoot[class]

        -- Money
        entity:SetNW2Int("lootMoney", random(info.minMoney, info.maxMoney))

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

------------------------


-- [[ Search corpses ]] --

function Corpse:SetSearchState(ply, state)

    if ( IsValid(ply) ) then

        if (state) then
            ply:SetSearchedCorpse(corpse)
        else
            ply:SetSearchedCorpse(nil)
        end

        local searchers = self:GetSearchers()
        searchers[ply] = state

    end

end

function Corpse:GetSearchState(ply)

    if ( IsValid(ply) ) then

        return ( ply:GetSearchedCorpse() == self )
        
    end

end

function plyMeta:OpenCorpse(corpse)

    corpse:SetSearchState(self, true)

    local corpseInv = corpse:GetInv()
    local corpseEnt = corpse:GetEntity()

        local nutInventories = nut.item.inventories
        
        if (!nutInventories[corpseInv]) then
            nutItem.restoreInv(corpseInv, 5, 5)
        end
        
        nutInventories[corpseInv]:sync(self)

    netstream.Start(self, "lOpn", corpseEnt:EntIndex(), corpseInv)

end


function plyMeta:CloseCurrentCorpse(shareToClient)

    local corpse = self:GetSearchedCorpse()

    if (corpse) then

        corpse:SetSearchState(self, false)
        
        netstream.Start(client, "lCls")

    end

end

--------------------------

netstream.Hook("lOpn", function(client, corpseId)

    if ( !IsValid(client) ) then return end

    local corpse = GetCorpse(corpseId)

    if ( corpse ) then

        local corpseEnt = corpse:GetEntity()

        if ( loot.EyeTrace(client) == corpseEnt ) then

            client:setAction("Searching...", 1)
            client:doStaredAction(corpseEnt, function() 
                -- On finished
                if IsValid(corpseEnt) then
                    client:OpenCorpse( corpse )
                end

            end, 1, function()
                -- On cancel
                if (IsValid(client)) then
                    client:setAction()
                end

            end, 80)

        end

    end

end)

netstream.Hook("lCls", function(client, corpseId)

    if (!IsValid(client)) then return end

    local corpse = GetCorpse(corpseId)

    if ( corpse ) then

        corpse:SetSearchState( client, false )

    end

end)

-- Make the corpse when a player dead
hook.Add("PlayerDeath", "PlayerCorpses", function( victim, inflictor, attacker )
    local start = SysTime()
    local OldRagdoll = victim:GetRagdollEntity()
	if ( IsValid(OldRagdoll) ) then OldRagdoll:Remove() end

	victim:MakeCorpse()
    print(SysTime() - start)
end)

-- Make the corpse when a npc dead
hook.Add("OnNPCKilled", "NpcCorpses", function( npc, attacker, inflictor )

    local start = SysTime()
	if ( !loot.npcLoot[npc:GetClass()] ) then return false end

	npc:MakeCorpse()

end)