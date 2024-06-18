local backgroundColor = Color(66, 66, 66)
local hoveredColor = Color(99, 99, 99)
local disabledColor = Color(33, 11, 11)

local BUTTON = {}

function BUTTON:Init()
    self:SetFont("ag.FontText")
    self:SetText("Button")
    self:SetTextColor(color_white)
    self:SetTall(30)

    self:DockMargin(0, 0, 0, 2)

    self.HoveredOnlyColor = false
end

function BUTTON:SetHoveredOnlyColor(bool)
    self.HoveredOnlyColor = bool
end

function BUTTON:Paint(w, h)
    if !self:IsEnabled() then
        draw.RoundedBox(0, 0, 0, w, h, disabledColor)
        return
    elseif self:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, hoveredColor)
        return
    end

    if !self.HoveredOnlyColor then
        draw.RoundedBox(0, 0, 0, w, h, backgroundColor)
    end
end

vgui.Register("ag.Button", BUTTON, "DButton")
