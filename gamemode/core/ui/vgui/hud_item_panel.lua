local PANEL = {}
local backgroundColor = Color(0, 0, 0, 180)
local selectColor = Color(80, 80, 80, 180)

function PANEL:Init()
    self.Item = nil
    self.Options = {}

    self:DockPadding(0, 0, 0, 0)
    self:DockMargin(0, 0, 0, 0)

    self.Panel = self:Add("DPanel")
    self.Panel:SetAlpha(0)

    self.Panel.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, backgroundColor)
    end
end

function PANEL:Paint()
end

function PANEL:Update()
    local w, h = self:GetWide(), self:GetTall()

    self.Panel:SetSize(w, h - tgui.AnimOffset * 2)
    self.Panel:SetPos(0, 0)

    self.Panel.Size = { w = self.Panel:GetWide(), h = self.Panel:GetTall() }
end

function PANEL:AddOption(name, func)
    local index = #self.Options + 1
    local panelW, panelH = self.Panel.Size.w, self.Panel.Size.h

    self.Options[index] = self.Panel:Add("DPanel")
    self.Options[index]:SetSize(panelW, panelH * 0.25)
    self.Options[index]:SetPos(0, panelH * 0.25 * (index - 1))
    self.Options[index].Selected = index == 1 and true or false
    self.Options[index].Press = func
    self.Options[index].Paint = function(s, w, h)
        if s.Selected then
            draw.RoundedBox(0, 0, 0, w, h, selectColor)
        end

        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText(index .. ". " .. name, "ag.font.Title", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.Panel:SetSize(panelW, panelH * (0.25 * index))
end

function PANEL:RemoveOption(num)
    local option = self.Options[num]
    if option == nil then return end

    table.remove(self.Options, num)
    option:Remove()

    local options = self.Options
    self.Panel:SetSize(self.Panel.Size.w, self.Panel.Size.h * (0.25 * #options))

    for i = 1, #options do
        options[i]:SetPos(0, self.Panel.Size.h * 0.25 * (i - 1))
    end

    self.Options[1].Selected = true
end

function PANEL:RemoveOptions()
    local options = self.Options
    for i = 1, #self.Options do
        options[i]:Remove()
    end

    self.Options = {}
end

function PANEL:Select(num)
    local options = self.Options
    if num <= 0 or num > #options then return end

    for i = 1, #options do
        options[i].Selected = false
    end

    options[num].Selected = true
    options[num].Press()
end

function PANEL:SelectNext()
    local options = self.Options
    if #options == 1 then return end

    for i = 1, #options do
        local option = options[i]
        local nextOption = i == #options and options[1] or options[i + 1]

        if option.Selected then
            nextOption.Selected = true
            option.Selected = false

            break
        end
    end
end

function PANEL:SelectPrev()
    local options = self.Options
    if #options == 1 then return end

    for i = 1, #options do
        local option = options[i]
        local prevOption = i == 1 and options[#options] or options[i - 1]

        if option.Selected then
            prevOption.Selected = true
            option.Selected = false

            break
        end
    end
end

function PANEL:PressSelected()
    local options = self.Options

    for i = 1, #options do
        local option = options[i]
        if option.Selected then
            option.Press()
            break
        end
    end
end

function PANEL:Think()
    local entity = LocalPlayer():GetEyeTrace().Entity
    local isItem = IsValid(entity) and entity:GetClass() == "ag_weapon" or false

    if self.Item != nil and not isItem then
        self.Item = nil
        self:RemoveOptions()

        tgui.Animate(self.Panel, { alpha = 0, move = "down" })
    elseif self.Item == nil and isItem then
        self.Item = entity

        self:AddOption(ag.lang.GetPhrase("option_pickup"), function()
            net.Start("ag.ActionWeapon")
            net.WriteEntity(entity)
            net.WriteInt(ACTION_PICKUP_WEAPON, 4)
            net.SendToServer()
        end)

        if entity.GetClip1 and entity:GetClip1() > 0 then
            self:AddOption(ag.lang.GetPhrase("option_unload"), function()
                net.Start("ag.ActionWeapon")
                net.WriteEntity(entity)
                net.WriteInt(ACTION_UNLOAD_WEAPON, 4)
                net.SendToServer()

                self:RemoveOption(2)
            end)
        end

        self.Panel:SetY(0)
        tgui.Animate(self.Panel, { alpha = 255, move = "down" })
    end
end

vgui.Register("ag.hud.Item", PANEL, "Panel")
