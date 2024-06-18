local backgroundColor = Color(33, 33, 33, 200)
local closeButtonColor = Color(120, 60, 60)

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetDraggable(true)
    self:ShowCloseButton(false)
    self:Center()
    self:MakePopup()

    self.Title = "Antagonist"

    self.header = self:Add("DPanel")
    self.header:SetSize(self:GetWide(), 24)
    self.header:SetPos(0, 0)
    self.header.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, backgroundColor)
        draw.SimpleText(self.Title, "ag.FontTitle", 5, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.closeBtn = self.header:Add("ag.Button")
    self.closeBtn:SetSize(self.header:GetTall(), self.header:GetTall())
    self.closeBtn:SetPos(self.header:GetWide() - self.closeBtn:GetWide(), 0)
    self.closeBtn:SetText("X")
    self.closeBtn.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, closeButtonColor)
        end
        draw.SimpleText("X", "ag.FontTitle", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.closeBtn.DoClick = function()
        surface.PlaySound("ambient/water/rain_drip3.wav")
        self:Close()
    end

    self:DockPadding(5, self.header:GetTall() + 5, 5, 5)
end

function PANEL:SetHeaderTitle(text)
    self.Title = text
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, backgroundColor)
end

function PANEL:OnSizeChanged(w, h)
    self.header:SetSize(w, 24)
    self.header:SetPos(0, 0)

    self.closeBtn:SetSize(self.header:GetTall(), self.header:GetTall())
    self.closeBtn:SetPos(self.header:GetWide() - self.closeBtn:GetWide(), 0)
end

vgui.Register("ag.Frame", PANEL, "DFrame")
