GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

Antagonist = Antagonist or {}
Antagonist.Config = Antagonist.Config or {}

if SERVER then
    AddCSLuaFile("config/config.lua")
    AddCSLuaFile("libraries/sh_cami.lua")
end

include("libraries/sh_cami.lua")
include("config/config.lua")

local function LoadModules()
    local root = GM.FolderName .. "/gamemode/modules/"
    local files, folders = file.Find(root .. "*", "LUA")

    for _, fileName in next, files do
        if string.GetExtensionFromFilename(fileName) != "lua" then continue end
        include(root .. fileName)
    end

    for _, folder in SortedPairs(folders, true) do
        for _, fileName in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            if SERVER then
                AddCSLuaFile(root .. folder .. "/" .. fileName)
            end

            include(root .. folder .. "/" .. fileName)
        end

        if SERVER then
            for _, fileName in SortedPairs(file.Find(root .. folder .. "/sv_*.lua", "LUA"), true) do
                include(root .. folder .. "/" .. fileName)
            end
        end

        for _, fileName in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            if SERVER then
                AddCSLuaFile(root .. folder .. "/" .. fileName)
            else
                include(root .. folder .. "/" .. fileName)
            end
        end
    end
end

LoadModules()
