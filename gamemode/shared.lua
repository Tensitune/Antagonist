GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"
GM.RootFolder = GM.FolderName .. "/gamemode"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass
GM.Config = GM.Config or {}

Antagonist = Antagonist or {}

function Antagonist.Load(side, path)
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

Antagonist.Load("SHARED", "libraries/sh_cami.lua")
Antagonist.Load("SHARED", "libraries/tll.lua")

Antagonist.Load("SHARED", "config/config.lua")
Antagonist.Load("CLIENT", "config/fonts.lua")

Antagonist.Load("SERVER", "core/libs/sv_notify.lua")
Antagonist.Load("SHARED", "core/libs/sh_players.lua")
Antagonist.Load("SHARED", "core/libs/sh_util.lua")
Antagonist.Load("CLIENT", "core/libs/cl_notify.lua")

Antagonist.Load("SERVER", "core/hooks/sv_hooks.lua")
Antagonist.Load("SERVER", "core/hooks/sv_player.lua")

Antagonist.Load("SHARED", "core/language/sh_language.lua")
Antagonist.Load("SERVER", "core/language/sv_language.lua")
Antagonist.Load("CLIENT", "core/language/cl_language.lua")

Antagonist.Load("SERVER", "core/chat/sv_chat.lua")
Antagonist.Load("SERVER", "core/chat/sv_util.lua")
Antagonist.Load("SHARED", "core/chat/sh_commands.lua")
Antagonist.Load("SERVER", "core/chat/sv_commands.lua")
Antagonist.Load("CLIENT", "core/chat/cl_chat.lua")

Antagonist.Load("SERVER", "core/voice/sv_voice.lua")
Antagonist.Load("CLIENT", "core/voice/cl_voice.lua")

Antagonist.Load("SHARED", "core/roles/sh_roles.lua")
Antagonist.Load("SERVER", "core/roles/sv_roles.lua")
Antagonist.Load("SHARED", "core/roles/sh_player_ext.lua")

Antagonist.Load("CLIENT", "core/hud/cl_chat_listeners.lua")
Antagonist.Load("CLIENT", "core/hud/cl_player.lua")

Antagonist.Load("SHARED", "config/roles.lua")
