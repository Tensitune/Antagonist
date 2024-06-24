ag.lang.list = ag.lang.list or {}

local translations = {}

function ag.lang.Add(name, translation)
    translations[name] = translation

    if table.HasValue(ag.lang.list, name) then return end
    ag.lang.list[#ag.lang.list + 1] = name
end

function ag.lang.GetPhrase(name, ...)
    local translation = translations[ag.config.language] or translations.english
    return translation[name] and translation[name]:format(...) or "undefined"
end

tll.LoadFiles(GM.RootFolder .. "/config/translations")
