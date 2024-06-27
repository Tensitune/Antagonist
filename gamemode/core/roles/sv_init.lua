util.AddNetworkString("ag.role.Change")

function GM:CanChangeRole(ply, index)
    local role = ag.role.list[index]
    if !role then return end

    if role.customCheck and !role.customCheck(ply) then
        local message = isfunction(role.customCheckFailMsg) and role.customCheckFailMsg(ply, role)
                            or role.customCheckFailMsg
                            or ag.lang.GetPhrase("unable_to_change_role", role.name)

        ag.util.Notify(ply, NOTIFY_ERROR, 5, message)
        return false
    end

    return true
end

function GM:PlayerLoadout(ply)
    local role = ag.role.list[ply:Team()]
    if !(role and role.weapons) then return true end

    ply:SetSuppressPickupNotices(true)
    ply:Give("ag_hands")
    ply:SetSuppressPickupNotices(false)

    return true
end

function GM:PlayerSetModel(ply)
    local role = ag.role.list[ply:Team()]
    if !(role and role.model) then return end

    if istable(role.model) then
        local tempModel = table.Random(role.model)
        ply:SetModel(tempModel)
    else
        ply:SetModel(role.model)
    end
end

net.Receive("ag.role.Change", function(_, ply)
    local roleIndex = net.ReadInt(9)
    local canChange = gamemode.Call("CanChangeRole", ply, roleIndex)

    if !canChange then return end

    ply:SetTeam(roleIndex)
end)
