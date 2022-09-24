local tag = "Antagonist.ChatRecipients"
local recipients = {}

local backgroundColor = Color(0, 0, 0, 150)
local textColorRed = Color(250, 50, 50)
local textColorGreen = Color(50, 250, 50)

local function getChatRecipients()
    local localPlayer = LocalPlayer()
    local eyePos = localPlayer:EyePos()
    local range = Antagonist.Config.TalkDistance
    local rangeSqr = range * range

    recipients = {}
    local players = player.GetHumans()

    for i = 1, #players do
        local ply = players[i]
        if !IsValid(ply) or ply == localPlayer or ply:GetNoDraw() then continue end

        if ply:EyePos():DistToSqr(eyePos) <= rangeSqr then
            table.insert(recipients, ply)
        end
    end

    return recipients
end

local function drawChatRecipients()
    if !recipients then return end

    local fontHeight = draw.GetFontHeight(tag)
    local x, y = chat.GetChatBoxPos()

    y = y - fontHeight - 6

    local playerCount = player.GetCount()
    local recipientsCount = #recipients

    if recipientsCount == 0 then
        draw.WordBox(4, x, y, Antagonist.GetPhrase(nil, "hear_noone"), tag, backgroundColor, textColorRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        return
    elseif recipientsCount == playerCount - 1 then
        draw.WordBox(4, x, y, Antagonist.GetPhrase(nil, "hear_everyone"), tag, backgroundColor, textColorGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        return
    end

    local wordBoxY = y - recipientsCount * (fontHeight + 6)
    draw.WordBox(4, x, wordBoxY, Antagonist.GetPhrase(nil, "hear_certain_persons"), tag, backgroundColor, textColorGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    for i = 1, recipientsCount do
        local recipient = recipients[i]
        if !IsValid(recipient) then continue end

        local nick = recipient:Nick()
        local recipientWordBoxY = y - (i - 1) * (fontHeight + 6)

        draw.WordBox(4, x, recipientWordBoxY, nick, tag, backgroundColor, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function GM:StartChat()
    timer.Create(tag, 0.1, 0, getChatRecipients)
    hook.Add("HUDPaint", tag, drawChatRecipients)
end

function GM:FinishChat()
    timer.Remove(tag)
    hook.Remove("HUDPaint", tag)
end
