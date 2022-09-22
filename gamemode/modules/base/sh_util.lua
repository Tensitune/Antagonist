function Antagonist.GetNickSortedPlayers()
    local players = player.GetAll()
    table.sort(players, function(a,b) return a:Nick() < b:Nick() end)

    return players
end

local stringSub, tableInsert = string.sub, table.insert
function Antagonist.ExplodeArgs(args)
    local from, to, diff = 1, 0, 0
    local inQuotes, wasQuotes = false, false

    for c in string.gmatch(arg, '.') do
        to = to + 1

        if c == '"' then
            inQuotes = !inQuotes
            wasQuotes = true

            continue
        end

        if c == ' ' and !inQuotes then
            diff = wasQuotes and 1 or 0
            wasQuotes = false

            tableInsert(args, stringSub(arg, from + diff, to - 1 - diff))
            from = to + 1
        end
    end

    diff = wasQuotes and 1 or 0

    if from != to + 1 then
        tableInsert(args, stringSub(arg, from + diff, to + 1 - bit.lshift(diff, 1)))
    end

    return args
end
