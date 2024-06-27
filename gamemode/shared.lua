GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"
GM.RootFolder = GM.FolderName .. "/gamemode"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

ag = ag or {}

if SERVER then
    AddCSLuaFile("libraries/tll.lua")
end
include("libraries/tll.lua")

tll.Load(GM.RootFolder .. "/libraries/tgui.lua", "CLIENT")
tll.Load(GM.RootFolder .. "/libraries/sh_cami.lua")

tll.Load(GM.RootFolder .. "/config/config.lua")
tll.Load(GM.RootFolder .. "/config/fonts.lua", "CLIENT")

tll.Load(GM.RootFolder .. "/core/sh_init.lua")

tll.Load(GM.RootFolder .. "/config/roles.lua")
