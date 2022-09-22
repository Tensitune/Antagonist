local translations = {}
local gmodLanguage = GetConVar("gmod_language"):GetString()

local root = GM.FolderName .. "/gamemode/modules/language/translations/"
local files = file.Find(root .. "*", "LUA")

function Antagonist.AddTranslation(name, translation)
    translations[name] = translation
end

function Antagonist.GetPhrase(name, ...)
    local translation = translations[gmodLanguage] or translations.en
    return translation[name] and string.format(translation[name], ...) or ""
end

for _, fileName in next, files do
    if string.GetExtensionFromFilename(fileName) != "lua" then continue end

    if SERVER then
        AddCSLuaFile(root .. fileName)
    end
    include(root .. fileName)
end
