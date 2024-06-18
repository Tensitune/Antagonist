local meta = FindMetaTable("Player")
local vectorLength2D = FindMetaTable("Vector").Length2D

function meta:IsUnarmed()
    return self:HasWeapon("ag_hands")
end

function meta:IsRunning()
    return self:IsOnGround() and vectorLength2D(self:GetVelocity()) > (self:GetWalkSpeed() + 20)
end

function meta:IsUnderwater()
    return self:WaterLevel() > 2
end

function meta:IsFemale()
    local model = self:GetModel():lower()
    return (model:find("female") or model:find("alyx") or model:find("mossman")) != nil
end

function meta:IsStuck()
    return util.TraceEntity({
        start = self:GetPos(),
        endpos = self:GetPos(),
        filter = self
    }, self).StartSolid
end
