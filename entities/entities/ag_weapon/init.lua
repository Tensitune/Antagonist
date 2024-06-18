AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:SetMass(15)
        phys:Wake()
    end
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end

function ENT:Use(activator, caller)
    if activator:KeyDown(IN_WALK) then
        if !self:IsPlayerHolding() then
            activator:PickupObject(self)
        end
        return
    end

    net.Start("ag.Radial")
    net.WriteEntity(self)
    net.Send(activator)
end

function ENT:WeaponSetClips(weapon, playerHadWeapon)
    local clip1, clip2 = self:GetClip1(), self:GetClip2()

    if playerHadWeapon and clip2 and clip2 > 0 and weapon:Clip2() != -1 then
        weapon:SetClip2(weapon:Clip2() + clip2)
        clip2 = 0
    elseif clip1 and clip1 != -1 and weapon:Clip1() != -1 then
        weapon:SetClip1(clip1)
        clip1 = 0
    elseif clip2 and clip2 != -1 and weapon:Clip2() != -1 then
        weapon:SetClip2(clip2)
        clip2 = 0
    end
end

function ENT:PickUp(ply)
    local class = self:GetWeaponClass()
    local weapon = ply:GiveAGWeapon(class, true)
    local plyHadWeapon = !IsValid(weapon)

    weapon = plyHadWeapon and ply:GetWeapon(class) or weapon

    self:WeaponSetClips(weapon, plyHadWeapon)
    self:Remove()

    ply:UpdateItem(SLOT_HANDS, {
        clip1 = weapon:Clip1(),
        clip2 = weapon:Clip2()
    })

    ply:EmitSound("items/ammo_pickup.wav", 80, 100, 1)
end

function ENT:Unload(ply)
    local primaryAmmoType = self:GetPrimaryAmmoType()

    if primaryAmmoType > 0 then
        local primaryAmmo = self:GetClip1() or 0

        ply:GiveAmmo(primaryAmmo, primaryAmmoType)
        self:SetClip1(0)
    end

    ply:EmitSound("items/ammo_pickup.wav", 80, 100, 1)
end
