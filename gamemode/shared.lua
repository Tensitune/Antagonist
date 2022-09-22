GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass
GM.Config = GM.Config or {}

Antagonist = Antagonist or {}

include("libraries/sh_cami.lua")
include("config/config.lua")
include("sh_util.lua")
