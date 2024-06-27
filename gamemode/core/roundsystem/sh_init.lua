ROUND_STATE_WAIT = 0
ROUND_STATE_PREP = 1
ROUND_STATE_ACTIVE = 2
ROUND_STATE_END = 3

ag.round = ag.round or {}

function ag.round.GetState()
    return GetGlobalInt("ag.round.Time", 0)
end

function ag.round.GetTime()
    return GetGlobalFloat("ag.round.Time", 0)
end

-- local function isEnoughPlayers()
--     local players = ag.util.GetPlayers(PLAYER_TYPE_READY)
--     return #players >= ag.config.MinimumPlayersToStart
-- end

local folder = GM.RootFolder .. "/core/roundsystem"

tll.Load(folder .. "/sv_init.lua")
tll.Load(folder .. "/cl_init.lua")
tll.Load(folder .. "/sh_meta.lua")
