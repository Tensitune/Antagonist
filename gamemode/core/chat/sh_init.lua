ag.chat = ag.chat or {}

local folder = GM.RootFolder .. "/core/chat"

tll.Load(folder .. "/sv_init.lua")
tll.Load(folder .. "/cl_init.lua")
tll.Load(folder .. "/sh_commands.lua")
tll.Load(folder .. "/sv_commands.lua")
tll.Load(folder .. "/cl_listeners.lua")
