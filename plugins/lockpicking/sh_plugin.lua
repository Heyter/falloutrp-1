PLUGIN.name = "Lockpicking"
PLUGIN.author = "Cat.jpeg"
PLUGIN.desc = "Allows to pick locks with bobbypins"

-- Config
PLUGIN.UnlockMaxAngle = -90
PLUGIN.HardMaxAngle = -30
PLUGIN.TurningSpeed = 90
PLUGIN.ReleasingSpeed = 200
PLUGIN.FadeTime = 0.4
PLUGIN.SpamTime = 0.1
PLUGIN.MaxLookDistance = 25

nut.util.include("sv_session.lua")
nut.util.include("sh_freeze.lua")
nut.util.include("cl_interface.lua")