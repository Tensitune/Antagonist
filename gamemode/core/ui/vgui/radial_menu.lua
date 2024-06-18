local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetSize(ScrW(), ScrH())
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:Center()
    self:MakePopup()

    local closeBtn = self:Add("ag.BubbleButton")
    closeBtn:SetText(ag.lang.GetPhrase("option_close"))
    closeBtn:SetPos(self:GetWide() * 0.5 - closeBtn:GetWide() * 0.5, self:GetTall() * 0.5 - closeBtn:GetTall() * 0.5)
    closeBtn:SetAlpha(0)
    closeBtn:AlphaTo(255, 0.2)
    closeBtn.DoClick = function()
        surface.PlaySound("ambient/water/rain_drip3.wav")
        self:Close()
    end
end

function PANEL:Paint(w, h)
end

function PANEL:SetEntity(entity)
    if !IsValid(entity) then return end

    if entity:GetClass() == "ag_weapon" then
        local clip = entity:GetClip1()

        self:AddButton(clip < 0 and -90 or 0, clip < 0 and 75 or 250, ag.lang.GetPhrase("option_pickup"), function()
            net.Start("ag.ActionWeapon")
            net.WriteEntity(entity)
            net.WriteInt(ACTION_PICKUP_WEAPON, 4)
            net.SendToServer()

            self:Close()
        end)

        if clip >= 0 then
            local unloadBtn = self:AddButton(180, 250, ag.lang.GetPhrase("option_unload", clip), function()
                net.Start("ag.ActionWeapon")
                net.WriteEntity(entity)
                net.WriteInt(ACTION_UNLOAD_WEAPON, 4)
                net.SendToServer()

                self:Close()
            end)

            if clip == 0 then
                unloadBtn:SetText(ag.lang.GetPhrase("option_unloaded"))
                unloadBtn:SetEnabled(false)
            end
        end
    end
end

function PANEL:AddButton(deg, radius, text, func)
    local rad = math.rad(deg - 180)

    local button = self:Add("ag.BubbleButton")
    button:SetAlpha(0)
    button:SetPos(self:GetWide() * 0.5 - button:GetWide() * 0.5, self:GetTall() * 0.5 - button:GetTall() * 0.5)

    local ox = (ScrW() * 0.5 - button:GetWide() * 0.5) + (math.cos(rad) * radius)
    local oy = (ScrH() * 0.5 - button:GetTall() * 0.5) + (-math.sin(rad) * radius)

    button:AlphaTo(255, 0.2)
    button:MoveTo(ox, oy, 0.2)
    button:SetText(text)
    button.DoClick = func

    return button
end

vgui.Register("ag.Radial", PANEL, "DFrame")
