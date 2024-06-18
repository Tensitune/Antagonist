local backgroundColor = Color(66, 66, 66)
local hoveredColor = Color(99, 99, 99)
local disabledColor = Color(33, 11, 11)

local BUTTON = {}

function BUTTON:Init()
    self:SetText("")
    self:SetSize(ScrH() * 0.1, ScrH() * 0.1)

    self.slot = -1
    self.text = ""
    self.textColor = Color(150, 150, 150)
end

function BUTTON:SetSlotText(text)
    self.text = text
end

function BUTTON:Paint(w, h)
    if !self:IsEnabled() then
        draw.RoundedBox(h * 0.15, 0, 0, w, h, disabledColor)
        return
    elseif self:IsHovered() then
        draw.RoundedBox(h * 0.15, 0, 0, w, h, hoveredColor)
        return
    end

    if !self.HoveredOnlyColor then
        draw.RoundedBox(h * 0.15, 0, 0, w, h, backgroundColor)
    end

    local lines = string.Split(self.text, "\n")
    draw.DrawText(self.text, agFontInventorySlot, w * 0.5, h * 0.5 - 7.5 * #lines, self.textColor, TEXT_ALIGN_CENTER)
end

function BUTTON:DoClick()
    if self.slot == -1 then return end

    local dermaMenu = DermaMenu()
    dermaMenu:AddOption("Drop", function()
        net.Start("ag.InventoryDropItem")
        net.WriteInt(self.Slot, 5)
        net.SendToServer()
    end)
    dermaMenu:Open()
end

function BUTTON:SetTextColor(color)
    self.textColor = color
end

function BUTTON:SetSlot(slot)
    self.slot = slot
end

function BUTTON:GetSlot()
    return self.slot
end

vgui.Register("ag.InventoryButton", BUTTON, "DButton")
