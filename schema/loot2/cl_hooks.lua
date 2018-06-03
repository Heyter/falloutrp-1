--[[ Corpse entites ]] --

local function NetworkEntityCreated(ent)

    if (ent:IsCorpse()) then

        local entIndex = ent:GetNW2Int("corpseEntIndex")

        if (entIndex) then

            local from = Entity(entIndex)
            
            if ( IsValid(from) ) then

                clothes.Clone(from, ent)

            end

        end

    end

end

hook.Add("NetworkEntityCreated", "CloneClothesOnCorpses", NetworkEntityCreated)

local function CreateClientsideRagdoll( entity, ragdoll )

    if ( entity:IsNPC() ) then ragdoll:Remove() end

end

hook.Add("CreateClientsideRagdoll", "RemoveNpcCorpses", CreateClientsideRagdoll)



-- [[ Looting ]] --

hook.Add("Think", "InterfaceCheck", function()

	if (corpse) then
		if (!IsValid(corpse)) then CloseInterface() end

		if (CurTime() > (corpse.nextThink or 0)) then

            if (!eyeTrace(LocalPlayer()) == self) then
                CloseInterface()
            end

            corpse.nextThink = CurTime() +  0.2
        end

	end

end)

local corpse
local interface = {}

function CloseInterface()
	for k, v in pairs(interface) do
		if (IsValid(v)) then
			v:Remove()
		end

		v = nil
	end
end

function CloseInv()

	netstream.Start("lCls")
	CloseInterface()

end

netstream.Hook("lCls", CloseInv)

function OpenInv( entIndex, invIndex )

    local ent = Entity(entIndex)
    local lootInv = nut.item.inventories[invIndex]

    if (!IsValid(ent) or !lootInv) then return end

	corpse = ent

    local char = LocalPlayer():getChar()
    local plyInv = LocalPlayer():getChar():getInv()


    if ( plyInv ) then

        -- Items
		
        interface.plyP = vgui.Create("nutInventory")
        interface.lootP = vgui.Create("nutInventory")

		local plyP = interface.plyP
		local lootP = interface.lootP

        plyP:ShowCloseButton(true)
        plyP:setInventory(plyInv)

        plyP.OnClose = function(this)
            CloseInv()
        end

        lootP:ShowCloseButton(true)
        lootP:setInventory(lootInv)

        lootP.OnClose = function(this)
			CloseInv()
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
			if (IsValid(corpse)) then
				text1:SetText(nut.currency.get(corpse:GetNW2Int("lootMoney", 0)))
			else
				CloseInterface()
			end
		end			

		text1:Dock(BOTTOM)
		text1:DockMargin(0, 0, lootP:GetWide()/2, 0)
		text1:SetTextColor(color_white)
		text1:SetFont("nutGenericFont")
		
		local entry1 = lootP:Add("DTextEntry")

		entry1:Dock(BOTTOM)
		entry1:SetValue(corpse:GetNW2Int("lootMoney", 0))
		entry1:SetNumeric(true)
		entry1:DockMargin(lootP:GetWide()/2, 0, 0, 0)

        local function depositMoney()

            local value = tonumber(entry1:GetValue()) or 0
            
			if (corpse:GetNW2Int("lootMoney") >= value and value > 0) then
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

netstream.Hook("lOpn", OpenInv)

local function KeyPress( ply, key )

    if (ply != LocalPlayer()) then return end

    if (key == IN_USE) then

        local trace = loot.eyeTrace(ply)

        if (IsValid(trace) && trace:IsCorpse()) then
            netstream.Start("lOpn", trace:EntIndex())
        end

    end

end

hook.Add( "KeyPress", "OpenCorpses", KeyPress )