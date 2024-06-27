local folder = GM.RootFolder .. "/core/ui"

tll.Load(folder .. "/sv_init.lua")
tll.Load(folder .. "/cl_init.lua")

tll.LoadFiles(folder .. "/vgui", "CLIENT")
tll.LoadFiles(folder .. "/notifications")
