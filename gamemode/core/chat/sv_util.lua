local function sendChatMessage(sender, recipient, prefix, message)
    if !IsValid(sender) and !recipient then return end

    net.Start("Antagonist.Chat")
    net.WriteEntity(sender)
    net.WriteString(prefix)
    net.WriteString(message)
    net.Send(recipient)
end

function Antagonist.TalkToRange(range, sender, prefix, message)
    if !IsValid(sender) then return end

    if !prefix then prefix = "" end
    if !message then message = "" end

    local eyePos = sender:EyePos()
    local rangeSqr = range * range

    local filter = {}
    local players = player.GetHumans()

    for i = 1, #players do
        local recipient = players[i]
        if !IsValid(recipient) then continue end

        if recipient == sender or recipient:EyePos():DistToSqr(eyePos) <= rangeSqr then
            filter[#filter + 1] = recipient
        end
    end

    sendChatMessage(sender, filter, prefix, message)
end

function Antagonist.TalkToPerson(sender, recipient, prefix, message)
    if !IsValid(sender) or !IsValid(recipient) then return end

    if !prefix then prefix = "" end
    if !message then message = "" end

    sendChatMessage(sender, recipient, prefix, message)
end
