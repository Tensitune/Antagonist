local meta = FindMetaTable("Player")
meta.OldGive = !meta.OldGive and meta.Give or meta.OldGive

function meta:Strip()
    self:StripWeapons()

    self:SetSuppressPickupNotices(true)
    self:OldGive("ag_hands")
    self:SetSuppressPickupNotices(false)
end

function meta:GiveItem(class, additionalData)
    local item = ag.inventory.GetItem(class)
    if !item then return false end

    item.class = class
    item.data = {}

    if additionalData != nil and !table.IsEmpty(additionalData) then
        for k, v in next, additionalData do
            item.data[k] = v
        end
    end

    local itemSlot

    for i = 1, #item.slots do
        local slot = item.slots[i]
        if slot == nil then continue end

        if self:SlotIsEmpty(slot) then
            itemSlot = slot
            break
        end
    end

    if !itemSlot then return false end

    ag.inventory.players[self.id][itemSlot].item = item

    return true
end

function meta:MoveItem(firstSlot, secondSlot)
    if ag.inventory.slots[firstSlot] == nil or ag.inventory.slots[secondSlot] == nil then return end
    if self:SlotIsEmpty(firstSlot) then return end

    local firstItem, secondItem = self:GetItem(firstSlot), self:GetItem(secondSlot)
    local itemHasMoved = false

    if self:SlotIsEmpty(secondSlot) and table.HasValue(firstItem.slots, secondSlot) then
        ag.inventory.players[self.id][firstSlot].item = {}
        ag.inventory.players[self.id][secondSlot].item = firstItem

        itemHasMoved = true
    elseif table.HasValue(firstItem.slots, secondSlot) and table.HasValue(secondItem.slots, firstSlot) then
        ag.inventory.players[self.id][firstSlot].item = secondItem
        ag.inventory.players[self.id][secondSlot].item = firstItem

        itemHasMoved = true
    end

    if !itemHasMoved then return end

    if firstSlot == SLOT_HANDS and secondSlot != SLOT_HANDS then
        local activeWeapon = self:GetActiveWeapon()

        if IsValid(activeWeapon) then
            self:UpdateItem(secondSlot, {
                clip1 = activeWeapon:Clip1(),
                clip2 = activeWeapon:Clip2()
            })
        end

        self:Strip()
    end

    if secondSlot == SLOT_HANDS and firstSlot != SLOT_HANDS then
        self:StripWeapons()

        local weapon = self:Give(firstItem.data.class, true)
        weapon:SetClip1(firstItem.data.clip1)
        weapon:SetClip2(firstItem.data.clip2)
    end
end

function meta:GetItem(slot)
    if ag.inventory.slots[slot] == nil then return false end
    return ag.inventory.players[self.id][slot].item
end

function meta:UpdateItem(slot, data)
    if self:SlotIsEmpty(slot) then return end

    for k, v in next, data do
        ag.inventory.players[self.id][slot].item.data[k] = v
    end
end

function meta:TakeItem(slot)
    if ag.inventory.slots[slot] == nil then return end
    ag.inventory.players[self.id][slot].item = {}
end

function meta:DropItem(slot)
    if self:SlotIsEmpty(slot) then return end

    local item = self:GetItem(slot)

    if item.isWeapon then
        if slot == SLOT_HANDS then
            self:DropAGWeapon(self:GetActiveWeapon())
        else
            local weapon = ag.util.CreateWeapon(self, item.data)
            weapon:SetClip1(item.data.clip1)
            weapon:SetClip2(item.data.clip2)
        end
    end

    ag.inventory.players[self.id][slot].item = {}
end

function meta:SlotIsEmpty(slot)
    local item = self:GetItem(slot)
    return item and table.IsEmpty(item) or true
end

function meta:Give(class, bNoAmmo)
    return self:GiveAGWeapon(class, bNoAmmo)
end

function meta:GiveAGWeapon(class, bNoAmmo)
    if self:IsUnarmed() then
        self:StripWeapons()
    else
        self:DropAGWeapon(self:GetActiveWeapon(), true)
    end

    local weapon = self:OldGive(class, isbool(bNoAmmo) and bNoAmmo or false)
    self:SelectWeapon(weapon)

    if class != "ag_hands" then
        self:GiveItem("ag_weapon", {
            class = class,
            model = weapon:GetModel(),
            skin = weapon:GetSkin() or 0,
            primaryAmmoType = weapon:GetPrimaryAmmoType(),
            secondaryAmmoType = weapon:GetSecondaryAmmoType(),
            clip1 = weapon:Clip1(),
            clip2 = weapon:Clip2()
        })
    end

    return weapon
end

function meta:DropAGWeapon(weapon, noStrip)
    self:TakeItem(SLOT_HANDS)

    if !IsValid(weapon) or weapon:GetClass() == "ag_hands" then return nil end

    self:DropWeapon(weapon)
    weapon:SetOwner(self)

    if !noStrip then
        self:Strip()
    end

    local entity = ag.util.CreateWeapon(self, {
        class = weapon:GetClass(),
        model = weapon:GetModel(),
        skin = weapon:GetSkin() or 0,
        primaryAmmoType = weapon:GetPrimaryAmmoType(),
        secondaryAmmoType = weapon:GetSecondaryAmmoType(),
        clip1 = weapon:Clip1(),
        clip2 = weapon:Clip2()
    })

    weapon:Remove()

    return entity
end
