local function checkAdminSpawn(ply)
    if ply:IsSuperAdmin() then return true end

    ag.util.Notify(ply, NOTIFY_ERROR, 5, ag.lang.GetPhrase("need_x_privelege", ag.lang.GetPhrase("sadmin")))
    return false
end

-- function GM:KeyPress(ply, code)
--     self.Sandbox.KeyPress(self, ply, code)

--     if code == IN_ATTACK then
--         local target = table.Random(ag.util.GetPlayers(PLAYER_TYPE_ALIVE))
--         if target == ply then return end

--         ply:SpectateEntity(target)
--     elseif code == IN_ATTACK2 then
--         ply:Spectate(OBS_MODE_ROAMING)
--     end
-- end

function GM:PlayerInitialSpawn(ply)
    ply.id = ply:UserID()
    ply.commandDelays = {}

    local group = ag.config.defaultPlayerGroups[ply:SteamID()]
    if group then
        ply:SetUserGroup(group)
    end

    ply:SetTeam(ag.role.default)

    hook.Call("PlayerVoiceInit", self, ply)
    hook.Call("PlayerInventoryInit", self, ply)

    -- ply:SetTeam(TEAM_SPECTATOR)
    -- ply:KillSilent()
    -- ply:Spectate(OBS_MODE_IN_EYE)
end

function GM:PlayerSpawn(ply)
    -- ply:UnSpectate()

    -- if ply:IsSpectator() then
    --     ply:StripWeapons()
    --     ply:StripAmmo()
    --     ply:Spectate(OBS_MODE_ROAMING)
    --     return
    -- end

    hook.Call("PlayerLoadout", self, ply)
    hook.Call("PlayerSetModel", self, ply)

    ply:SetupHands()

    ply:SetCanZoom(false)
    ply:SetJumpPower(160)
    ply:SetCrouchedWalkSpeed(0.4)
    ply:SetWalkSpeed(180)
    ply:SetRunSpeed(320)
    ply:SetMaxSpeed(320)
end

function GM:PlayerDeath(victim, inflictor, attacker)
    hook.Call("PlayerInventoryInit", self, victim)

    victim:Freeze(false)
    victim:Flashlight(false)
    victim:Extinguish()
    victim:ExitVehicle()
end

function GM:DoPlayerDeath(ply, attacker, dmginfo, ...)
    if ply:IsSpectator() then return end

    if ag.config.dropWeaponDeath then
        hook.Call("DropWeapon", self, ply)
    end

    hook.Call("PlayerInventoryInit", self, ply)

    self.Sandbox.DoPlayerDeath(self, ply, attacker, dmginfo, ...)
end

function GM:PlayerDisconnected(ply)
    hook.Call("PlayerVoiceDisconnect", self, ply)
    hook.Call("PlayerInventoryDisconnect", self, ply)
end


function GM:PlayerDeathSound()
    return true
end

function GM:PlayerSpawnProp(ply, model)
    if ag.config.propCrafting then
        ag.util.Notify(ply, NOTIFY_ERROR, 5, ag.lang.GetPhrase("not_enough_resources"))
        return false
    end

    return ag.config.propSpawning and self.Sandbox.PlayerSpawnProp(self, ply, model)
end

function GM:PlayerSpawnedProp(ply, model, ent)
    self.Sandbox.PlayerSpawnedProp(self, ply, model, ent)
    ent.id = ply.id
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
    return ag.config.allowActs
end

function GM:PlayerSpray()
    return !ag.config.allowSprays
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
    if ag.config.disallowDrop[class] then return false end

    return true
end

function GM:CanProperty(ply, property, ent)
    if ag.config.allowedProperties[property] then return true end
    if ply:IsSuperAdmin() then return true end

    return false
end

function GM:GetFallDamage(ply, fallSpeed)
    if GetConVar("mp_falldamage"):GetBool() or ag.config.realisticFallDamage then
        return ag.config.fallDamageDamper and (fallSpeed / ag.config.fallDamageDamper) or (fallSpeed / 15)
    else
        return ag.config.fallDamageAmount or 10
    end
end
