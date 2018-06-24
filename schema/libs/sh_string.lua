fo.string = fo.string or {}

-- surface
local setFont = surface.SetFont
local getTextSize = surface.GetTextSize
-- string
local strSub = string.sub
local strLen = string.len
-- math
local mathCeil = math.ceil
-- table
local tblInsert = table.insert
local tblConcat = table.concat

function fo.string.Explode( seperators, str )
	local p = "[^"..tblConcat(seperators).."]+"

	local words = {}
	for w in str:gmatch(p) do
		tblInsert(words, w)
	end

	return words
end