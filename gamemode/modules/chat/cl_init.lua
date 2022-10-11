function GM:OnPlayerChat()
end

net.Receive("Antagonist.Chat", function()
    local ply = net.ReadEntity()
    if !IsValid(ply) then return end

    local prefixColor = team.GetColor(ply:Team())
    local prefixText = net.ReadString()

    if !prefixText or prefixText == "" then
        local nick = ply:Nick()
        prefixText = nick != "" and nick or ply:SteamName()
    end

    local textColor = ply:Alive() and color_white or Color(255, 200, 200)
    local text = net.ReadString()

    local shouldShow
    if text and text != "" then
        shouldShow = hook.Call("OnPlayerChat", GM, ply, text, false, !ply:Alive(), prefixText, prefixColor, textColor)

        if shouldShow != true then
            chat.AddNonParsedText(prefixColor, prefixText, textColor, text)
        end
    else
        shouldShow = hook.Call("ChatText", GM, "0", prefixText, prefixText, "ag")

        if shouldShow != true then
            chat.AddNonParsedText(prefixColor, prefixText)
        end
    end

    chat.PlaySound()
end)
