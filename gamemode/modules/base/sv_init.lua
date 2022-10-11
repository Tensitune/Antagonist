local mathFloor = math.floor

local voice3D = GM.Config.Voice3D
local voiceRadius = GM.Config.VoiceRadius
local dynamicVoice = GM.Config.DynamicVoice
local deadVoice = GM.Config.DeadVoice
local voiceDistance = GM.Config.VoiceDistance * GM.Config.VoiceDistance

local canHearPlayers = {}
local chPlayers = player.GetHumans()

-- Recreate canHearPlayers after Lua Refresh
for i = 1, #chPlayers do
    canHearPlayers[chPlayers[i].ID] = {}
end

function GM:Initialize()
    self.Sandbox.Initialize(self)
end

function GM:InitPostEntity()
    local physData = physenv.GetPerformanceSettings()
    physData.MaxVelocity = 2000
    physData.MaxAngularVelocity = 3636

    physenv.SetPerformanceSettings(physData)

    game.ConsoleCommand("physgun_DampingFactor 0.9\n")
    game.ConsoleCommand("sv_sticktoground 0\n")
    game.ConsoleCommand("sv_airaccelerate 1000\n")
    -- sv_alltalk must be 0
    -- Note, everyone will STILL hear everyone UNLESS GM.Config.voiceradius is set to true
    -- This will fix the GM.Config.VoiceRadius not working
    game.ConsoleCommand("sv_alltalk 0\n")
end

function GM:PlayerDisconnected(ply)
    canHearPlayers[ply.ID] = nil -- Clear to avoid memory leaks
end

function GM:PlayerInitialSpawn(ply)
    self.Sandbox.PlayerInitialSpawn(self, ply)

    ply.ID = ply:UserID()

    ply:SetTeam(Antagonist.Roles.Default)

    -- Initialize canHearPlayers for player (used for voice radius check)
    canHearPlayers[ply.ID] = {}

    timer.Simple(1, function()
        if !IsValid(ply) then return end

        local steamid = ply:SteamID()
        local group = self.Config.DefaultPlayerGroups[steamid]

        if group then
            ply:SetUserGroup(group)
        end

        ply.CommandDelays = {}
    end)
end

function GM:DoPlayerDeath(ply, attacker, dmginfo, ...)
    local weapon = ply:GetActiveWeapon()
    local canDrop = hook.Call("CanDropWeapon", self, weapon)

    if self.Config.DropWeaponDeath and weapon:IsValid() and canDrop then
        ply:DropWeapon(weapon)
    end

    self.Sandbox.DoPlayerDeath(self, ply, attacker, dmginfo, ...)
end

function GM:PlayerDeath(ply, weapon, attacker)
    ply:Extinguish()
    ply:ExitVehicle()
end

function GM:PlayerSpawnProp(ply, model)
    return self.Config.PropSpawning and self.Sandbox.PlayerSpawnProp(self, ply, model)
end

function GM:PlayerSpawnedProp(ply, model, ent)
    self.Sandbox.PlayerSpawnedProp(self, ply, model, ent)
    ent.SID = ply.SID

    if self.Config.PropCrafting then
        Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "not_enough_resources"))

        SafeRemoveEntity(ent)
        return false
    end
end

local function checkAdminSpawn(ply)
    if ply:IsSuperAdmin() then return true end

    Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "need_x_privelege", Antagonist.GetPhrase(ply.Language, "sadmin")))
    return false
end

function GM:PlayerSpawnSWEP(ply, class, info)
    return checkAdminSpawn(ply) and self.Sandbox.PlayerSpawnSWEP(self, ply, class, info)
end

function GM:PlayerGiveSWEP(ply, class, info)
    return checkAdminSpawn(ply) and self.Sandbox.PlayerGiveSWEP(self, ply, class, info)
end

function GM:PlayerSpawnEffect(ply, model)
    return checkAdminSpawn(ply) and self.Sandbox.PlayerSpawnEffect(self, ply, model)
end

function GM:PlayerSpawnVehicle(ply, model, class, info)
    return checkAdminSpawn(ply) and self.Sandbox.PlayerSpawnVehicle(self, ply, model, class, info)
end

function GM:PlayerSpawnNPC(ply, type, weapon)
    return checkAdminSpawn(ply) and self.Sandbox.PlayerSpawnNPC(self, ply, type, weapon)
end

function GM:PlayerSpawnRagdoll(ply, model)
    return checkAdminSpawn(ply) and self.Sandbox.PlayerSpawnRagdoll(self, ply, model)
end

function GM:ShowSpare1(ply)
end

function GM:ShowSpare2(ply)
end

function GM:ShowTeam(ply)
end

function GM:ShowHelp(ply)
end

function GM:KeyPress(ply, code)
    self.Sandbox.KeyPress(self, ply, code)
end

local roomTraceResult = {}
local roomTrace = {
    output = roomTraceResult
}

-- isInRoom function to see if the player is in the same room.
local function isInRoom(listenerShootPos, talkerShootPos, talker)
    roomTrace.start = talkerShootPos
    roomTrace.endpos = listenerShootPos
    roomTrace.filter = talker -- Listener needs not be ignored as that's the end of the trace
    roomTrace.collisiongroup = COLLISION_GROUP_WORLD
    roomTrace.mask = MASK_SOLID_BRUSHONLY

    util.TraceLine(roomTrace)

    return !roomTraceResult.HitWorld
end

local grid -- Grid based position check
local gridSize = GM.Config.VoiceDistance -- Grid cell size is equal to the size of the radius of player talking
-- Translate player to grid coordinates. The first table maps players to x coordinates, the second table maps players to y coordinates.
local playerToGrid = {{}, {}}

timer.Create("Antagonist.CanHearPlayersVoice", 0.3, 0, function()
    -- if VoiceRadius is off, everyone can hear everyone
    if !voiceRadius then return end

    -- Clear old values
    playerToGrid[1] = {}
    playerToGrid[2] = {}
    grid = {}

    local players = player.GetHumans()

    -- Get the grid position of every player O(N)
    for i = 1, #players do
        local ply = players[i]
        local pos = ply:GetPos()

        local x = mathFloor(pos.x / gridSize)
        local y = mathFloor(pos.y / gridSize)

        local row = grid[x] or {}
        local cell = row[y] or {}

        cell[#cell + 1] = ply
        row[y] = cell
        grid[x] = row

        playerToGrid[1][ply.ID] = x
        playerToGrid[2][ply.ID] = y

        canHearPlayers[ply.ID] = {} -- Initialize output variable
    end

    -- Check all neighbouring cells for every player.
    -- We are only checking in 1 direction to avoid duplicate check of cells
    for i = 1, #players do
        local ply = players[i]

        local gridX = playerToGrid[1][ply.ID]
        local gridY = playerToGrid[2][ply.ID]
        local pos = ply:GetPos()
        local eyePos = ply:EyePos()
        local alive = ply:Alive()

        for j = 0, 3 do
            local vOffset = 1 - ((j >= 3) and 1 or 0)
            local hOffset = -(j % 2)
            local x = gridX + hOffset
            local y = gridY + vOffset

            local row = grid[x]
            if !row then continue end

            local cell = row[y]
            if !cell then continue end

            for k = 1, #cell do
                local cellPly = cell[k]

                -- VoiceRadius is on and the two are within hearing distance
                -- DynamicVoice is on and players are in the same room
                local canTalk = pos:DistToSqr(cellPly:GetPos()) < voiceDistance
                                    and (!dynamicVoice or isInRoom(eyePos, cellPly:EyePos(), cellPly))

                canHearPlayers[ply.ID][cellPly.ID] = canTalk and (deadVoice or cellPly:Alive())
                canHearPlayers[cellPly.ID][ply.ID] = canTalk and (deadVoice or alive) -- Take advantage of the symmetry
            end
        end
    end

    -- Doing a pass-through inside every cell to compute the interactions inside of the cells.
    -- Each grid check is O(N(N+1)/2) where N is the number of players inside the cell.
    for i = 1, #grid do
        local row = grid[i]
        if !row then continue end

        for j = 1, #row do
            local cell = row[j]
            if !cell then continue end

            for k = 2, #cell do
                local prevPly = cell[k - 1]
                local ply = cell[k]

                -- VoiceRadius is on and the two are within hearing distance
                -- DynamicVoice is on and players are in the same room
                local canTalk = prevPly:GetPos():DistToSqr(ply:GetPos()) < voiceDistance
                                    and (!dynamicVoice or isInRoom(prevPly:EyePos(), ply:EyePos(), ply))

                canHearPlayers[prevPly.ID][ply.ID] = canTalk and (deadVoice or ply:Alive())
                canHearPlayers[ply.ID][prevPly.ID] = canTalk and (deadVoice or prevPly:Alive()) -- Take advantage of the symmetry
            end
        end
    end
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if !deadVoice and !talker:Alive() then return false end
    return !voiceRadius or canHearPlayers[listener.ID][talker.ID] == true, voice3D
end

function GM:PlayerShouldTaunt(ply, actid)
    return self.Config.AllowActs
end

function GM:PlayerSpray()
    return !self.Config.AllowSprays
end

function GM:CanTool(ply, trace, mode)
    if !self.Sandbox.CanTool(self, ply, trace, mode) then return false end

    local ent = trace.Entity
    if IsValid(ent) then
        if ent.onlyremover then
            if mode == "remover" then
                return ply:IsAdmin() or ply:IsSuperAdmin()
            else
                return false
            end
        end

        if ent.nodupe and (mode == "weld" or mode == "weld_ez" or mode == "spawner" or mode == "duplicator" or mode == "adv_duplicator") then
            return false
        end

        if ent:IsVehicle() and mode == "nocollide" then
            return false
        end
    end
    return true
end

function GM:CanDrive(ply, ent)
    return false
end

function GM:CanDropWeapon(weapon)
    if !IsValid(weapon) then return false end

    local class = string.lower(weapon:GetClass())
    if self.Config.DisallowDrop[class] then return false end

    return true
end

function GM:CanProperty(ply, property, ent)
    if self.Config.AllowedProperties[property] then return true end
    if ply:IsSuperAdmin() then return true end

    return false
end

function GM:GetFallDamage(ply, fallSpeed)
    if GetConVar("mp_falldamage"):GetBool() or self.Config.RealisticFallDamage then
        return self.Config.FallDamageDamper and (fallSpeed / self.Config.FallDamageDamper) or (fallSpeed / 15)
    else
        return self.Config.FallDamageAmount or 10
    end
end
