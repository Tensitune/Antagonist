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
local version = 20230713
if tll and tll.version >= version then return end

tll = tll or {}
tll.version = version

tll.colors = {
    primary = Color(253, 77, 89),
    warning = Color(250, 180, 50),
    white = Color(255, 255, 255),
    path = Color(210, 210, 210),
}

local math_abs = math.abs

local function initFile(directoryPath, fileName)
    local prefix = string.Explode("_", string.lower(fileName))[1]
    local pathToFile = directoryPath .. "/" .. fileName

    if (prefix == "sv" or prefix == "server") and SERVER then
        tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
        include(pathToFile)
    elseif prefix == "cl" or prefix == "client" then
        if SERVER then AddCSLuaFile(pathToFile) end
        if CLIENT then include(pathToFile) end
    else
        if SERVER then
            AddCSLuaFile(pathToFile)
            tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
        end

        include(pathToFile)
    end
end

--- Just a logger.
--- Prefix is optional, accepts many arguments.
function tll.Log(prefix, ...)
    local args = {...}
    if #args == 0 then return end

    local lastArg = args[#args]

    if lastArg and type(lastArg) == "string" and string.Right(lastArg, 2) ~= "\n" then
        args[#args] = lastArg .. "\n"
    elseif lastArg and type(lastArg) ~= "string" then
        args[#args + 1] = "\n"
    end

    if prefix and type(prefix) == "string" then
        MsgC(tll.colors.primary, "[" .. prefix .. "] ", tll.colors.white, unpack(args))
    else
        MsgC(tll.colors.white, unpack(args))
    end
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

--- Loads lua file from a path.
--- loadSide is optional: SERVER / CLIENT / SHARED / nil
function tll.Load(loadSide, pathToFile)
    local lowerSide = string.lower(loadSide)
    local fileFound = file.Find(pathToFile, "LUA")

    if #fileFound == 0 then
        tll.Log("TLL", "Could not find file: ", tll.colors.path, pathToFile)
        return
    end

    if lowerSide == "server" and SERVER then
        tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
        include(pathToFile)
    elseif lowerSide == "client" then
        if SERVER then AddCSLuaFile(pathToFile) end
        if CLIENT then include(pathToFile) end
    elseif lowerSide == "shared" then
        if SERVER then
            AddCSLuaFile(pathToFile)
            tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
        end

        include(pathToFile)
    end
end

--- Loads all lua files from a directory.
--- loadSide is optional: SERVER / CLIENT / SHARED / nil
function tll.LoadFiles(loadSide, directoryPath)
    local lowerSide = loadSide and string.lower(loadSide) or nil
    local files, directories = file.Find(directoryPath .. "/*", "LUA")

    for i = 1, #files do
        local fileName = files[i]
        local pathToFile = directoryPath .. "/" .. fileName

        if (lowerSide and lowerSide == "server") and SERVER then
            tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
            include(pathToFile)
        elseif (lowerSide and lowerSide == "client") then
            if SERVER then AddCSLuaFile(pathToFile) end
            if CLIENT then include(pathToFile) end
        elseif (lowerSide and lowerSide == "shared") then
            if SERVER then
                AddCSLuaFile(pathToFile)
                tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
            end

            include(pathToFile)
        else
            initFile(directoryPath, fileName)
        end
    end

    for i = 1, #directories do
        local directory = directories[i]
        local directoryFiles = file.Find(directoryPath .. "/" .. directory .. "/*.lua", "LUA")

        for j = 1, #directoryFiles do
            local directoryFile = directoryFiles[j]
            local pathToFile = directoryPath .. "/" .. directory .. "/" .. directoryFile

            if ((lowerSide and lowerSide == "server") or (not lowerSide and directory == "server")) and SERVER then
                tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
                include(pathToFile)
            elseif (lowerSide and lowerSide == "client") or (not lowerSide and directory == "client") then
                if SERVER then AddCSLuaFile(pathToFile) end
                if CLIENT then include(pathToFile) end
            elseif (lowerSide and lowerSide == "shared") then
                if SERVER then
                    AddCSLuaFile(pathToFile)
                    tll.Log("TLL", "Loading file: ", tll.colors.path, pathToFile)
                end

                include(pathToFile)
            else
                initFile(directoryPath, directoryFile)
            end
        end
    end
end

if CLIENT then
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
end
