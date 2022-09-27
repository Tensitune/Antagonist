--[[-------------------------------------------------------------------------
Antagonist config settings.
-----------------------------------------------------------------------------]]
-- Acts/Taunts - Enable/disable Taunts (e.g. act salute)
GM.Config.AllowActs = false
-- AllowSprays - Enable/disable the use of sprays on the server.
GM.Config.AllowSprays = true
-- DropWeaponDeath - Enable/disable whether people drop their current weapon when they die.
GM.Config.DropWeaponDeath = true
-- OOC - Enable/disable OOC global chat.
GM.Config.OOC = true
-- PropCrafting - Whether or not players should use resources for spawning props.
GM.Config.PropCrafting = true
-- PropSpawning - Enable/disable props spawning. Applies to admins too.
GM.Config.PropSpawning = true
-- RealisticFallDamage - Enable/Disable dynamic fall damage. Setting mp_falldamage to 1 will over-ride this.
GM.Config.RealisticFallDamage = true

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
Value settings
---------------------------------------------------------------------------]]
-- FallDamageDamper - The damper on realistic fall damage. Default is 15. Decrease this for more damage.
GM.Config.FallDamageDamper = 15
-- FallDamageAmount - The base damage taken from falling for static fall damage. Default is 10.
GM.Config.FallDamageAmount = 10

--[[---------------------------------------------------------------------------
Chat distance settings
Distance is in source units (similar to inches)
---------------------------------------------------------------------------]]
GM.Config.VoiceDistance = 550
GM.Config.TalkDistance = 250
GM.Config.MeDistance = 250

--[[---------------------------------------------------------------------------
Other settings
---------------------------------------------------------------------------]]
GM.Config.ChatCommandPrefix = "/"

-- Properties set to true are allowed to be used. Values set to false or are missing from this list are blocked.
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

-- Put Steam ID's and ranks in this list, and the players will have that rank when they join.
GM.Config.DefaultPlayerGroups = {
    ["STEAM_0:0:00000000"] = "superadmin",
    ["STEAM_0:0:11111111"] = "admin",
}

-- The list of weapons that players are not allowed to drop. Items set to true are not allowed to be dropped.
GM.Config.DisallowDrop = {
    ["gmod_camera"] = true,
    ["gmod_tool"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_physgun"] = true,
}
