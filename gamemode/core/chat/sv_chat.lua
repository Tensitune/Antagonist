util.AddNetworkString("ag.Chat")

local stringSub = string.sub
local function explodeArgs(args)
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

function GM:CanUseChatCommand(ply, commandName)
    local cmd = ag.chat.GetCommand(commandName)

    if !cmd then
        al.util.Notify(ply, NOTIFY_ERROR, 5, ag.lang.GetPhrase("cmd_not_found"))
        return false, nil
    end

    if cmd.condition != nil and !condition then
        al.util.Notify(ply, NOTIFY_ERROR, 5, ag.lang.GetPhrase("cant_use_cmd"))
        return false, nil
    end

    if cmd.restriction then
        local canUseCommand = false

        CAMI.PlayerHasAccess(ply, cmd.restriction, function(hasAccess, _)
            canUseCommand = hasAccess
        end)

        if !canUseCommand then
            al.util.Notify(ply, NOTIFY_ERROR, 5, ag.lang.GetPhrase("no_privilege"))
            return false, nil
        end
    end

    return true, cmd
end

function GM:PlayerSay(ply, text, teamChat)
    text = string.Trim(text)

    if string.sub(text, 1, 1) == ag.config.chatCommandPrefix then
        local commandStuff = string.Explode(" ", text)
        local commandName = string.sub(commandStuff[1], 2)

        local canUse, cmd = self:CanUseChatCommand(ply, commandName)
        if !canUse then return "" end

        if cmd.delay and ply.commandDelays[cmd.name] and ply.commandDelays[cmd.name] > CurTime() - cmd.delay then
            return ""
        elseif cmd.delay then
            ply.commandDelays[cmd.name] = CurTime()
        end

        local args = string.sub(text, #cmd.name + 3)
        local cbText = args
        args = cmd.arguments and explodeArgs(args) or args

        cmd.callback(ply, args, cbText)
        return ""
    end

    local isYelling = text:Right(111) == "!!!"
    local distance = isYelling and ag.config.yellDistance or ag.config.talkDistance
    local chatTypeStr = isYelling and ag.lang.GetPhrase("yells")
                            or text:Right(1) == "?" and ag.lang.GetPhrase("asks")
                            or text:Right(1) == "!" and ag.lang.GetPhrase("exclaims")
                            or ag.lang.GetPhrase("says")

    ag.chat.TalkToRange(distance, ply, nil, (" %s, \"%s\""):format(chatTypeStr, text))
    return ""
end
