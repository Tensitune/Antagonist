function Antagonist.GetNickSortedPlayers()
    local players = player.GetAll()
    table.sort(players, function(a, b) return a:Nick() < b:Nick() end)

    return players
end

function Antagonist.GetAlivePlayers()
    local players = player.GetAll()
    local alivePlayers = {}

    for i = 1, #players do
        local ply = players[i]
        if !IsValid(ply) or !ply:Alive() or ply:IsSpectator() then continue end
        alivePlayers[#alivePlayers + 1] = ply
    end

    return alivePlayers
end
