util.AddNetworkString("Antagonist.Roles")

net.Receive("Antagonist.Roles", function(_, ply)
    local roleIndex = net.ReadInt(9)
    local canChange = gamemode.Call("CanChangeRole", ply, roleIndex)

    if !canChange then return end

    ply:SetTeam(roleIndex)
end)

function GM:CanChangeRole(ply, index)
    local role = Antagonist.Roles.List[index]
    if !role then return end

    if role.customCheck and !role.customCheck(ply) then
        local message = isfunction(role.customCheckFailMsg) and role.customCheckFailMsg(ply, role)
                            or role.customCheckFailMsg
                            or Antagonist.GetPhrase(ply.Language, "unable_to_change_role", role.name)

        Antagonist.Notify(ply, NOTIFY_ERROR, 5, message)
        return false
    end

    return true
end

hook.Add("Antagonist.PlayerInitialSpawn", "Antagonist.Roles", function(ply)
    ply:SetTeam(Antagonist.Roles.Default)
end)
