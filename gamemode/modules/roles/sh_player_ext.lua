local meta = FindMetaTable("Player")

function meta:IsSpectator()
    return self:Team() == TEAM_SPECTATOR
end

function meta:GetRoleName()
    return team.GetName(self:Team()) or "Unknown"
end
