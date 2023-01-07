local function yellChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    local phrase = Antagonist.GetPhrase(ply.Language, "yells")
    Antagonist.TalkToRange(GAMEMODE.Config.YellDistance, ply, nil, (" %s, \"%s\""):format(phrase, text))
end
Antagonist.RegisterChatCommand("y", yellChatCommand)

local function whisperChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    local phrase = Antagonist.GetPhrase(ply.Language, "whispers")
    Antagonist.TalkToRange(GAMEMODE.Config.WhisperDistance, ply, nil, (" %s, \"%s\""):format(phrase, text))
end
Antagonist.RegisterChatCommand("w", whisperChatCommand)

local function meChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    Antagonist.TalkToRange(GAMEMODE.Config.MeDistance, ply, ply:Nick() .. " " .. text)
end
Antagonist.RegisterChatCommand("me", meChatCommand)

local function oocChatCommand(ply, args, text)
    if !GAMEMODE.Config.OOC then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "disabled_ooc"))
        return
    end

    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    local nick = ply:Nick()
    local players = player.GetHumans()

    text = ": " .. text
    nick = "(OOC) " .. nick

    for i = 1, #players do
        local recipient = players[i]
        Antagonist.TalkToPerson(ply, recipient, nick, text)
    end
end
Antagonist.RegisterChatCommand("ooc", oocChatCommand)

local function loocChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    Antagonist.TalkToRange(GAMEMODE.Config.TalkDistance, ply, "(Local OOC) " .. ply:Nick(), ": " .. text)
end
Antagonist.RegisterChatCommand("looc", loocChatCommand)

local function flipChatCommand(ply, args, text)
    local coinSide = math.random(2) == 1 and Antagonist.GetPhrase(ply.Language, "coin_heads")
                        or Antagonist.GetPhrase(ply.Language, "coin_tails")
    local phrase = Antagonist.GetPhrase(ply.Language, "action_flip", coinSide)

    Antagonist.TalkToRange(GAMEMODE.Config.MeDistance, ply, ply:Nick() .. " " .. phrase)
end
Antagonist.RegisterChatCommand("flip", flipChatCommand)
