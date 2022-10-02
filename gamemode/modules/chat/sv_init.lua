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

        local ret = {callback(ply, arg, ...)}
        return unpack(ret)
    end

    registerChatCommand(cmd, detour, privilegeName)
end

function GM:CanUseChatCommand(ply, commandName)
    local cmd = Antagonist.GetChatCommand(commandName)

    if !cmd then
        Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "cmd_not_found"))
        return false, nil
    end

    if cmd.condition != nil and !condition then
        Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "cant_use_cmd"))
        return false, nil
    end

    if cmd.restriction then
        local canUseCommand = false

        CAMI.PlayerHasAccess(ply, cmd.restriction, function(hasAccess, _)
            canUseCommand = hasAccess
        end)

        if !canUseCommand then
            Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "no_privilege"))
            return false, nil
        end
    end

    return true, cmd
end

function GM:PlayerSay(ply, text, teamChat)
    text = string.Trim(text)

    if string.sub(text, 1, 1) == self.Config.ChatCommandPrefix then
        local commandStuff = string.Explode(" ", text)
        local commandName = string.sub(commandStuff[1], 2)

        local canUse, cmd = self:CanUseChatCommand(ply, commandName)
        if !canUse then return "" end

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

    local chatTypeStr = text:Right(1) == "?" and Antagonist.GetPhrase(ply.Language, "asks")
                        or text:Right(1) == "!" and Antagonist.GetPhrase(ply.Language, "exclaims")
                            or Antagonist.GetPhrase(ply.Language, "says")

    Antagonist.TalkToRange(self.Config.TalkDistance, ply, nil, (" %s, \"%s\""):format(chatTypeStr, text))
    return ""
end
