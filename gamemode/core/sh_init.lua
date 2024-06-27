local folder = GM.RootFolder .. "/core"

tll.Load(folder .. "/sh_language.lua")
tll.Load(folder .. "/sh_meta.lua")
tll.Load(folder .. "/sh_utils.lua")

tll.Load(folder .. "/hooks/sh_init.lua")
tll.Load(folder .. "/chat/sh_init.lua")
tll.Load(folder .. "/voice/sh_init.lua")
tll.Load(folder .. "/inventory/sh_init.lua")
tll.Load(folder .. "/roles/sh_init.lua")
tll.Load(folder .. "/roundsystem/sh_init.lua")
tll.Load(folder .. "/ui/sh_init.lua")
tll.LoadFiles(folder .. "/hud")
