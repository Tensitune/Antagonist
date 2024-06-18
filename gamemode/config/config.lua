ag.config = ag.config or {}

--[[-------------------------------------------------------------------------
Antagonist config settings.
-----------------------------------------------------------------------------]]
ag.config.language = "russian"

--[[---------------------------------------------------------------------------
General settings
---------------------------------------------------------------------------]]
-- Acts/Taunts - Enable/disable Taunts (e.g. act salute)
ag.config.allowActs = false
-- AllowSprays - Enable/disable the use of sprays on the server.
ag.config.allowSprays = true
-- DropWeaponDeath - Enable/disable whether people drop their current weapon when they die.
ag.config.dropWeaponDeath = true
-- OOC - Enable/disable OOC global chat.
ag.config.ooc = true
-- PropCrafting - Whether or not players should use resources for spawning props.
ag.config.propCrafting = true
-- PropSpawning - Enable/disable props spawning. Applies to admins too.
ag.config.propSpawning = true
-- RealisticFallDamage - Enable/Disable dynamic fall damage. Setting mp_falldamage to 1 will over-ride this.
ag.config.realisticFallDamage = true

--[[---------------------------------------------------------------------------
Voice settings
---------------------------------------------------------------------------]]
-- Voice3D - Enable/disable 3DVoice is enabled.
ag.config.voice3D = true
-- VoiceRadius - Enable/disable local voice chat.
ag.config.voiceRadius = true
-- DynamicVoice - Enable/disable whether only people in the same room as you can hear your mic.
ag.config.dynamicVoice = true
-- DeadVoice - Enable/disable whether people talk through the microphone while dead.
ag.config.deadVoice = true

--[[---------------------------------------------------------------------------
Value settings
---------------------------------------------------------------------------]]
-- FallDamageDamper - The damper on realistic fall damage. Default is 15. Decrease this for more damage.
ag.config.fallDamageDamper = 15
-- FallDamageAmount - The base damage taken from falling for static fall damage. Default is 10.
ag.config.fallDamageAmount = 10

--[[---------------------------------------------------------------------------
Chat distance settings
Distance is in source units (similar to inches)
---------------------------------------------------------------------------]]
ag.config.voiceDistance = 550
ag.config.talkDistance = 250
ag.config.yellDistance = 550
ag.config.whisperDistance = 90

--[[---------------------------------------------------------------------------
Other settings
---------------------------------------------------------------------------]]
ag.config.chatCommandPrefix = "/"

-- Properties set to true are allowed to be used. Values set to false or are missing from this list are blocked.
ag.config.allowedProperties = {
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
ag.config.defaultPlayerGroups = {
    ["STEAM_0:0:00000000"] = "superadmin",
    ["STEAM_0:0:11111111"] = "admin",
}
