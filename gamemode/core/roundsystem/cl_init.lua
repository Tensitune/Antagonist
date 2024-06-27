local draw_SimpleText = draw.SimpleText
local math_floor = math.floor

local function timeToString(seconds)
    local s = seconds % 60
    seconds = math_floor(seconds / 60)
    local m = seconds % 60
    seconds = math_floor(seconds / 60)
    local h = seconds % 24

    return ("%02d:%02d:%02d"):format(h, m, s)
end

hook.Add("HUDPaint", "ag.round.Time", function()
    local roundTime = timeToString(ag.round.GetTime())
    draw_SimpleText(roundTime, "ag.font.Title", ScrW() - 5, 0, color_white, TEXT_ALIGN_RIGHT)
end)
