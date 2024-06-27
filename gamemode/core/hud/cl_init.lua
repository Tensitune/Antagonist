local hide = {
    ["CHudWeaponSelection"] = true
}

local function createHUDPanel()
    if GAMEMODE.HUD then GAMEMODE.HUD:Remove() end

    local scrW, scrH = ScrW(), ScrH()

    GAMEMODE.HUD = vgui.Create("DPanel")
    GAMEMODE.HUD:SetSize(scrW, scrH)
    GAMEMODE.HUD:ParentToHUD()
    GAMEMODE.HUD.Paint = function() end

    GAMEMODE.HUD.ItemPanel = GAMEMODE.HUD:Add("ag.hud.Item")
    GAMEMODE.HUD.ItemPanel:SetSize(scrW * 0.08, scrH * 0.2)

    local w = GAMEMODE.HUD.ItemPanel:GetWide()
    GAMEMODE.HUD.ItemPanel:SetPos(scrW * 0.5 - w * 0.5, scrH * 0.55)
    GAMEMODE.HUD.ItemPanel:Update()
end

hook.Add("HUDShouldDraw", "ag.hud.Hide", function(name)
    if hide[name] then return false end
end)

hook.Add("HUDPaint", "ag.hud.CreatePanel", function()
    createHUDPanel()
    hook.Remove("HUDPaint", "ag.hud.CreatePanel")
end)

hook.Add("OnScreenSizeChanged", "ag.hud.ScreenSize", function()
    createHUDPanel()
end)

local mouseWheelInput, mouseWheelDelay = 0, 0
hook.Add("InputMouseApply", "ag.hud.OptionSelectWheel", function(cmd)
    local panel = GAMEMODE.HUD.ItemPanel

    if not IsValid(panel) then return end
    if panel.Item == nil then return end
    if mouseWheelDelay > RealTime() then return end

    mouseWheelInput = cmd:GetMouseWheel()
    local up = math.max(mouseWheelInput, 0) == 1
    local down = math.min(mouseWheelInput, 0) == -1

    if not up and not down then return end

    if up then
        panel:SelectPrev()
    elseif down then
        panel:SelectNext()
    end

    mouseWheelDelay = RealTime() + 0.1
end)

local keyPressDelay = 0
local keys = { KEY_1, KEY_2, KEY_3, KEY_4 }
hook.Add("CreateMove", "ag.hud.OptionSelectKeyboard", function()
    local panel = GAMEMODE.HUD.ItemPanel

    if not IsValid(panel) then return end
    if panel.Item == nil then return end

    if not input.IsKeyDown(KEY_LALT) and input.WasKeyPressed(KEY_E) and keyPressDelay <= RealTime() then
        panel:PressSelected()
        keyPressDelay = RealTime() + 0.3
    end

    for i = 1, #keys do
        if input.WasKeyPressed(keys[i]) then
            panel:Select(i)
            break
        end
    end
end)
