local meta = FindMetaTable("Player")

function meta:IsSpectator()
    return self:Team() == TEAM_SPECTATOR
end

function meta:GetRoleName()
    return team.GetName(self:Team()) or "Unknown"
end

if SERVER then return end

function meta:ChangeRole(index)
    net.Start("ag.role.Change")
    net.WriteInt(index, 9)
    net.SendToServer()
end
