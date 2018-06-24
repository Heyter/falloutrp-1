fo.string = fo.string or {}

function fo.string.Explode( seperators, str )
	local p = "[^"..table.concat(seperators).."]+"

	local words = {}
	for w in str:gmatch(p) do
		table.insert(words, w)
	end

	return words
end

function fo.string.WrapText( text, font, wLimit, w )
	w = w or math.ceil(string.len( text ) / 2)
	
	local words = fo.string.Explode( {" ", "\n"}, text )
	local lastWord

	local lines = {}
	local index = 1

	local function newLine()
		index = index + 1
	end

	local function setLine(line)
		lines[index] = line
	end

	local function appendLine(word)
		local line = lines[index]

		if ( line ) then
			return line.." "..word
		else
			return word
		end
	end

	surface.SetFont(font)
	local charW = surface.GetTextSize("A")

	for _, w in pairs(words) do
		local futureLine = appendLine(w)

		if ( surface.GetTextSize(futureLine) > wLimit ) then
			if ( surface.GetTextSize(w) < w ) then
				setLine(futureLine)
			else
				for i = string.len( w ), 1, -1 do
					--local piece = 
				end

			end
		end

		lastWord = v
	end
end