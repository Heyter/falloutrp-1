FO_LP.UnlockMaxAngle = -90
FO_LP.HardMaxAngle = -30
FO_LP.TurningSpeed = 90
FO_LP.ReleasingSpeed = 200
FO_LP.FadeTime = 0.4
FO_LP.SpamTime = 0.1
FO_LP.MaxLookDistance = 25


-- Restrict player actions during lockpicking

local allowCommand
hook.Add("StartCommand", "lpRstrictInputs", function(ply, cmd)
    if (!allowCommand && ply.LockpickFreeze or (FO_LP.Freeze && ply == LocalPlayer())) then
        cmd:SetButtons(0)
    end

    allowCommand = false
end)

hook.Add("Move", "lpRstrictMove", function(ply, mvd)
    if (ply.LockpickFreeze or (FO_LP.Freeze && ply == LocalPlayer())) then
        return true
    end
end)

hook.Add("PlayerSwitchWeapon", "lpRstrictSwitch", function(ply, oldWep, newWep)
    local allowCommand = (newWep:GetClass() == "nut_hands")

	if (!allowCommand && ply.LockpickFreeze or (FO_LP.Freeze && ply == LocalPlayer())) then
        return true
    end
end)