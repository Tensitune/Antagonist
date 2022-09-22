GM.Version = "0.0.1"
GM.Name = "Antagonist"
GM.Author = "Tensitune & dj-34"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

Antagonist = Antagonist or {}
Antagonist.Config = Antagonist.Config or {}
Antagonist.FolderName = GM.FolderName

if SERVER then
    AddCSLuaFile("config/config.lua")
    AddCSLuaFile("libraries/sh_cami.lua")
end

include("libraries/sh_cami.lua")
include("config/config.lua")

local SortedPairs = SortedPairs
local function LoadModules()
    local root = GM.FolderName .. "/gamemode/modules/"
    local files, folders = file.Find(root .. "*", "LUA")

    for _, file in next, files do
        if string.GetExtensionFromFilename(file) != "lua" then continue end
        include(root .. file)
    end

    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            if SERVER then
                AddCSLuaFile(root .. folder .. "/" .. File)
            end

            include(root .. folder .. "/" .. File)
        end
        
        if SERVER then
            for _, File in SortedPairs(file.Find(root .. folder .. "/sv_*.lua", "LUA"), true) do
                include(root .. folder .. "/" .. File)
            end
        end

        for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            if SERVER then
                AddCSLuaFile(root .. folder .. "/" .. File)
            else
                include(root .. folder .. "/" .. File)
            end
        end
    end
end

LoadModules()
