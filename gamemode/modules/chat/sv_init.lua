util.AddNetworkString("Antagonist.Chat")

local function registerChatCommand(commandName, callback, privilegeName)
    local commands = Antagonist.GetChatCommands()
    commands[commandName] = commands[commandName] or {}
    commands[commandName].name = commands[commandName].name or commandName
    commands[commandName].restriction = privilegeName
    commands[commandName].callback = callback
end

function Antagonist.RegisterChatCommand(commandName, callback, privilegeName)
    local cmd = string.lower(commandName)

    local detour = function(ply, arg, ...)
        local canUseCommand = gamemode.Call("CanUseChatCommand", ply, cmd)
        if !canUseCommand then return "" end

        local ret = { callback(ply, arg, ...) }
        return unpack(ret)
    end

    registerChatCommand(cmd, detour, privilegeName)
end

function GM:CanUseChatCommand(ply, commandName)
    local cmd = Antagonist.GetChatCommand(commandName)

    if !cmd then
        Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase("cmdNotFound"))
        return false
    end

    if cmd.restriction then
        local canUseCommand = false

        CAMI.PlayerHasAccess(ply, cmd.restriction, function(hasAccess, _)
            canUseCommand = hasAccess
        end)

        if !canUseCommand then
            Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase("noPrivilege"))
            return false
        end
    end

    return true
end

function GM:PlayerSay(ply, text, teamChat)
    if string.sub(text, 1, 1) == Antagonist.Config.ChatCommandPrefix then
        local commandStuff = string.Explode(" ", text)
        local commandName = string.sub(commandStuff[1], 2)

        local cmd = Antagonist.GetChatCommand(commandName)
        if cmd then
            if cmd.delay and ply.CommandDelays[cmd.name] and ply.CommandDelays[cmd.name] > CurTime() - cmd.delay then
                return ""
            elseif cmd.delay then
                ply.CommandDelays[cmd.name] = CurTime()
            end

            local args = string.sub(text, #cmd.name + 3)
            local cbText = args

            args = cmd.arguments and Antagonist.ExplodeArgs(args) or args

            cmd.callback(ply, args, cbText)
            return ""
        end
    end

    Antagonist.TalkToRange(Antagonist.Config.TalkDistance, nil, ply, text)
    return ""
end
