FO_MRGNG.dataVars = {
	"skintone",
	"facemap",
	"eyecolor",
	"hair",
	"haircolor",
	"facialhair"
}

hook.Add("OnCharCreated", "sendHookToClient", function(client, char)
	netstream.Start(client, "charCreated", char:getID())
end)

netstream.Hook("applyBodyParts", function(client, charId, bodyData)

	if (nut.char.loaded[charId] && nut.char.loaded[charId]:getPlayer() == client && !nut.char.loaded[charId]:getData("bodyPartsAlreadySet")) then
		for k, v in pairs(FO_MRGNG.dataVars) do
			nut.char.loaded[charId]:setData(v, bodyData[v])
		end
		
		nut.char.loaded[charId]:setData("bodyPartsAlreadySet", true)
	end
		
end)

hook.Add("PlayerLoadout", "ApplyFalloutBody", function(client)
	if (client:getChar()) then
		if (client:IsFalloutHuman()) then

			client:SetModelScale(1, 1) 
			client.spawned = true
			
			if (client:getChar():getData("eyecolor")) then
				local gender = client:GetGender()
				local index = 3
			
				if (gender == "female") then
					index = 1
				end
			
				client:SetSubMaterial(index, "models/lazarus/shared/"..FO_MRGNG.EyeTable[client:getChar():getData("eyecolor")].mat)
			else
				local gender = client:GetGender()
				local index = 3
			
				if (gender == "female") then
					index = 1
				end

				client:SetSubMaterial(index, "models/lazarus/shared/"..FO_MRGNG.EyeTable[1].mat)
			end
			
			if (client:getChar():getData("facemap")) then
				if (client:GetGender() == "female") then
					local face = (client:getChar():getData("facemap") + 1)
					
					client:SetSubMaterial(0, "models/lazarus/female/"..FO_MRGNG.FemaleFaces[client:GetRace()][face])

				elseif (client:GetGender() == "male") then
					local face = (client:getChar():getData("facemap") + 1)
					
					client:SetSubMaterial(0, "models/lazarus/male/"..FO_MRGNG.MaleFaces[client:GetRace()][face])
						
				end
			end

			if (client:getChar():getData("hair")) then
				client:SetBodygroup(2, client:getChar():getData("hair"))
			else
				client:SetBodygroup(2, 1)
			end
			
			if (client:getChar():getData("haircolor")) then
				client:SetColor(FO_MRGNG.HairTable[client:getChar():getData("haircolor")].color)
			else
				client:SetColor(Color(255,255,255,255))
			end
			
			if (client:getChar():getData("facialhair")) then
				client:SetBodygroup(3, client:getChar():getData("facialhair"))
			else
				client:SetBodygroup(3, 0)
			end
			
			client:SetViewOffset(Vector(0,0,64))
		else
			client:SetColor(Color(255,255,255))
			client:SetSubMaterial(0, nil)
			client:SetSubMaterial(1, nil)
			client:SetSubMaterial(2, nil)
			client:SetSubMaterial(3, nil)
			client:SetMaterial(nil)
			client:SetBodyGroups("000000000")
			client:SetSkin(0)
		end
	end
end)