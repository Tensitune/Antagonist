local recipients = {}

local backgroundColor = Color(0, 0, 0, 150)
local textColorRed = Color(250, 50, 50)
local textColorGreen = Color(50, 250, 50)

local chatType = 0 -- 0 - Talk, 1 - Yell, 2 - Whisper, 3 - Me

local function getChatRecipients()
    local localPlayer = LocalPlayer()
    local eyePos = localPlayer:EyePos()

    local range = chatType == 1 and ag.config.yellDistance
                    or chatType == 2 and ag.config.whisperDistance
                    or ag.config.talkDistance
    local rangeSqr = range * range

    recipients = {}
    local players = player.GetAll()

    for i = 1, #players do
        local ply = players[i]

        if !IsValid(ply) or ply == localPlayer or ply:GetNoDraw() then continue end

        if ply:EyePos():DistToSqr(eyePos) <= rangeSqr then
            recipients[#recipients + 1] = ply
        end
    end

    return recipients
end

local function drawChatRecipients()
    if !recipients then return end

    local fontHeight = draw.GetFontHeight("ag.FontChatRecipients")
    local x, y = chat.GetChatBoxPos()

    y = y - fontHeight - 6

    local recipientsCount = #recipients
    local chatTypeStr = chatType == 1 and " " .. ag.lang.GetPhrase("yell_listeners")
                        or chatType == 2 and " " .. ag.lang.GetPhrase("whisper_listeners")
                        or chatType == 3 and " " .. ag.lang.GetPhrase("me_listeners")
                        or ""

    if recipientsCount == 0 then
        draw.WordBox(
            4, x, y, ag.lang.GetPhrase("hear_noone") .. chatTypeStr,
            "ag.FontChatRecipients", backgroundColor, textColorRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
        )
        return
    elseif recipientsCount == player.GetCount() - 1 then
        draw.WordBox(
            4, x, y, ag.lang.GetPhrase("hear_everyone") .. chatTypeStr,
            "ag.FontChatRecipients", backgroundColor, textColorGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
        )
        return
    end

    draw.WordBox(
        4, x, y - recipientsCount * (fontHeight + 6), ag.lang.GetPhrase("hear_certain_persons") .. chatTypeStr,
        "ag.FontChatRecipients", backgroundColor, textColorGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
    )

    for i = 1, recipientsCount do
        local recipient = recipients[i]
        if !IsValid(recipient) then continue end

        draw.WordBox(
            4, x, y - (i - 1) * (fontHeight + 6), recipient:Nick(),
            "ag.FontChatRecipients", backgroundColor, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
        )
    end
end

function GM:StartChat()
    timer.Create("ag.ChatRecipients", 0.1, 0, getChatRecipients)
    hook.Add("HUDPaint", "ag.ChatRecipients", drawChatRecipients)
end

function GM:FinishChat()
    timer.Remove("ag.ChatRecipients")
    hook.Remove("HUDPaint", "ag.ChatRecipients")
end

function GM:ChatTextChanged(text)
    -- 0 - Talk, 1 - Yell, 2 - Whisper, 3 - Me
    chatType = (text:Left(3) == "/y " or text:Right(3) == "!!!") and 1
                or text:Left(3) == "/w " and 2
                or text:Left(4) == "/me " and 3
                or 0
end
