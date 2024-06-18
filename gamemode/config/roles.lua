ag.role.list = {} -- Clear role list after Lua Refresh

--[[-------------------------------------------------------------------------
Civilian roles
-----------------------------------------------------------------------------]]
ROLE_CIVILIAN = ag.role.Add({
    name = ag.lang.GetPhrase("role_civilian"),
    color = Color(0, 210, 0),
    model = "models/player/group01/male_01.mdl",
    description = ag.lang.GetPhrase("role_civilian_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_COOK = ag.role.Add({
    name = ag.lang.GetPhrase("role_cook"),
    color = Color(210, 210, 210),
    model = "models/player/mossman.mdl",
    description = ag.lang.GetPhrase("role_cook_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_BARTENDER = ag.role.Add({
    name = ag.lang.GetPhrase("role_bartender"),
    color = Color(210, 210, 0),
    model = "models/player/t_leet.mdl",
    description = ag.lang.GetPhrase("role_bartender_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_BANKER = ag.role.Add({
    name = ag.lang.GetPhrase("role_banker"),
    color = Color(0, 150, 210),
    model = "models/player/odessa.mdl",
    description = ag.lang.GetPhrase("role_banker_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_MINER = ag.role.Add({
    name = ag.lang.GetPhrase("role_miner"),
    color = Color(210, 150, 0),
    model = "models/player/t_guerilla.mdl",
    description = ag.lang.GetPhrase("role_miner_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_CHAPLAIN = ag.role.Add({
    name = ag.lang.GetPhrase("role_chaplain"),
    color = Color(150, 210, 0),
    model = "models/player/monk.mdl",
    description = ag.lang.GetPhrase("role_chaplain_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_BOTANIST = ag.role.Add({
    name = ag.lang.GetPhrase("role_botanist"),
    color = Color(175, 210, 0),
    model = "models/player/eli.mdl",
    description = ag.lang.GetPhrase("role_botanist_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_ACTOR = ag.role.Add({
    name = ag.lang.GetPhrase("role_actor"),
    color = Color(210, 0, 210),
    model = "models/player/corpse1.mdl",
    description = ag.lang.GetPhrase("role_actor_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_MEDIC = ag.role.Add({
    name = ag.lang.GetPhrase("role_medic"),
    color = Color(0, 210, 210),
    model = "models/player/kleiner.mdl",
    description = ag.lang.GetPhrase("role_medic_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

--[[-------------------------------------------------------------------------
Cops roles
-----------------------------------------------------------------------------]]
ROLE_POLICE = ag.role.Add({
    name = ag.lang.GetPhrase("role_police"),
    color = Color(210, 0, 100),
    model = "models/player/police.mdl",
    description = ag.lang.GetPhrase("role_police_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

--[[-------------------------------------------------------------------------
Command roles
-----------------------------------------------------------------------------]]
ROLE_HOC = ag.role.Add({
    name = ag.lang.GetPhrase("role_hoc"),
    color = Color(0, 0, 210),
    model = "models/player/breen.mdl",
    description = ag.lang.GetPhrase("role_hoc_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_HOP = ag.role.Add({
    name = ag.lang.GetPhrase("role_hop"),
    color = Color(0, 120, 210),
    model = "models/player/magnusson.mdl",
    description = ag.lang.GetPhrase("role_hop_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ROLE_HOS = ag.role.Add({
    name = ag.lang.GetPhrase("role_hos"),
    color = Color(210, 0, 0),
    model = "models/player/barney.mdl",
    description = ag.lang.GetPhrase("role_hos_desc"),
    weapons = {},
    max = 1,
    salary = 100,
})

ag.role.default = ROLE_CIVILIAN
ag.role.police = {
    [ROLE_POLICE] = true,
    [ROLE_HOS] = true,
}
