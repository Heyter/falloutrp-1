function loot.EyeTrace(ply)
	local data = {}
	data.filter = ply
	data.start = ply:GetShootPos()
	data.endpos = data.start + ply:GetAimVector()*80

	return util.TraceLine(data).Entity
end

--[[ Meta tables ]]--

local entMeta = FindMetaTable("Entity")

---------------------

function entMeta:GetCorpseID()

	local id = self:GetNW2Int("corpseId")

	if (id > 0) then
		return id
	end

end

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

    }, minMoney = 0, maxMoney = 20},

}