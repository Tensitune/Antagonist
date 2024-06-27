--[[-------------------------------------------------------------------------
Tensitune's Lightweight Library for Garry's Mod
Copyright (c) 2022 Tensitune

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-----------------------------------------------------------------------------]]

tgui = tgui or {}

tgui.AnimDelay = 0.1
tgui.AnimOffset = 20

local panelPosList = {}

tgui.AnimList = {
    alpha = function(panel, alpha, delay, remove)
        if alpha > 0 then
            timer.Remove("tgui.FadeOut." .. panel:GetName())
        end

        delay = delay or tgui.AnimDelay
        remove = remove or false

        panel:SetVisible(true)
        panel:AlphaTo(alpha, delay)

        if alpha <= 0 then
            timer.Create("tgui.FadeOut." .. panel:GetName(), delay, 1, function()
                if not IsValid(panel) then return end

                if remove then
                    panelPosList[panel] = nil
                    panel:Remove()
                else
                    panel:SetVisible(false)
                end
            end)
        end
    end,
    move = function(panel, to, offset, delay)
        local panelPos = panelPosList[panel]
        local x, y, xOffset, yOffset = 0, 0, 0, 0

        to = string.lower(to)
        offset = offset or tgui.AnimOffset
        delay = delay or tgui.AnimDelay

        local separatedTo = string.Explode("-", to)

        if to == "up" or table.HasValue(separatedTo, "up") then
            yOffset = -offset
        end
        if to == "down" or table.HasValue(separatedTo, "down") then
            yOffset = offset
        end
        if to == "left" or table.HasValue(separatedTo, "left") then
            xOffset = -offset
        end
        if to == "right" or table.HasValue(separatedTo, "right") then
            xOffset = offset
        end

        if to == "back" then
            x = panelPos.x
            y = panelPos.y
        else
            x = panel:GetX() + xOffset
            y = panel:GetY() + yOffset
        end

        panel:MoveTo(x, y, delay)
    end,
}

-- animations - / aplha: number / move: string /
-- params - / offset: number / delay: number / remove: bool /
-- move - / up / down / left / right / back /
function tgui.Animate(panel, params, callback)
    if not IsValid(panel) then return end

    if not panelPosList[panel] then
        panelPosList[panel] = { x = panel:GetX(), y = panel:GetY() }
    end

    panel:Stop()

    for name, _ in next, params do
        local animate = tgui.AnimList[name]
        if not animate then continue end

        if name == "alpha" then
            animate(panel, params.alpha, params.delay, params.remove)
        elseif name == "move" then
            animate(panel, params.move, params.offset, params.delay)
        end
    end

    timer.Create("tgui.PostPanelAnim." .. panel:GetName(), tgui.AnimDelay, 1, function()
        if callback then callback(panel) end

        if not IsValid(panel) then
            panelPosList[panel] = nil
        end
    end)
end
