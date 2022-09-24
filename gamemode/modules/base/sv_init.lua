local mathFloor = math.floor

local voice3D = Antagonist.Config.Voice3D
local voiceRadius = Antagonist.Config.VoiceRadius
local dynamicVoice = Antagonist.Config.DynamicVoice
local deadVoice = Antagonist.Config.DeadVoice
local voiceDistance = Antagonist.Config.VoiceDistance * Antagonist.Config.VoiceDistance

local canHearPlayers = {}
local chPlayers = player.GetHumans()

-- Recreate canHearPlayers after Lua Refresh
for i = 1, #chPlayers do
    local ply = chPlayers[i]
    canHearPlayers[ply] = {}
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
    -- Note, everyone will STILL hear everyone UNLESS Antagonist.Config.voiceradius is set to true
    -- This will fix the Antagonist.Config.VoiceRadius not working
    game.ConsoleCommand("sv_alltalk 0\n")
end

function GM:PlayerDisconnected(ply)
    canHearPlayers[ply] = nil -- Clear to avoid memory leaks
end

function GM:PlayerInitialSpawn(ply)
    self.Sandbox.PlayerInitialSpawn(self, ply)

    ply:SetTeam(Antagonist.Roles.Default)

    -- Initialize canHearPlayers for player (used for voice radius check)
    canHearPlayers[ply] = {}

    timer.Simple(1, function()
        if !IsValid(ply) then return end

        local steamid = ply:SteamID()
        local group = Antagonist.Config.DefaultPlayerGroups[steamid]

        if group then
            ply:SetUserGroup(group)
        end

        ply.CommandDelays = {}
    end)
end

function GM:DoPlayerDeath(ply, attacker, dmginfo, ...)
    local weapon = ply:GetActiveWeapon()
    local canDrop = hook.Call("CanDropWeapon", self, weapon)

    if Antagonist.Config.DropWeaponDeath and weapon:IsValid() and canDrop then
        ply:DropWeapon(weapon)
    end

    self.Sandbox.DoPlayerDeath(self, ply, attacker, dmginfo, ...)
end

function GM:PlayerDeath(ply, weapon, attacker)
    ply:Extinguish()
    ply:ExitVehicle()
end

function GM:PlayerSpawnProp(ply, model)
    return Antagonist.Config.PropSpawning and self.Sandbox.PlayerSpawnProp(self, ply, model)
end

function GM:PlayerSpawnedProp(ply, model, ent)
    self.Sandbox.PlayerSpawnedProp(self, ply, model, ent)
    ent.SID = ply.SID

    if Antagonist.Config.PropCrafting then
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
local roomTrace = { output = roomTraceResult }

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

-- Grid based position check
local grid
-- Grid cell size is equal to the size of the radius of player talking
local gridSize = Antagonist.Config.VoiceDistance
-- Translate player to grid coordinates. The first table maps players to x coordinates, the second table maps players to y coordinates.
local playerToGrid = { {}, {} }

timer.Create("Antagonist.CanHearPlayersVoice", 0.3, 0, function()
    -- if VoiceRadius is off, everyone can hear everyone
    if !voiceRadius then return end

    -- Clear old values
    playerToGrid[1] = {}
    playerToGrid[2] = {}
    grid = {}

    local playerPos = {}
    local eyePos = {}

    local players = player.GetHumans()

    -- Get the grid position of every player O(N)
    for i = 1, #players do
        local ply = players[i]

        local pos = ply:GetPos()
        playerPos[ply] = pos
        eyePos[ply] = ply:EyePos()

        local x = mathFloor(pos.x / gridSize)
        local y = mathFloor(pos.y / gridSize)

        local row = grid[x] or {}
        local cell = row[y] or {}

        table.insert(cell, ply)
        row[y] = cell
        grid[x] = row

        playerToGrid[1][ply] = x
        playerToGrid[2][ply] = y

        canHearPlayers[ply] = {} -- Initialize output variable
    end

    -- Check all neighbouring cells for every player.
    -- We are only checking in 1 direction to avoid duplicate check of cells
    for i = 1, #players do
        local ply = players[i]

        local gridX = playerToGrid[1][ply]
        local gridY = playerToGrid[2][ply]
        local tempPlayerPos = playerPos[ply]
        local tempEyePos = eyePos[ply]

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
                local cellPlayer = cell[k]

                -- VoiceRadius is on and the two are within hearing distance
                -- DynamicVoice is on and players are in the same room
                local canTalk = tempPlayerPos:DistToSqr(playerPos[cellPlayer]) < voiceDistance
                                    and (!dynamicVoice or isInRoom(tempEyePos, eyePos[cellPlayer], cellPlayer))

                canHearPlayers[ply][cellPlayer] = canTalk and (deadVoice or cellPlayer:Alive())
                canHearPlayers[cellPlayer][ply] = canTalk and (deadVoice or ply:Alive()) -- Take advantage of the symmetry
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

            local cellLength = #cell
            for k = 1, cellLength do
                local ply = cell[k]

                for l = k + 1, cellLength do
                    local nextPlayer = cell[l]

                    -- VoiceRadius is on and the two are within hearing distance
                    -- DynamicVoice is on and players are in the same room
                    local canTalk = playerPos[ply]:DistToSqr(playerPos[nextPlayer]) < voiceDistance
                                        and (!dynamicVoice or isInRoom(eyePos[ply], eyePos[nextPlayer], nextPlayer))

                    canHearPlayers[ply][nextPlayer] = canTalk and (deadVoice or nextPlayer:Alive())
                    canHearPlayers[nextPlayer][ply] = canTalk and (deadVoice or ply:Alive()) -- Take advantage of the symmetry
                end
            end
        end
    end
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if !deadVoice and !talker:Alive() then return false end
    return !voiceRadius or canHearPlayers[listener][talker] == true, voice3D
end

function GM:PlayerShouldTaunt(ply, actid)
    return Antagonist.Config.AllowActs
end

function GM:PlayerSpray()
    return !Antagonist.Config.AllowSprays
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

    if Antagonist.Config.DisallowDrop[class] then return false end

    return true
end

function GM:CanProperty(ply, property, ent)
    if Antagonist.Config.AllowedProperties[property] then
        return true
    end

    if ply:IsSuperAdmin() then
        return true
    end

    return false
end

function GM:GetFallDamage(ply, fallSpeed)
    if GetConVar("mp_falldamage"):GetBool() or Antagonist.Config.RealisticFallDamage then
        return Antagonist.Config.FallDamageDamper and (fallSpeed / Antagonist.Config.FallDamageDamper) or (fallSpeed / 15)
    else
        return Antagonist.Config.FallDamageAmount or 10
    end
end
