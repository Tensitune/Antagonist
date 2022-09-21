function Antagonist.GetNickSortedPlayers()
    local players = player.GetAll()
    table.sort(players, function(a,b) return a:Nick() < b:Nick() end)

    return players
end
