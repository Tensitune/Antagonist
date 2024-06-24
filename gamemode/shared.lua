GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"
GM.RootFolder = GM.FolderName .. "/gamemode"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

ag = ag or { util = {} }

if SERVER then
    AddCSLuaFile("libraries/tll.lua")
end
include("libraries/tll.lua")

tll.Load(GM.RootFolder .. "/libraries/sh_cami.lua")
tll.Load(GM.RootFolder .. "/libraries/notifications.lua")

tll.Load(GM.RootFolder .. "/config/config.lua")
tll.Load(GM.RootFolder .. "/config/fonts.lua", "CLIENT")

tll.Load(GM.RootFolder .. "/core/sh_core.lua")

tll.Load(GM.RootFolder .. "/core/hooks/sv_hooks.lua")

tll.Load(GM.RootFolder .. "/core/network/sh_actions.lua")
tll.Load(GM.RootFolder .. "/core/network/sv_actions.lua")

tll.Load(GM.RootFolder .. "/core/player/sh_util.lua")
tll.Load(GM.RootFolder .. "/core/player/sh_meta.lua")
tll.Load(GM.RootFolder .. "/core/player/sv_hooks.lua")

tll.Load(GM.RootFolder .. "/core/language/sh_language.lua")

tll.Load(GM.RootFolder .. "/core/chat/sv_chat.lua")
tll.Load(GM.RootFolder .. "/core/chat/sv_util.lua")
tll.Load(GM.RootFolder .. "/core/chat/sh_commands.lua")
tll.Load(GM.RootFolder .. "/core/chat/sv_commands.lua")
tll.Load(GM.RootFolder .. "/core/chat/cl_chat.lua")

tll.Load(GM.RootFolder .. "/core/voice/sv_voice.lua")
tll.Load(GM.RootFolder .. "/core/voice/cl_voice.lua")

tll.Load(GM.RootFolder .. "/core/inventory/sh_inventory.lua")
tll.Load(GM.RootFolder .. "/core/inventory/sv_inventory.lua")
tll.Load(GM.RootFolder .. "/core/inventory/cl_inventory.lua")
tll.Load(GM.RootFolder .. "/core/inventory/sv_player_ext.lua")

tll.Load(GM.RootFolder .. "/core/roles/sh_roles.lua")
tll.Load(GM.RootFolder .. "/core/roles/sv_roles.lua")
tll.Load(GM.RootFolder .. "/core/roles/sh_player_ext.lua")

tll.Load(GM.RootFolder .. "/core/ui/sh_ui.lua")

tll.Load(GM.RootFolder .. "/config/roles.lua")
