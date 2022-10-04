Antagonist.Languages = Antagonist.Languages or {}

local translations = {}
local translationsPath = GM.ModulesRoot .. "/language/translations"

local gmodLanguage = GetConVar("gmod_language"):GetString()

function Antagonist.AddTranslation(name, translation)
    translations[name] = translation

    if table.HasValue(Antagonist.Languages, name) then return end
    Antagonist.Languages[#Antagonist.Languages + 1] = name
end

function Antagonist.GetPhrase(lang, name, ...)
    local translation = translations[lang] or translations[gmodLanguage] or translations.en
    return translation[name] and translation[name]:format(...) or ""
end

TLL.LoadFiles(translationsPath, "SHARED")
