local function registerChatCommand(commandName, callback, privilegeName)
    local commands = ag.chat.GetCommands()
    commands[commandName] = commands[commandName] or {}
    commands[commandName].name = commands[commandName].name or commandName
    commands[commandName].restriction = privilegeName
    commands[commandName].callback = callback
end

function ag.chat.RegisterCommand(commandName, callback, privilegeName)
    local cmd = string.lower(commandName)

    local detour = function(ply, arg, ...)
        local canUseCommand = gamemode.Call("CanUseChatCommand", ply, cmd)
        if !canUseCommand then return "" end

        local ret = {callback(ply, arg, ...)}
        return unpack(ret)
    end

    registerChatCommand(cmd, detour, privilegeName)
end

--[[---------------------------------------------------------------------------
Chat commands
---------------------------------------------------------------------------]]
local function yellChatCommand(ply, args, text)
    if text == "" then
        ag.util.Notify(ply, NOTIFY_ERROR, 3, ag.lang.GetPhrase("invalid_args"))
        return
    end

    local phrase = ag.lang.GetPhrase("yells")
    ag.chat.TalkToRange(ag.config.yellDistance, ply, nil, (" %s, \"%s\""):format(phrase, text))
end
ag.chat.RegisterCommand("y", yellChatCommand)

local function whisperChatCommand(ply, args, text)
    if text == "" then
        ag.util.Notify(ply, NOTIFY_ERROR, 3, ag.lang.GetPhrase("invalid_args"))
        return
    end

    local phrase = ag.lang.GetPhrase("whispers")
    ag.chat.TalkToRange(ag.config.whisperDistance, ply, nil, (" %s, \"%s\""):format(phrase, text))
end
ag.chat.RegisterCommand("w", whisperChatCommand)

local function meChatCommand(ply, args, text)
    if text == "" then
        ag.util.Notify(ply, NOTIFY_ERROR, 3, ag.lang.GetPhrase("invalid_args"))
        return
    end

    ag.chat.TalkToRange(ag.config.talkDistance, ply, ply:Nick() .. " " .. text)
end
ag.chat.RegisterCommand("me", meChatCommand)

local function oocChatCommand(ply, args, text)
    if !ag.config.ooc then
        ag.util.Notify(ply, NOTIFY_ERROR, 3, ag.lang.GetPhrase("disabled_ooc"))
        return
    end

    if text == "" then
        ag.util.Notify(ply, NOTIFY_ERROR, 3, ag.lang.GetPhrase("invalid_args"))
        return
    end

    local nick = ply:Nick()
    local players = player.GetHumans()

    text = ": " .. text
    nick = "(OOC) " .. nick

    for i = 1, #players do
        local recipient = players[i]
        ag.chat.TalkToPerson(ply, recipient, nick, text)
    end
end
ag.chat.RegisterCommand("ooc", oocChatCommand)

local function loocChatCommand(ply, args, text)
    if text == "" then
        ag.util.Notify(ply, NOTIFY_ERROR, 3, ag.lang.GetPhrase("invalid_args"))
        return
    end

    ag.chat.TalkToRange(ag.config.talkDistance, ply, "(Local OOC) " .. ply:Nick(), ": " .. text)
end
ag.chat.RegisterCommand("looc", loocChatCommand)

local function flipChatCommand(ply, args, text)
    local coinSide = math.random(2) == 1 and ag.lang.GetPhrase("coin_heads")
                        or ag.lang.GetPhrase("coin_tails")
    local phrase = ag.lang.GetPhrase("action_flip", coinSide)

    ag.chat.TalkToRange(ag.config.talkDistance, ply, ply:Nick() .. " " .. phrase)
end
ag.chat.RegisterCommand("flip", flipChatCommand)
