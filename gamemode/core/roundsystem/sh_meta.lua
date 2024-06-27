local meta = FindMetaTable("Player")

function meta:IsReady()
    return self:GetNWBool("IsReady", false)
end

function meta:ShouldSpawn()
    if not ag.round.AlreadyPlayed[self.id] and self:IsReady() then return true end
    return false
end

function meta:ResetAll()
    self:KillSilent()
    self:Spectate(OBS_MODE_ROAMING)

    self:SetFrags(0)
    self:SetTeam(TEAM_SPECTATOR)

    ag.round.AlreadyPlayed[self.id] = nil
end

local oldSpectate = meta.Spectate
function meta:Spectate(type)
    oldSpectate(self, type)

    self:SetNoTarget(true)

    if type == OBS_MODE_ROAMING then
        self:SetMoveType(MOVETYPE_NOCLIP)
    end
end

local oldSpectateEntity = meta.SpectateEntity
function meta:SpectateEntity(ent)
    self:Spectate(OBS_MODE_CHASE)
    oldSpectateEntity(self, ent)

    if IsValid(ent) and ent:IsPlayer() then
        self:SetupHands(ent)
    end
end

local oldUnSpectate = meta.UnSpectate
function meta:UnSpectate()
    oldUnSpectate(self)
    self:SetNoTarget(false)
end
