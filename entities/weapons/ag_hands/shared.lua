AddCSLuaFile()

SWEP.PrintName = "Hands"
SWEP.Author = "Tensitune"
SWEP.Instructions = "[Reload] - Toggle fists mode"

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Antagonist"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HitDistance = 48

local pushScale = GetConVar("phys_pushscale")
local swingSound = Sound("WeaponFrag.Throw")
local hitSound = Sound("Flesh.ImpactHard")

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextMeleeAttack")
    self:NetworkVar("Float", 1, "NextIdle")
    self:NetworkVar("Float", 2, "NextMode")
    self:NetworkVar("Int", 0, "Combo")
    self:NetworkVar("Bool", 0, "FistsMode")
end

function SWEP:UpdateNextIdle()
    local vm = self:GetOwner():GetViewModel()
    self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
end

function SWEP:Holster()
    if self:GetFistsMode() then
        self:ChangeMode(true)
    end

    self:SetNextMeleeAttack(0)

    return true
end

function SWEP:ShouldDrawViewModel()
    return CurTime() < self:GetNextIdle() - 0.15 or self:GetFistsMode()
end

function SWEP:PrimaryAttack(right)
    if !self:GetFistsMode() then return end

    local curTime = CurTime()
    local owner = self:GetOwner()
    local anim = self:GetCombo() >= 2 and "fists_uppercut"
                    or (right and "fists_right")
                    or "fists_left"

    owner:SetAnimation(PLAYER_ATTACK1)

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))

    self:EmitSound(swingSound)

    self:UpdateNextIdle()
    self:SetNextMeleeAttack(curTime + 0.2)
    self:SetNextPrimaryFire(curTime + 0.9)
    self:SetNextSecondaryFire(curTime + 0.9)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack(true)
end

function SWEP:Reload()
    self:ChangeMode()
    return true
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Think()
    if !self:GetFistsMode() then return end

    local curTime = CurTime()
    local idleTime = self:GetNextIdle()
    local meleeTime = self:GetNextMeleeAttack()

    local vm = self:GetOwner():GetViewModel()

    if idleTime > 0 and curTime > idleTime then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))
        self:UpdateNextIdle()
    end

    if meleeTime > 0 and curTime > meleeTime then
        self:DealDamage()
        self:SetNextMeleeAttack(0)
    end

    if SERVER and curTime > self:GetNextPrimaryFire() + 0.1 then
        self:SetCombo(0)
    end
end

function SWEP:ChangeMode(forced)
    local curTime = CurTime()
    if !forced and curTime < self:GetNextMode() then return end

    local playbackRate = 1.3
    local fistsMode = self:GetFistsMode()
    local anim = fistsMode and "fists_holster" or "fists_draw"

    local vm = self:GetOwner():GetViewModel()
    if !IsValid(vm) then return end

    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(playbackRate)

    local holdType = fistsMode and "normal" or "fist"
    self:SetHoldType(holdType)

    local animDelay = curTime + vm:SequenceDuration() / playbackRate
    self:SetNextPrimaryFire(animDelay)
    self:SetNextSecondaryFire(animDelay)

    self:SetNextMode(animDelay)
    self:SetNextMeleeAttack(0)

    self:UpdateNextIdle()

    if SERVER then
        self:SetCombo(0)
    end

    self:SetFistsMode(!fistsMode)
end

function SWEP:DealDamage()
    local owner = self:GetOwner()
    local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())

    owner:LagCompensation(true)

    local tr = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
        filter = owner,
        mask = MASK_SHOT_HULL
    })

    if !IsValid(tr.Entity) then
        tr = util.TraceHull({
            start = owner:GetShootPos(),
            endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
            filter = owner,
            mins = Vector(-10, -10, -8),
            maxs = Vector(10, 10, 8),
            mask = MASK_SHOT_HULL
        })
    end

    if tr.Hit and !(game.SinglePlayer() and CLIENT) then
        self:EmitSound(hitSound)
    end

    local hit = false
    local scale = pushScale:GetFloat()

    if SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0) then
        local dmginfo = DamageInfo()
        local attacker = owner

        if !IsValid(attacker) then attacker = self end

        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(math.random(8, 12))

        if anim == "fists_left" then
            dmginfo:SetDamageForce(owner:GetRight() * 4912 * scale + owner:GetForward() * 9998 * scale)
        elseif anim == "fists_right" then
            dmginfo:SetDamageForce(owner:GetRight() * -4912 * scale + owner:GetForward() * 9989 * scale)
        elseif anim == "fists_uppercut" then
            dmginfo:SetDamageForce(owner:GetUp() * 5158 * scale + owner:GetForward() * 10012 * scale)
            dmginfo:SetDamage(math.random(12, 24))
        end

        SuppressHostEvents(NULL)
        tr.Entity:TakeDamageInfo(dmginfo)
        SuppressHostEvents(owner)

        hit = true
    end

    if IsValid(tr.Entity) then
        local phys = tr.Entity:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceOffset(owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos)
        end
    end

    if SERVER then
        if hit and anim != "fists_uppercut" then
            self:SetCombo(self:GetCombo() + 1)
        else
            self:SetCombo(0)
        end
    end

    owner:LagCompensation(false)
end
