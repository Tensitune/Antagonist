function GM:OnPlayerChat()
end

local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

function ag.chat.AddNonParsedText(...)
    local tbl = {...}
    for i = 2, #tbl, 2 do
        tbl[i] = safeText(tbl[i])
    end

    return chat.AddText(unpack(tbl))
end

net.Receive("ag.Chat", function()
    local ply = net.ReadEntity()
    if !IsValid(ply) then return end

    local prefixColor = team.GetColor(ply:Team())
    local prefixText = net.ReadString()

    if !prefixText or prefixText == "" then
        local nick = ply:Nick()
        prefixText = nick != "" and nick or ply:SteamName()
    end

    local text = net.ReadString()

    if text and text != "" then
        local textColor = ply:Alive() and color_white or Color(255, 200, 200)
        ag.chat.AddNonParsedText(prefixColor, prefixText, textColor, text)
    else
        ag.chat.AddNonParsedText(prefixColor, prefixText)
    end

    chat.PlaySound()
end)
