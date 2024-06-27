local math_floor = math.floor

local voice3D = ag.config.voice3D
local voiceRadius = ag.config.voiceRadius
local dynamicVoice = ag.config.dynamicVoice
local deadVoice = ag.config.deadVoice
local voiceDistance = ag.config.voiceDistance * ag.config.voiceDistance

local grid -- Grid based position check
local gridSize = ag.config.voiceDistance -- Grid cell size is equal to the size of the radius of player talking
-- Translate player to grid coordinates. The first table maps players to x coordinates, the second table maps players to y coordinates.
local playerToGrid = {{}, {}}

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

local canHearPlayers, humans = {}, player.GetHumans()

for i = 1, #humans do -- Recreate canHearPlayers after Lua Refresh
    canHearPlayers[humans[i].id] = {}
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if !deadVoice and !talker:Alive() then return false end
    return !voiceRadius or canHearPlayers[listener.id][talker.id] == true, voice3D
end

function GM:PlayerVoiceInit(ply)
    canHearPlayers[ply.id] = {} -- Initialize canHearPlayers for player (used for voice radius check)
end

function GM:PlayerVoiceDisconnect(ply)
    canHearPlayers[ply.id] = nil -- Clear to avoid memory leaks
end

timer.Create("ag.Voice", 0.3, 0, function()
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

        local x = math_floor(pos.x / gridSize)
        local y = math_floor(pos.y / gridSize)

        local row = grid[x] or {}
        local cell = row[y] or {}

        cell[#cell + 1] = ply
        row[y] = cell
        grid[x] = row

        playerToGrid[1][ply.id] = x
        playerToGrid[2][ply.id] = y

        canHearPlayers[ply.id] = {} -- Initialize output variable
    end

    -- Check all neighbouring cells for every player.
    -- We are only checking in 1 direction to avoid duplicate check of cells
    for i = 1, #players do
        local ply = players[i]

        local gridX = playerToGrid[1][ply.id]
        local gridY = playerToGrid[2][ply.id]
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

                canHearPlayers[ply.id][cellPly.id] = canTalk and (deadVoice or cellPly:Alive())
                canHearPlayers[cellPly.id][ply.id] = canTalk and (deadVoice or alive) -- Take advantage of the symmetry
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

                canHearPlayers[prevPly.id][ply.id] = canTalk and (deadVoice or ply:Alive())
                canHearPlayers[ply.id][prevPly.id] = canTalk and (deadVoice or prevPly:Alive()) -- Take advantage of the symmetry
            end
        end
    end
end)
