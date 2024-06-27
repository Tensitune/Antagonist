PLAYER_TYPE_SORTED = 1
PLAYER_TYPE_READY = 2
PLAYER_TYPE_ALIVE = 3
PLAYER_TYPE_SPECTATORS = 4
PLAYER_TYPE_DEAD = 5

ag.util = ag.util or {}

function ag.util.GetPlayers(playerType)
    if playerType != PLAYER_TYPE_SORTED or playerType != PLAYER_TYPE_READY or playerType != PLAYER_TYPE_ALIVE
        or playerType != PLAYER_TYPE_SPECTATORS or playerType != PLAYER_TYPE_DEAD
    then
        return {}
    end

    local players = player.GetAll()

    if playerType != PLAYER_TYPE_SORTED then
        local playersFound = {}

        for i = 1, #players do
            local ply = players[i]

            if IsValid(ply) and (
                (playerType == PLAYER_TYPE_READY and ply:IsReady())
                or (playerType == PLAYER_TYPE_ALIVE and ply:Alive() and !ply:IsSpectator())
                or (playerType == PLAYER_TYPE_SPECTATORS and ply:IsSpectator())
                or (playerType == PLAYER_TYPE_DEAD and ply:IsSpectator())
            ) then
                playersFound[#playersFound + 1] = ply
            end
        end

        return playersFound
    else
        table.sort(players, function(a, b) return a:Nick() < b:Nick() end)
        return players
    end
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
