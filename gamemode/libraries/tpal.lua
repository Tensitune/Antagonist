--[[-------------------------------------------------------------------------
TPAL - Tensitune's Panel Animations Library for Garry's Mod
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

TPAL = TPAL or {}
TPAL.Animations = {
    ["alpha"] = true,
    ["alpha-pos"] = true,
}

function TPAL.Open(panel, animType, time)
    if !TPAL.Animations[animType] then return end
    time = time or 0.2

    local x, y = panel:GetX(), panel:GetY()

    if animType == "alpha" or animType == "alpha-pos" then
        panel:SetAlpha(0)
        panel:AlphaTo(255, time)
    end

    if animType == "alpha-pos" then
        panel:SetPos(x, y + 30)
        panel:MoveTo(x, y, time)
    end
end

function TPAL.Close(panel, animType, time)
    if !TPAL.Animations[animType] then return end
    time = time or 0.2

    local children = panel:GetChildren()

    for i = 1, #children do
        local child = children[i]
        if !IsValid(child) then continue end

        child:SetEnabled(false)
    end

    if animType == "alpha" or animType == "alpha-pos" then
        panel:AlphaTo(0, time)
    end

    if animType == "alpha-pos" then
        panel:MoveTo(panel:GetX(), panel:GetY() + 30, time)
    end

    timer.Simple(time, function()
        if !IsValid(panel) then return end

        if isfunction(panel.Close) then
            panel:Close()
            return
        end

        panel:Remove()
    end)
end
