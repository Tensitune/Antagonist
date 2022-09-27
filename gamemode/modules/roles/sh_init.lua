Antagonist.Roles = Antagonist.Roles or {}
Antagonist.Roles.List = Antagonist.Roles.List or {}

local roleSchema = {
    name = "string",
    color = IsColor,
    model = { "string", "table" },
    description = "string",
    weapons = "table",
    max = "number",
    salary = "number",
    customCheck = "function",
    customCheckFailMsg = { "string", "function" },
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
