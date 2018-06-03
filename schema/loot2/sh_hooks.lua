local entMeta = FindMetaTable( "Entity" )

-- Check if an entity is a corpse
function entMeta:IsCorpse()
    return self:GetNW2Bool("isCorpse")
end

-- Check that a player is looking the corpse
function loot.eyeTrace(ply)
	local data = {}
	data.filter = ply
	data.start = ply:GetShootPos()
	data.endpos = data.start + ply:GetAimVector()*80

	return util.TraceLine(data).Entity
end