local backgroundColor = Color(66, 66, 66)
local hoveredColor = Color(99, 99, 99)
local disabledColor = Color(33, 11, 11)

local BUTTON = {}

function BUTTON:Init()
    self:SetFont("ag.FontTitle")
    self:SetText("Button")
    self:SetTextColor(color_white)
    self:SetSize(ScrW() * 0.1, ScrH() * 0.05)
end

function BUTTON:Paint(w, h)
    if !self:IsEnabled() then
        draw.RoundedBox(h * 0.5, 0, 0, w, h, disabledColor)
        return
    elseif self:IsHovered() then
        draw.RoundedBox(h * 0.5, 0, 0, w, h, hoveredColor)
        return
    end

    draw.RoundedBox(h * 0.5, 0, 0, w, h, backgroundColor)
end

vgui.Register("ag.BubbleButton", BUTTON, "DButton")
