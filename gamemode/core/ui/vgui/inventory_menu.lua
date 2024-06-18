local PANEL = {}

local closeColor = Color(33, 33, 33)
local closeHoveredColor = Color(66, 66, 66)
local grayColor = Color(150, 150, 150)

function PANEL:Init()
    self:SetTitle("")
    self:SetSize(ScrW(), ScrH())
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:Center()
    self:MakePopup()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.2)

    local closeBtn = self:Add("DButton")
    closeBtn:SetFont("ag.FontTitle")
    closeBtn:SetText(ag.lang.GetPhrase("option_close"))
    closeBtn:SetTextColor(color_white)
    closeBtn:SetSize(150, 50)
    closeBtn:SetPos(ScrW() - 170, 20)
    closeBtn.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, closeHoveredColor)
            return
        end

        draw.RoundedBox(0, 0, 0, w, h, closeColor)
    end
    closeBtn.DoClick = function()
        surface.PlaySound("ambient/water/rain_drip3.wav")
        self:Close()
    end

    local head = self:Add("ag.InventoryButton")
    head:SetPos(ScrW() * 0.5 - head:GetWide() * 0.5, 20)
    head:SetSlot(SLOT_HEAD)
    head:SetSlotText(ag.lang.GetPhrase("SLOT_HEAD"))

    local mask = self:Add("ag.InventoryButton")
    mask:SetPos(ScrW() * 0.4 - mask:GetWide() * 0.5, 40 + mask:GetWide())
    mask:SetSlot(SLOT_MASK)
    mask:SetSlotText(ag.lang.GetPhrase("SLOT_MASK"))
    local eyes = self:Add("ag.InventoryButton")
    eyes:SetPos(ScrW() * 0.5 - eyes:GetWide() * 0.5, 40 + eyes:GetWide())
    eyes:SetSlot(SLOT_EYES)
    eyes:SetSlotText(ag.lang.GetPhrase("SLOT_EYES"))
    local ears = self:Add("ag.InventoryButton")
    ears:SetPos(ScrW() * 0.6 - ears:GetWide() * 0.5, 40 + ears:GetWide())
    ears:SetSlot(SLOT_EARS)
    ears:SetSlotText(ag.lang.GetPhrase("SLOT_EARS"))

    local uniform = self:Add("ag.InventoryButton")
    uniform:SetPos(ScrW() * 0.45 - uniform:GetWide() * 0.5, 60 + uniform:GetWide() * 2)
    uniform:SetSlot(SLOT_UNIFORM)
    uniform:SetSlotText(ag.lang.GetPhrase("SLOT_UNIFORM"))
    local outerSuit = self:Add("ag.InventoryButton")
    outerSuit:SetPos(ScrW() * 0.55 - outerSuit:GetWide() * 0.5, 60 + outerSuit:GetWide() * 2)
    outerSuit:SetSlot(SLOT_OUTER_SUIT)
    outerSuit:SetSlotText(ag.lang.GetPhrase("SLOT_OUTER_SUIT"))

    local back = self:Add("ag.InventoryButton")
    back:SetPos(ScrW() * 0.5 - back:GetWide() * 0.5, 80 + back:GetWide() * 3)
    back:SetSlot(SLOT_BACK)
    back:SetSlotText(ag.lang.GetPhrase("SLOT_BACK"))

    local gloves = self:Add("ag.InventoryButton")
    gloves:SetPos(ScrW() * 0.45 - gloves:GetWide() * 0.5, 100 + gloves:GetWide() * 4)
    gloves:SetSlot(SLOT_GLOVES)
    gloves:SetSlotText(ag.lang.GetPhrase("SLOT_GLOVES"))
    local hands = self:Add("ag.InventoryButton")
    hands:SetPos(ScrW() * 0.55 - hands:GetWide() * 0.5, 100 + hands:GetWide() * 4)
    hands:SetSlot(SLOT_HANDS)
    hands:SetSlotText(ag.lang.GetPhrase("SLOT_HANDS"))

    local id = self:Add("ag.InventoryButton")
    id:SetPos(ScrW() * 0.4 - id:GetWide() * 0.5, 120 + id:GetWide() * 5)
    id:SetSlot(SLOT_ID)
    id:SetSlotText(ag.lang.GetPhrase("SLOT_ID"))
    local belt = self:Add("ag.InventoryButton")
    belt:SetPos(ScrW() * 0.5 - belt:GetWide() * 0.5, 120 + belt:GetWide() * 5)
    belt:SetSlot(SLOT_BELT)
    belt:SetSlotText(ag.lang.GetPhrase("SLOT_BELT"))
    local pda = self:Add("ag.InventoryButton")
    pda:SetPos(ScrW() * 0.6 - pda:GetWide() * 0.5, 120 + pda:GetWide() * 5)
    pda:SetSlot(SLOT_PDA)
    pda:SetSlotText(ag.lang.GetPhrase("SLOT_PDA"))

    local leftPocket = self:Add("ag.InventoryButton")
    leftPocket:SetPos(ScrW() * 0.45 - leftPocket:GetWide() * 0.5, 140 + leftPocket:GetWide() * 6)
    leftPocket:SetSlot(SLOT_LEFT_POCKET)
    leftPocket:SetSlotText(ag.lang.GetPhrase("SLOT_LEFT_POCKET"))
    local rightPocket = self:Add("ag.InventoryButton")
    rightPocket:SetPos(ScrW() * 0.55 - rightPocket:GetWide() * 0.5, 140 + rightPocket:GetWide() * 6)
    rightPocket:SetSlot(SLOT_RIGHT_POCKET)
    rightPocket:SetSlotText(ag.lang.GetPhrase("SLOT_RIGHT_POCKET"))

    local shoes = self:Add("ag.InventoryButton")
    shoes:SetPos(ScrW() * 0.5 - shoes:GetWide() * 0.5, 160 + shoes:GetWide() * 7)
    shoes:SetSlot(SLOT_SHOES)
    shoes:SetSlotText(ag.lang.GetPhrase("SLOT_SHOES"))

    self.slotButtons = { head, mask, eyes, ears, uniform, outerSuit, back, gloves, hands, id, belt, pda, leftPocket, rightPocket, shoes }
    self.nextThink = 0
end

function PANEL:Think()
    if self.nextThink > CurTime() then return end

    ag.inventory.Get(function(err, inventory)
        if err then return end

        for i = 1, #self.slotButtons do
            local btn = self.slotButtons[i]

            local item = inventory[btn:GetSlot()].item
            if !table.IsEmpty(item) then

                local text = ag.lang.GetPhrase(ag.inventory.slots[btn:GetSlot()]) .. "\n"
                text = text .. item.class

                btn:SetSlotText(text)
                btn:SetTextColor(color_white)
            else
                btn:SetSlotText(ag.lang.GetPhrase(ag.inventory.slots[btn:GetSlot()]))
                btn:SetTextColor(grayColor)
            end
        end
    end)

    self.nextThink = CurTime() + 3
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self)
end

vgui.Register("ag.Inventory", PANEL, "DFrame")
