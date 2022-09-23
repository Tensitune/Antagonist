Antagonist.Languages = Antagonist.Languages or {}

local translations = {}
local gmodLanguage = GetConVar("gmod_language"):GetString()

local root = GM.FolderName .. "/gamemode/modules/language/translations/"
local files = file.Find(root .. "*", "LUA")

function Antagonist.AddTranslation(name, translation)
    translations[name] = translation
    table.insert(Antagonist.Languages, name)
end

function Antagonist.GetPhrase(lang, name, ...)
    local translation = translations[lang] or translations[gmodLanguage] or translations.en
    return translation[name] and string.format(translation[name], ...) or ""
end

for _, fileName in next, files do
    if string.GetExtensionFromFilename(fileName) != "lua" then continue end

    if SERVER then
        AddCSLuaFile(root .. fileName)
    end
    include(root .. fileName)
end
