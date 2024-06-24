--[[-------------------------------------------------------------------------
Tensitune's Lightweight Library for Garry's Mod
Copyright (c) 2022 Tensitune

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-----------------------------------------------------------------------------]]
local version = 20240624
if tll and tll.version >= version then return end

tll = tll or {}
tll.version = version

tll.colors = {
    primary = Color(180, 140, 255),
    success = Color(100, 255, 100),
    error = Color(255, 100, 100),
    warning = Color(255, 180, 90),
    white = Color(255, 255, 255),
    path = Color(220, 220, 220),
}

local math_abs = math.abs
local prefix = {
    shared = { "sh", "shared" },
    server = { "sv", "server" },
    client = { "cl", "client" },
}

--- Returns the color and prefix
function tll.GetPrefix(prefixType)
    local lowerType = prefixType and string.lower(prefixType) or ""

    if lowerType == "error" then
        return { tll.colors.error, "[ERROR] " }
    elseif lowerType == "warning" then
        return { tll.colors.warning, "[WARNING] " }
    else
        return { tll.colors.primary, "[TLL] " }
    end
end

--- Just a logger. Accepts many arguments.
function tll.Log(...)
    local args = {...}
    if #args == 0 then return end

    local shift = 0
    for i = 1, #args do
        local shiftedIndex = i + shift
        local arg = args[shiftedIndex]

        if istable(arg) then
            for j = 1, #arg do
                if j == 1 then
                    table.remove(args, shiftedIndex)
                end

                table.insert(args, (shiftedIndex - 1) + j, arg[j])
                shift = shift + 1
            end
        end
    end

    local lastArg = args[#args]

    if lastArg and type(lastArg) == "string" and string.Right(lastArg, 2) ~= "\n" then
        args[#args] = lastArg .. "\n"
    elseif lastArg and type(lastArg) ~= "string" then
        args[#args + 1] = "\n"
    end

    MsgC(tll.colors.white, unpack(args))
end

--- Returns a plural noun.
--- one for number ending in 1.
--- two for number ending in 2-4.
--- five for number ending in 5+.
function tll.GetNoun(num, one, two, five)
    local n = math_abs(num) % 100;

    if n >= 5 and n <= 20 then
        return five;
    end

    n = n % 10;
    if n == 1 then
        return one;
    end

    if n >= 2 and n <= 4 then
        return two;
    end

    return five;
end

--- Removes all entities found by class.
function tll.RemoveAllByClass(class)
    local entities = ents.FindByClass(class)

    for i = 1, #entities do
        local ent = entities[i]
        if not IsValid(ent) then continue end

        ent:Remove()
    end
end

--- Returns a string of table elements separated by commas.
function tll.TableToString(tbl, bSort)
    local tempTbl = tbl
    if bSort then table.sort(tempTbl) end

    local str = ""
    local tempTblLength = #tempTbl

    for i = 1, tempTblLength do
        str = str .. tempTbl[i] .. (i == tempTblLength and "" or ", ")
    end

    return str
end

local function initFile(pathToFile, loadSide, bLogDisabled)
    local lowerSide = loadSide ~= nil and string.lower(loadSide) or ""
    local splittedPath = string.Explode("/", pathToFile)
    local pathCount = #splittedPath

    local directory = pathCount > 0 and string.lower(splittedPath[pathCount - 1]) or ""
    local fileName = pathCount > 0 and splittedPath[pathCount] or pathToFile

    local filePrefix = string.Explode("_", string.lower(fileName))[1]
    local side = ""

    if (lowerSide == "server" or directory == "server" or table.HasValue(prefix.server, filePrefix)) and SERVER then
        side = "SERVER"
        include(pathToFile)
    elseif lowerSide == "client" or directory == "client" or table.HasValue(prefix.client, filePrefix) then
        side = "CLIENT"

        if SERVER then AddCSLuaFile(pathToFile) end
        if CLIENT then include(pathToFile) end
    else
        side = "SHARED"

        if SERVER then AddCSLuaFile(pathToFile) end
        include(pathToFile)
    end

    if not bLogDisabled then
        tll.Log(tll.colors.success, "Loaded " .. side, tll.colors.white, ": ", tll.colors.path, pathToFile)
    end
end

--- Loads lua file from a path.
--- loadSide is optional: SERVER / CLIENT / SHARED / nil
function tll.Load(pathToFile, loadSide, bLogDisabled)
    local fileFound = file.Find(pathToFile, "LUA")

    if #fileFound == 0 then
        if not bLogDisabled then
            tll.Log(tll.GetPrefix("warning"), tll.colors.white, "Could not find file: ", tll.colors.path, pathToFile)
        end
        return
    end

    initFile(pathToFile, loadSide, bLogDisabled)
end

local function sortFiles(a, b)
    local prefixA = string.Explode("_", string.lower(a))[1]
    local prefixB = string.Explode("_", string.lower(b))[1]

    local aIsShared = table.HasValue(prefix.shared, prefixA)
    local aIsServer = table.HasValue(prefix.server, prefixA)

    local bIsShared = table.HasValue(prefix.shared, prefixB)
    local bIsClient = table.HasValue(prefix.client, prefixB)

    if aIsShared and not bIsShared then return true end
    if aIsServer and bIsClient then return true end

    return false
end

--- Loads all lua files from a directory.
--- loadSide is optional: SERVER / CLIENT / SHARED / nil
function tll.LoadFiles(directoryPath, loadSide, bLogDisabled)
    local files, directories = file.Find(directoryPath .. "/*", "LUA")
    table.sort(files, sortFiles)

    for i = 1, #files do
        local fileName = files[i]
        local pathToFile = directoryPath .. "/" .. fileName

        initFile(pathToFile, loadSide, bLogDisabled)
    end

    for i = 1, #directories do
        local directory = directories[i]
        local directoryFiles = file.Find(directoryPath .. "/" .. directory .. "/*.lua", "LUA")

        table.sort(directoryFiles, sortFiles)

        for j = 1, #directoryFiles do
            local pathToFile = directoryPath .. "/" .. directory .. "/" .. directoryFiles[j]
            initFile(pathToFile, loadSide, bLogDisabled)
        end
    end
end

if not CLIENT then return end

local math_ceil = math.ceil
local math_max = math.max
local string_sub = string.sub
local string_find = string.find
local string_gmatch = string.gmatch
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local draw_SimpleText = draw.SimpleText

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface_GetTextSize(char)

        if totalWidth >= remainingWidth then
            totalWidth = surface_GetTextSize(char)
            remainingWidth = maxWidth

            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

--- Returns a number based on the size argument and your screen's height.
--- The screen's height is always equal to size 1080.
--- This function is primarily used for scaling font sizes.
function tll.ScreenScale(size)
    return math_ceil(size * (ScrH() / 1080))
end

--- Draws a multiline text on screen.
--- xAlign and yAlign is optional (TEXT_ALIGN_LEFT and TEXT_ALIGN_TOP by default)
function tll.DrawMultiLineText(text, font, x, y, maxWidth, addLineHeight, color, xAlign, yAlign)
    local curX, curY = x, y
    surface_SetFont(font)

    local spaceWidth, lineHeight = surface_GetTextSize(" ")
    local tabWidth = 50

    local totalWidth = 0
    local wrappedText = text:gsub("(%s?[%S]+)", function(word)
        local char = string_sub(word, 1, 1)
        if char == "\n" or char == "\t" then
            totalWidth = 0
        end

        local wordWidth = surface_GetTextSize(word)
        totalWidth = totalWidth + wordWidth

        if wordWidth >= maxWidth then
            local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordWidth), maxWidth)
            totalWidth = splitPoint

            return splitWord
        elseif totalWidth < maxWidth then
            return word
        end

        if char == " " then
            totalWidth = wordWidth - spaceWidth
            return "\n" .. string_sub(word, 2)
        end

        totalWidth = wordWidth
        return "\n" .. word
    end)

    xAlign = xAlign or TEXT_ALIGN_LEFT
    yAlign = yAlign or TEXT_ALIGN_TOP

    for str in string_gmatch(wrappedText, "[^\n]*") do
        if #str > 0 then
            if string_find(str, "\t") then
                for tabs, str2 in string_gmatch(str, "(\t*)([^\t]*)") do
                    curX = math_ceil((curX + tabWidth * math_max(#tabs - 1, 0)) / tabWidth) * tabWidth

                    if #str2 > 0 then
                        draw_SimpleText(str2, font, curX, curY, color, xAlign, yAlign)

                        local w, _ = surface_GetTextSize(str2)
                        curX = curX + w
                    end
                end
            else
                draw_SimpleText(str, font, curX, curY, color, xAlign, yAlign)
            end
        else
            curX = x
            curY = curY + lineHeight + addLineHeight - 4
        end
    end

    return curY
end
