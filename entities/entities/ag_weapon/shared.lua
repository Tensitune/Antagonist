ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Antagonist Weapon"
ENT.Author = "Tensitune"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "WeaponClass")
    self:NetworkVar("Int", 0, "PrimaryAmmoType")
    self:NetworkVar("Int", 1, "SecondaryAmmoType")
    self:NetworkVar("Int", 2, "Clip1")
    self:NetworkVar("Int", 3, "Clip2")
end
