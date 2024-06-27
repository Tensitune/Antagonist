ag.inventory.itemList = ag.inventory.itemList or {}
ag.inventory.players = ag.inventory.players or {}

util.AddNetworkString("ag.ActionWeapon")
util.AddNetworkString("ag.GetInventory")
util.AddNetworkString("ag.InventoryDropItem")

function ag.util.PlaceEntity(ent, tr, ply)
    if IsValid(ply) then
        local ang = ply:EyeAngles()
        ang.pitch = 0
        ang.yaw = ang.yaw + 180
        ang.roll = 0
        ent:SetAngles(ang)
    end

    local vFlushPoint = tr.HitPos - (tr.HitNormal * 512)
    vFlushPoint = ent:NearestPoint(vFlushPoint)
    vFlushPoint = ent:GetPos() - vFlushPoint
    vFlushPoint = tr.HitPos + vFlushPoint
    ent:SetPos(vFlushPoint)
end

function ag.util.CreateWeapon(ply, data)
    local validModel = (data.model == "models/weapons/v_physcannon.mdl" and "models/weapons/w_physics.mdl") or data.model
    validModel = util.IsValidModel(data.model) and data.model or "models/weapons/w_357.mdl"

    local ent = ents.Create("ag_weapon")
    ent:SetModel(validModel)
    ent:SetSkin(data.skin)
    ent:SetWeaponClass(data.class)
    ent:SetPrimaryAmmoType(data.primaryAmmoType)
    ent:SetSecondaryAmmoType(data.secondaryAmmoType)
    ent:SetClip1(data.clip1)
    ent:SetClip2(data.clip2)
    ent.nodupe = true

    local trace = {}
    trace.start = ply:GetShootPos()
    trace.endpos = trace.start + ply:GetAimVector() * 50
    trace.filter = { ply, ent }

    ag.util.PlaceEntity(ent, util.TraceLine(trace), ply)
    ent:Spawn()

    return ent
end

function ag.inventory.AddItem(name, data)
    ag.inventory.itemList[name] = data
end

function ag.inventory.RemoveItem(name)
    ag.inventory.itemList[name] = nil
end

function ag.inventory.GetItem(class)
    return ag.inventory.itemList[class]
end

function ag.inventory.GetItems()
    return ag.inventory.itemList
end

function GM:PlayerCanPickupWeapon(ply, weapon)
    if weapon:GetClass() == "ag_hands" then return true end

    if !ply:SlotIsEmpty(SLOT_HANDS) then
        if !IsValid(ply:GetActiveWeapon()) then
            ply:TakeItem(SLOT_HANDS)
        else
            ply:DropItem(SLOT_HANDS)
            return true
        end
    end

    return true
end

function GM:PlayerCanPickupItem()
    return true
end

function GM:PlayerInventoryInit(ply)
    ag.inventory.players[ply.id] = {}

    for slotID, slot in next, ag.inventory.slots do
        ag.inventory.players[ply.id][slotID] = { name = slot, item = {} }
    end
end

function GM:PlayerInventoryDisconnect(ply)
    ag.inventory.players[ply.id] = nil
end

hook.Add("KeyPress", "ag.Inventory", function(ply, key)
    if key == IN_ZOOM then
        ply:DropAGWeapon(ply:GetActiveWeapon())
    end
end)

local actionDelay = 0
net.Receive("ag.ActionWeapon", function(_, ply)
    if actionDelay > CurTime() then return end

    local weapon = net.ReadEntity()

    if !(IsValid(weapon) and weapon:GetClass() == "ag_weapon") then return end
    if !ag.util.PlayerNearEntity(ply, weapon, 75) then return end

    local action = net.ReadInt(4)

    if action == ACTION_PICKUP_WEAPON then
        weapon:PickUp(ply)
    elseif action == ACTION_UNLOAD_WEAPON then
        weapon:Unload(ply)
    end

    actionDelay = CurTime() + 0.3
end)

net.Receive("ag.GetInventory", function(_, ply)
    local jsonInventoryData = util.TableToJSON(ag.inventory.players[ply.id])

    net.Start("ag.GetInventory")
    net.WriteString(jsonInventoryData)
    net.Send(ply)
end)

local dropItemDelay = 0
net.Receive("ag.InventoryDropItem", function(_, ply)
    if dropItemDelay > CurTime() then return end

    local slot = net.ReadInt(5)
    if slot == -1 then return end

    ply:DropItem(slot)

    dropItemDelay = CurTime() + 0.3
end)


--[[---------------------------------------------------------------------------
Required items
---------------------------------------------------------------------------]]
ag.inventory.AddItem("ag_weapon", {
    slots = { SLOT_HANDS, SLOT_BACK },
    isWeapon = true,
})
