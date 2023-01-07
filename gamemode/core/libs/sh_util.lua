local stringSub = string.sub
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

            args[#args + 1] = stringSub(arg, from + diff, to - 1 - diff)
            from = to + 1
        end
    end

    diff = wasQuotes and 1 or 0

    if from != to + 1 then
        args[#args + 1] = stringSub(arg, from + diff, to + 1 - bit.lshift(diff, 1))
    end

    return args
end
