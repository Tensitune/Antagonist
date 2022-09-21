--[[-------------------------------------------------------------------------
Antagonist config settings.
-----------------------------------------------------------------------------]]
-- Acts/Taunts - Enable/disable Taunts (e.g. act salute)
GM.Config.AllowActs = false
-- DropWeaponDeath - Enable/disable whether people drop their current weapon when they die.
GM.Config.DropWeaponDeath = true
-- PropCrafting - Whether or not players should use resources for spawning props.
GM.Config.PropCrafting = true
-- PropSpawning - Enable/disable props spawning. Applies to admins too.
GM.Config.PropSpawning = true

--[[---------------------------------------------------------------------------
Voice settings
---------------------------------------------------------------------------]]
-- Voice3D - Enable/disable 3DVoice is enabled.
GM.Config.Voice3D = true
-- VoiceRadius - Enable/disable local voice chat.
GM.Config.VoiceRadius = true
-- DynamicVoice - Enable/disable whether only people in the same room as you can hear your mic.
GM.Config.DynamicVoice = true
-- DeadVoice - Enable/disable whether people talk through the microphone while dead.
GM.Config.DeadVoice = true

--[[---------------------------------------------------------------------------
Chat distance settings
Distance is in source units (similar to inches)
---------------------------------------------------------------------------]]
GM.Config.VoiceDistance = 550

-- Put Steam ID's and ranks in this list, and the players will have that rank when they join.
GM.Config.DefaultPlayerGroups = {
    ["STEAM_0:0:00000000"] = "superadmin",
    ["STEAM_0:0:11111111"] = "admin",
}

--[[---------------------------------------------------------------------------
Other settings
---------------------------------------------------------------------------]]
GM.Config.AllowedProperties = {
    remover = false,
    ignite = false,
    extinguish = false,
    keepupright = false,
    gravity = false,
    collision = false,
    skin = true,
    bodygroups = true,
}

GM.Config.DisallowDrop = {
    ["gmod_camera"] = true,
    ["gmod_tool"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_physgun"] = true,
}
