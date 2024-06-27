ag.round.AlreadyPlayed = ag.round.AlreadyPlayed or {}

util.AddNetworkString("ag.round.Ready")

function ag.round.SetState()
    SetGlobalInt("ag.round.State", state)
end

function ag.round.SetTime(time)
    SetGlobalFloat("ag.round.Time", time)
end

function GM:EndRound()
    ag.round.AlreadyPlayed = {}
    ag.round.SetTime(0)
end

timer.Create("ag.round.Time", 1, 0, function()
    if ag.round.GetState() == ROUND_STATE_ACTIVE then
        ag.round.SetTime(ag.round.GetTime() + 1)
    end
end)

net.Receive("ag.round.Ready", function(_, ply)
    if ag.round.GetState() == ROUND_STATE_ACTIVE then
        ply:SetNWBool("IsReady", true)
    else
        ply:SetNWBool("IsReady", not ply:GetNWBool("IsReady", false))
    end
end)
