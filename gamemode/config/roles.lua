Antagonist.Roles.List = {} -- Clear roles list after Lua Refresh

--[[-------------------------------------------------------------------------
Civilian roles
-----------------------------------------------------------------------------]]
ROLE_CIVILIAN = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_civilian"),
    color = Color(0, 210, 0),
    model = "models/player/group01/male_01.mdl",
    description = Antagonist.GetPhrase(nil, "role_civilian_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_COOK = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_cook"),
    color = Color(210, 210, 210),
    model = "models/player/mossman.mdl",
    description = Antagonist.GetPhrase(nil, "role_cook_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_BARTENDER = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_bartender"),
    color = Color(210, 210, 0),
    model = "models/player/t_leet.mdl",
    description = Antagonist.GetPhrase(nil, "role_bartender_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_BANKER = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_banker"),
    color = Color(0, 150, 210),
    model = "models/player/odessa.mdl",
    description = Antagonist.GetPhrase(nil, "role_banker_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_MINER = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_miner"),
    color = Color(210, 150, 0),
    model = "models/player/t_guerilla.mdl",
    description = Antagonist.GetPhrase(nil, "role_miner_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_CHAPLAIN = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_chaplain"),
    color = Color(150, 210, 0),
    model = "models/player/monk.mdl",
    description = Antagonist.GetPhrase(nil, "role_chaplain_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_BOTANIST = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_botanist"),
    color = Color(175, 210, 0),
    model = "models/player/eli.mdl",
    description = Antagonist.GetPhrase(nil, "role_botanist_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_ACTOR = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_actor"),
    color = Color(210, 0, 210),
    model = "models/player/corpse1.mdl",
    description = Antagonist.GetPhrase(nil, "role_actor_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_MEDIC = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_medic"),
    color = Color(0, 210, 210),
    model = "models/player/kleiner.mdl",
    description = Antagonist.GetPhrase(nil, "role_medic_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

--[[-------------------------------------------------------------------------
Cops roles
-----------------------------------------------------------------------------]]
ROLE_POLICE = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_police"),
    color = Color(210, 0, 100),
    model = "models/player/police.mdl",
    description = Antagonist.GetPhrase(nil, "role_police_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

--[[-------------------------------------------------------------------------
Command roles
-----------------------------------------------------------------------------]]
ROLE_HOC = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_hoc"),
    color = Color(0, 0, 210),
    model = "models/player/breen.mdl",
    description = Antagonist.GetPhrase(nil, "role_hoc_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_HOP = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_hop"),
    color = Color(0, 120, 210),
    model = "models/player/magnusson.mdl",
    description = Antagonist.GetPhrase(nil, "role_hop_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_HOS = Antagonist.CreateRole({
    name = Antagonist.GetPhrase(nil, "role_hos"),
    color = Color(210, 0, 0),
    model = "models/player/barney.mdl",
    description = Antagonist.GetPhrase(nil, "role_hos_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

Antagonist.Roles.Default = ROLE_CIVILIAN
Antagonist.Roles.Police = {
    [ROLE_POLICE] = true,
    [ROLE_HOS] = true,
}
