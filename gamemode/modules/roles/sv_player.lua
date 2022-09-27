local meta = FindMetaTable("Player")

function meta:ChangeRole(index)
    self:SetTeam(index)
end
