local meta = FindMetaTable("Player")

function meta:IsUnarmed()
    return self:HasWeapon("ag_hands")
end
