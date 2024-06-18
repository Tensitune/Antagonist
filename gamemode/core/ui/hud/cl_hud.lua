local hide = {
    ["CHudWeaponSelection"] = true
}

hook.Add("HUDShouldDraw", "ag.HideHUD", function(name)
    if hide[name] then return false end
end)

local color_black = Color(0, 0, 0)
hook.Add("HUDPaint", "ag.Debug", function()
    local localPlayer = LocalPlayer()
    local scrW, scrH = ScrW(), ScrH()

    local pos = -10

    if localPlayer:IsRunning() then
        draw.SimpleTextOutlined("Running", "ag.FontText", scrW - 10, scrH * 0.5 + pos, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
    elseif !localPlayer:IsOnGround() then
        draw.SimpleTextOutlined("Not on ground", "ag.FontText", scrW - 10, scrH * 0.5 + pos, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
    else
        draw.SimpleTextOutlined("Walking", "ag.FontText", scrW - 10, scrH * 0.5 + pos, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
    end

    pos = pos + 20

    if localPlayer:IsUnderwater() then
        draw.SimpleTextOutlined("No air", "ag.FontText", scrW - 10, scrH * 0.5 + pos, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
    else
        draw.SimpleTextOutlined("Breathing", "ag.FontText", scrW - 10, scrH * 0.5 + pos, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
    end
end)
