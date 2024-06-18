function ag.util.GetNickSortedPlayers()
    local players = player.GetAll()
    table.sort(players, function(a, b) return a:Nick() < b:Nick() end)

    return players
end

function ag.util.GetAlivePlayers()
    local players = player.GetAll()
    local alivePlayers = {}

    for i = 1, #players do
        local ply = players[i]
        if !IsValid(ply) or !ply:Alive() or ply:IsSpectator() then continue end
        alivePlayers[#alivePlayers + 1] = ply
    end

    return alivePlayers
end

function ag.util.PlayerNearEntity(ply, entity, radius)
    local playerFound = false
    local nearbyEntities = ents.FindInSphere(entity:GetPos(), radius)

    for i = 1, #nearbyEntities do
        local ent = nearbyEntities[i]
        if ent == ply then
            playerFound = true
            break
        end
    end

    return playerFound
end
