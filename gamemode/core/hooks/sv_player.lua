local function checkAdminSpawn(ply)
    if ply:IsSuperAdmin() then return true end

    Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "need_x_privelege", Antagonist.GetPhrase(ply.Language, "sadmin")))
    return false
end

function GM:PlayerInitialSpawn(ply)
    self.Sandbox.PlayerInitialSpawn(self, ply)

    ply.ID = ply:UserID()
    ply.CommandDelays = {}

    local group = self.Config.DefaultPlayerGroups[ply:SteamID()]
    if group then
        ply:SetUserGroup(group)
    end

    hook.Run("Antagonist.PlayerInitialSpawn", ply)
end

function GM:PlayerDisconnected(ply)
    hook.Run("Antagonist.PlayerDisconnected", ply)
end

function GM:DoPlayerDeath(ply, attacker, dmginfo, ...)
    if ply:IsSpectator() then return end

    if self.Config.DropWeaponDeath then
        local playerWeapons = ply:GetWeapons()

        for i = 1, #playerWeapons do
            local weapon = playerWeapons[i]
            if hook.Call("CanDropWeapon", self, weapon) then
                ply:DropWeapon(weapon)
            end
        end
    end

    self.Sandbox.DoPlayerDeath(self, ply, attacker, dmginfo, ...)
end

-- Disable beep sound
function GM:PlayerDeathSound()
    return true
end

function GM:PlayerSpawnProp(ply, model)
    if self.Config.PropCrafting then
        Antagonist.Notify(ply, NOTIFY_ERROR, 5, Antagonist.GetPhrase(ply.Language, "not_enough_resources"))
        return false
    end

    return self.Config.PropSpawning and self.Sandbox.PlayerSpawnProp(self, ply, model)
end

function GM:PlayerSpawnedProp(ply, model, ent)
    self.Sandbox.PlayerSpawnedProp(self, ply, model, ent)
    ent.ID = ply.ID
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
