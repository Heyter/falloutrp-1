-- [[ Search corpses ]] --

local plyP
local lootP
local corpseEnt
local inventory

function loot.OpenUI()

    local char = LocalPlayer():getChar()
    local plyInv = char:getInv()

    if ( plyInv ) then
        -- Items
		
        plyP = vgui.Create("nutInventory")
        lootP = vgui.Create("nutInventory")

        plyP:ShowCloseButton(true)
        plyP:setInventory(plyInv)

    	plyP.OnClose = function()
			lootP:Remove()
			loot.CloseInv()
		end

        lootP:ShowCloseButton(true)
        lootP:setInventory(inventory)

        lootP.OnClose = function()
			plyP:Remove()
			loot.CloseInv()
		end


        -- Retrieve money
        local text = plyP:Add("DLabel")

		text.Think = function()
			text:SetText(nut.currency.get(char:getMoney()))
		end
		text:Dock(BOTTOM)
		text:DockMargin(0, 0, plyP:GetWide()/2, 0)
		text:SetTextColor(color_white)
		text:SetFont("nutGenericFont")
		
		local entry = plyP:Add("DTextEntry")

		entry:Dock(BOTTOM)
		entry:DockMargin(plyP:GetWide()/2, 0, 0, 0)
		entry:SetValue(0)
		entry:SetNumeric(true)

        local function retrieveMoney()

			local value = tonumber(entry:GetValue()) or 0

			if (value and value > 0) then
				if (char:hasMoney(value)) then
					netstream.Start("lMny-", entIndex, value)
					entry:SetValue(0)
				else
					nut.util.notify(L("provideValidNumber"))
					entry:SetValue(0)
				end
			else
				nut.util.notify(L("cantAfford"))
				entry:SetValue(0)
			end

		end

		entry.OnEnter = retrieveMoney

        local transfer = plyP:Add("DButton")
        
		transfer:Dock(BOTTOM)
		transfer:DockMargin(plyP:GetWide()/2, 40, 0, -40)
		transfer:SetText("Deposit")
		transfer.DoClick = retrieveMoney
		

        -- Deposit money
		local text1 = lootP:Add("DLabel")


		text1.Think = function()
			text1:SetText(nut.currency.get(corpseEnt:GetNW2Int("lootMoney", 0)))
		end			

		text1:Dock(BOTTOM)
		text1:DockMargin(0, 0, lootP:GetWide()/2, 0)
		text1:SetTextColor(color_white)
		text1:SetFont("nutGenericFont")
		
		local entry1 = lootP:Add("DTextEntry")

		entry1:Dock(BOTTOM)
		entry1:SetValue(corpseEnt:GetNW2Int("lootMoney", 0))
		entry1:SetNumeric(true)
		entry1:DockMargin(lootP:GetWide()/2, 0, 0, 0)

        local function depositMoney()

            local value = tonumber(entry1:GetValue()) or 0
            
			if (corpseEnt:GetNW2Int("lootMoney") >= value and value > 0) then
				netstream.Start("lMny+", entIndex, value)

				entry1:SetValue(0)
			elseif value < 1 then
				nut.util.notify(L("provideValidNumber"))

				entry1:SetValue(0)
			else
				nut.util.notify(L("cantAfford"))

				entry1:SetValue(0)
			end

        end

		entry1.OnEnter = depositMoney
		
		local transfer1 = lootP:Add("DButton")

		transfer1:Dock(BOTTOM)
		transfer1:DockMargin(lootP:GetWide()/2, 40, 0, -40)
		transfer1:SetText("Retirer")
		transfer1.DoClick = depositMoney

        plyP:SetSize(plyP:GetWide(), plyP:GetTall() + 48)
        lootP:SetSize(lootP:GetWide(), lootP:GetTall() + 48)
        lootP:MoveRightOf(plyP, 4)

    end

end

function loot.CloseUI()

    if ( IsValid(plyP) ) then
        plyP:Remove()
    end

    if ( IsValid(lootP) ) then
        lootP:Remove()
    end

end

function loot.CloseInv()

    netstream.Start("lCls", corpseEnt:GetCorpseID())

end

local nextTrace = 0
hook.Add("PreDrawHUD", "CloseInterface", function()

    if ( !IsValid(corpseEnt) ) then
        loot.CloseUI()
    end

    if ( CurTime() > nextTrace ) then

        if ( loot.EyeTrace(LocalPlayer()) != corpseEnt ) then
            loot.CloseUI()
        end

		nextTrace = CurTime() + 0.15
    end

end)

--------------------------

netstream.Hook("lOpn", function(entIndex, invId)

    if ( !isnumber(entIndex) ) then return end
    if ( !isnumber(invId) ) then return end

    local entity = Entity(entIndex)
    local inv = nut.item.inventories[invId]

    if ( IsValid(entity) && inv ) then

        corpseEnt = entity
        inventory = inv

        loot.OpenUI()

    end

end)

hook.Add( "KeyPress", "OpenCorpses", function( ply, key )

    if (key == IN_USE) then

        local trace = loot.EyeTrace(ply)

        if (IsValid(trace)) then

            local corpseId = trace:GetCorpseID()

            if (corpseId) then

                netstream.Start("lOpn", corpseId)

            end

        end

    end

end)

hook.Add( "CreateClientsideRagdoll", "RemoveNpcRagdolls", function( entity, ragdoll )

	if ( entity:IsNPC() && loot.npcLoot[entity:GetClass()] ) then
		ragdoll:Remove()
	end

end )