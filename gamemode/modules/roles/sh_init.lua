Antagonist.Roles = Antagonist.Roles or {}
Antagonist.Roles.List = Antagonist.Roles.List or {}

local roleSchema = {
    name = isstring,
    color = IsColor,
    model = function(self) return isstring(self) or istable(self) end,
    description = isstring,
    weapons = istable,
    max = isnumber,
    salary = isnumber,
    customCheck = isfunction,
    customCheckFailMsg = function(self) return isstring(self) or isfunction(self) end,
}

function Antagonist.CreateRole(role)
    local valid = TLL.CheckTableValidation(roleSchema, role, "role creation")
    if !valid then return end

    local roleIndex = #Antagonist.Roles.List + 1

    table.insert(Antagonist.Roles.List, role)
    team.SetUp(roleIndex, role.name, role.color)

    if istable(role.model) then
        local models = role.model
        for i = 1, #models do
            util.PrecacheModel(models[i])
        end
    else
        util.PrecacheModel(role.model)
    end

    return roleIndex
end

function Antagonist.GetRole(index)
    return Antagonist.Roles.List[index]
end

local meta = FindMetaTable("Player")
function meta:ChangeRole(index)
    local role = Antagonist.Roles.List[i]
    if !role then return end

    if role.customCheck and !role.customCheck(self) then
        local message = isfunction(role.customCheckFailMsg) and role.customCheckFailMsg(self, role)
                            or role.customCheckFailMsg
                            or Antagonist.GetPhrase(self.Language, "unable_to_change_role", role.name)

        Antagonist.Notify(self, NOTIFY_ERROR, 5, message)
        return false
    end

    return true
end
