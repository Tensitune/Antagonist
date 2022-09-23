local function meChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalidArgs"))
        return
    end

    Antagonist.TalkToRange(Antagonist.Config.MeDistance, ply:Nick() .. " " .. text, ply)
end
Antagonist.RegisterChatCommand("me", meChatCommand)

local function oocChatCommand(ply, args, text)
    if !Antagonist.Config.OOC then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "disabledOOC"))
        return
    end

    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalidArgs"))
        return
    end

    local nick = ply:Nick()
    local players = player.GetHumans()

    for i = 1, #players do
        local recipient = players[i]
        Antagonist.TalkToPerson("(OOC) " .. nick, ply, recipient, text)
    end
end
Antagonist.RegisterChatCommand("ooc", oocChatCommand)

local function loocChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalidArgs"))
        return
    end

    Antagonist.TalkToRange(Antagonist.Config.TalkDistance, "(Local OOC) " .. ply:Nick(), ply, text)
end
Antagonist.RegisterChatCommand("looc", loocChatCommand)
