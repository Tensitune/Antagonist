local function meChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    Antagonist.TalkToRange(GAMEMODE.Config.MeDistance, ply:Nick() .. " " .. text, ply)
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

    for i = 1, #players do
        local recipient = players[i]
        Antagonist.TalkToPerson("(OOC) " .. nick, ply, recipient, text)
    end
end
Antagonist.RegisterChatCommand("ooc", oocChatCommand)

local function loocChatCommand(ply, args, text)
    if text == "" then
        Antagonist.Notify(ply, NOTIFY_ERROR, 3, Antagonist.GetPhrase(ply.Language, "invalid_args"))
        return
    end

    Antagonist.TalkToRange(GAMEMODE.Config.TalkDistance, "(Local OOC) " .. ply:Nick(), ply, text)
end
Antagonist.RegisterChatCommand("looc", loocChatCommand)
