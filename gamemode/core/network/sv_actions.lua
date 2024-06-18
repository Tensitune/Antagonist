util.AddNetworkString("ag.ActionWeapon")

net.Receive("ag.ActionWeapon", function(_, ply)
    local weapon = net.ReadEntity()

    if !(IsValid(weapon) and weapon:GetClass() == "ag_weapon") then return end
    if !ag.util.PlayerNearEntity(ply, weapon, 75) then return end

    local action = net.ReadInt(4)

    if action == ACTION_PICKUP_WEAPON then
        weapon:PickUp(ply)
    elseif action == ACTION_UNLOAD_WEAPON then
        weapon:Unload(ply)
    end
end)
