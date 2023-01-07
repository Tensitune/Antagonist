local camStart3D2D, camEnd3D2D = cam.Start3D2D, cam.End3D2D
local surfaceGetTextSize = surface.GetTextSize
local surfaceSetFont = surface.SetFont
local surfaceSetTextColor = surface.SetTextColor
local surfaceSetTextPos = surface.SetTextPos
local surfaceDrawText = surface.DrawText

local playersToDraw = {}
local playerAngle = Angle(0, 90, 90)

local healthyColor = Color(0, 200, 0)
local minorInjuriesColor = Color(200, 200, 0)
local seriousInjuriesColor = Color(200, 100, 0)
local criticalInjuriesColor = Color(200, 0, 0)

local function drawInfo(text, posY, color)
    local w, h = surfaceGetTextSize(text)

    surfaceSetTextColor(color.r, color.g, color.b, color.a)
    surfaceSetTextPos(-(w * 0.5), posY)
    surfaceDrawText(text)

    return posY + h - 30
end

local function drawPlayerInfo(ply)
    if !ply:Alive() then return end
    if ply.HidePlayerInfo then return end

    local alpha = 255
    local health = ply:Health()
    local teamColor = team.GetColor(ply:Team())
    local healthStr, healthColor

    if health >= 100 then
        healthStr, healthColor = Antagonist.GetPhrase(nil, "healthy"), healthyColor
    elseif health >= 50 then
        healthStr, healthColor = Antagonist.GetPhrase(nil, "minor_injuries"), minorInjuriesColor
    elseif health >= 25 then
        healthStr, healthColor = Antagonist.GetPhrase(nil, "serious_injuries"), seriousInjuriesColor
    else
        healthStr, healthColor = Antagonist.GetPhrase(nil, "critical_injuries"), criticalInjuriesColor
    end

    alpha = Lerp(math.max(0, ply.InfoDelay - CurTime()), 0, alpha)
    teamColor.a = alpha
    healthColor.a = alpha

    local pos = ply:EyePos() + Vector(0, 0, 15)
    local posY = 0

    playerAngle.y = LocalPlayer():EyeAngles().y - 90

    camStart3D2D(pos, playerAngle, 0.03)
        posY = drawInfo(ply:Nick(), posY, teamColor)
        posY = drawInfo(ply:GetRoleName(), posY, teamColor)
        posY = drawInfo(healthStr, posY, healthColor)
    camEnd3D2D()
end

timer.Create("Antagonist.HUD.Player", 1, 0, function()
    for id, ply in next, playersToDraw do
        if !IsValid(ply) or ply.InfoDelay <= CurTime() then
            playersToDraw[id] = nil
            continue
        end
    end
end)

hook.Add("PostDrawTranslucentRenderables", "Antagonist.HUD.Player", function()
    local localPlayer = LocalPlayer()
    local traceEntity = localPlayer:GetEyeTrace().Entity

    if IsValid(traceEntity) and traceEntity:IsPlayer() and traceEntity:GetPos():Distance(localPlayer:GetPos()) < 300 then
        local uid = traceEntity:UserID()
        traceEntity.InfoDelay = CurTime() + 2

        if !playersToDraw[uid] then
            playersToDraw[uid] = traceEntity
        end
    end

    textPosY = 0

    surfaceSetFont("Antagonist.PlayerInfo")
    for _, ply in next, playersToDraw do
        if !IsValid(ply) then continue end
        drawPlayerInfo(ply)
    end
end)

function GM:HUDDrawTargetID()
    return false
end
