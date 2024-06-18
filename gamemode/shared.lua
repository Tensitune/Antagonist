GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"
GM.RootFolder = GM.FolderName .. "/gamemode"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

ag = ag or { util = {} }

function ag.util.Load(side, path)
    local lowerSide = string.lower(side)

    if lowerSide == "server" and SERVER then
        include(path)
    elseif lowerSide == "client" then
        if SERVER then AddCSLuaFile(path) end
        if CLIENT then include(path) end
    elseif lowerSide == "shared" then
        if SERVER then AddCSLuaFile(path) end
        include(path)
    end
end

ag.util.Load("SHARED", "libraries/sh_cami.lua")
ag.util.Load("SHARED", "libraries/tll.lua")
ag.util.Load("SHARED", "libraries/notifications.lua")

ag.util.Load("SHARED", "config/config.lua")
ag.util.Load("CLIENT", "config/fonts.lua")

ag.util.Load("SHARED", "core/sh_core.lua")

ag.util.Load("SERVER", "core/hooks/sv_hooks.lua")

ag.util.Load("SHARED", "core/network/sh_actions.lua")
ag.util.Load("SERVER", "core/network/sv_actions.lua")

ag.util.Load("SHARED", "core/player/sh_util.lua")
ag.util.Load("SHARED", "core/player/sh_meta.lua")
ag.util.Load("SHARED", "core/player/sv_hooks.lua")

ag.util.Load("SHARED", "core/language/sh_language.lua")

ag.util.Load("SERVER", "core/chat/sv_chat.lua")
ag.util.Load("SERVER", "core/chat/sv_util.lua")
ag.util.Load("SHARED", "core/chat/sh_commands.lua")
ag.util.Load("SERVER", "core/chat/sv_commands.lua")
ag.util.Load("CLIENT", "core/chat/cl_chat.lua")

ag.util.Load("SERVER", "core/voice/sv_voice.lua")
ag.util.Load("CLIENT", "core/voice/cl_voice.lua")

ag.util.Load("SHARED", "core/inventory/sh_inventory.lua")
ag.util.Load("SERVER", "core/inventory/sv_inventory.lua")
ag.util.Load("CLIENT", "core/inventory/cl_inventory.lua")
ag.util.Load("SERVER", "core/inventory/sv_player_ext.lua")

ag.util.Load("SHARED", "core/roles/sh_roles.lua")
ag.util.Load("SERVER", "core/roles/sv_roles.lua")
ag.util.Load("SHARED", "core/roles/sh_player_ext.lua")

ag.util.Load("SHARED", "core/ui/sh_ui.lua")

ag.util.Load("CLIENT", "core/ui/hud/cl_hud.lua")
ag.util.Load("CLIENT", "core/ui/hud/cl_chat_listeners.lua")
ag.util.Load("CLIENT", "core/ui/hud/cl_player.lua")

ag.util.Load("CLIENT", "core/ui/vgui/button.lua")
ag.util.Load("CLIENT", "core/ui/vgui/bubble_button.lua")
ag.util.Load("CLIENT", "core/ui/vgui/inventory_button.lua")
ag.util.Load("CLIENT", "core/ui/vgui/frame.lua")
ag.util.Load("CLIENT", "core/ui/vgui/radial_menu.lua")
ag.util.Load("CLIENT", "core/ui/vgui/inventory_menu.lua")

ag.util.Load("SHARED", "config/roles.lua")
