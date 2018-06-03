function SCHEMA:LoadFonts(font)
    surface.CreateFont("LargeText54",{
	    font = "Arial",
	    size = 54,
	    antialias = true,
	    blursize = 0,
	    scanlines = 0,
	    weight = 200
    })

    surface.CreateFont("ColaborateL12",{
    	font = "ColaborateLight",
	    size = 12,
    	antialias = true,
	    blursize = 0,
    	scanlines = 0,
    	weight = 200
    })

    surface.CreateFont("ColaborateL16",{
	    font = "ColaborateLight",
	    size = 16,
	    antialias = true,
    	blursize = 0,
    	scanlines = 0,
    	weight = 200
    })

    surface.CreateFont("ColaborateL24",{
    	font = "ColaborateLight",
	    size = 24,
    	antialias = true,
    	blursize = 0,
    	scanlines = 0,
	    weight = 200
    })

    surface.CreateFont("ColaborateL36",{
	    font = "ColaborateLight",
	    size = 36,
	    antialias = true,
	    blursize = 0,
	    scanlines = 0,
	    weight = 200
    })

    surface.CreateFont( "FOFont_big",{
	    font = "Impact",
	    size = 45,
	    weight = 400,
	    underline = 0,
	    additive = false,
	    outline = false,
	    blursize = 1
    })

    surface.CreateFont( "FOFont_normal",{
	    font = "Impact",
	    size = 25,
	    weight = 400,
	    underline = 0,
	    additive = false,
    	outline = false,
	    blursize = 1
    })

    surface.CreateFont("FOFont_big_blur",{
    	font = "Impact",
	    size = 45,
	    weight = 400,
	    underline = 0,
	    additive = false,
	    outline = false,
	    blursize = 1
    })

    surface.CreateFont("FOFont_normal_blur",{
    	font = "Impact",
    	size = 25,
    	weight = 400,
    	underline = 0,
    	additive = false,
    	outline = false,
    	blursize = 1
    })

    surface.CreateFont("forp_ChatFontWhisper", {
    	font = "ChatFont",
    	size = 14,
    	weight = 1600,
    	italic = false
    })

    surface.CreateFont("forp_ChatFontActionClose", {
    	font = "ChatFont",
    	size = 14,
    	weight = 1600,
    	italic = true
    })

    surface.CreateFont("forp_ChatFontAction", {
    	font = "ChatFont",
    	size = 20,
    	weight = 1600,
    	italic = true
    })

    surface.CreateFont("forp_ChatFontActionLong", {
    	font = "ChatFont",
    	size = 26,
    	weight = 1600,
    	italic = true
    })

    surface.CreateFont("forp_ChatFontYell", {
    	font = "ChatFont",
    	size = 26,
    	weight = 1600,
    	italic = false
    })

    surface.CreateFont("forp_ChatFontEvent", {
    	font = "ChatFont",
    	size = 22,
    	weight = 1600,
    	italic = true
    })

    surface.CreateFont("nut_MenuButtonFont", {
	    font = "ChatFont",
	    size = 24,
	    weight = 800
    })

    surface.CreateFont("nut_newchatfont", {
    	font = "ChatFont",
    	size = 18,
    	weight = 1200
    })

    surface.CreateFont("nut_menufont", {
    	font = "ChatFont",
    	size = 14,
    	weight = 500
    })

    surface.CreateFont("Monofonto18", {
	    font = "Monofonto",
	    size = 18,
	    weight = 300
    })

    surface.CreateFont("Monofonto24", {
    	font = "Monofonto",
    	size = 24,
    	weight = 500
    })
	
    surface.CreateFont("Monofonto24_blur", {
    	font = "Monofonto",
    	size = 24,
    	weight = 400,
    	underline = 0,
    	additive = false,
    	outline = false,
	    blursize = 1
    })

    surface.CreateFont("Monofonto32", {
    	font = "Monofonto",
    	size = 32
    })

    surface.CreateFont("Monofonto24CC", {
	    font = "Monofonto",
	    size = 24,	
	    weight = 0,
	
    })

    surface.CreateFont("Monofonto36", {
    	font = "Monofonto",
    	size = 36,	
    	--weight = 500,
    	--shadow = true
    })

	surface.CreateFont("MonofontoTitle", {
    	font = "Monofonto",
    	size = 64,	
    	weight = 500,
    	--shadow = true
    })

	surface.CreateFont("MonofontoSubtitle", {
    	font = "Monofonto",
    	size = 34,	
    	weight = 500,
    	--shadow = true
    })

    surface.CreateFont("FranKleinBold", {
    	font = "FranKleinBold",
    	size = 32,	
    	weight = 500,
    	--shadow = true
    })

    surface.CreateFont("Monofonto20CC", {
    	font = "Monofonto",
    	size = 20,	
    	weight = 0,
	
    })

    surface.CreateFont("Monofonto30CC", {
    	font = "Monofonto",
      	size = 30,	
    	weight = 0,
	
    })
end