local PANEL = {}


function PANEL:Init()

    local plyP = vgui.Create("nutInventory")

    plyP:ShowCloseButton(true)
    plyP:setInventory(LocalPlayer():getChar():getInv())

    
end

function PANEL:SetLootInventory(inv)



end

vgui.Register("lootInv", PANEL, "DFrame")