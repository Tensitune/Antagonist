ag.role = ag.role or {}
ag.role.list = ag.role.list or {}

function ag.role.Add(data)
    local roleIndex = #ag.role.list + 1

    ag.role.list[roleIndex] = data
    team.SetUp(roleIndex, data.name, data.color)

    if istable(data.model) then
        local models = data.model
        for i = 1, #models do
            util.PrecacheModel(models[i])
        end
    else
        util.PrecacheModel(data.model)
    end

    return roleIndex
end

function ag.role.Get(index)
    return ag.role.list[index]
end

local folder = GM.RootFolder .. "/core/roles"

tll.Load(folder .. "/sv_init.lua")
tll.Load(folder .. "/sh_meta.lua")
