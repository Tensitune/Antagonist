--[[-------------------------------------------------------------------------
TLL - Tensitune's Lightweight Library for Garry's Mod
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

TLL = TLL or {}
TLL.Types = {
    ["string"] = "string",
    ["number"] = "number",
    ["bool"] = "boolean",
    ["boolean"] = "boolean",
    ["table"] = "table",
    ["function"] = "function",
}

--- Validates a table against a schema.
--- Schema example:
--- * {
--- *     schemaStr = "string",
--- *     schemaFunc = "function",
--- *     schemaMultiType = { "string", "table" }
--- *     schemaCustomCheck = function(self) return isstring(self) or istable(self) end,
--- * }
--- @param schema table @The table validation schema.
--- @param validateTable table @The table to validate.
--- @param validationString table @String what table we are validating for ErrorNoHalt.
--- @return boolean @Whether the validation succeeded.
function TLL.CheckTableValidation(schema, validateTable, validationString)
    local stackTrace = debug.traceback()
    local stackTraceFind = stackTrace:find("in main chunk")
    local stackTraceStr = string.Explode("\n\t", stackTrace:sub(1, stackTraceFind - 3))
    stackTraceStr = stackTraceStr[#stackTraceStr]

    local errorText

    if type(schema) != "table" then
        errorText = "[TLL Error] Schema must be a table! [" .. stackTraceStr .. "]\n"
    end
    if table.Count(schema) == 0 then
        errorText = "[TLL Error] Schema must not be empty! [" .. stackTraceStr .. "]\n"
    end
    if type(validateTable) != "table" then
        errorText = "[TLL Error] Table to validate against schema is not a table! [" .. stackTraceStr .. "]\n"
    end
    if table.Count(validateTable) == 0 then
        errorText = "[TLL Error] Table to validate must not be empty! [" .. stackTraceStr .. "]\n"
    end

    if errorText then
        ErrorNoHalt(errorText)
        return false
    end

    local isValid = true
    errorText = ("[TLL Error] Incorrect %s! [%s]\nInvalid elements:\n"):format(validationString or "table", stackTraceStr)

    for k, v in next, validateTable do
        local schemaValue = schema[k]
        local schemaValueType = type(schemaValue)
        local schemaValueIsFunc = schemaValueType == "function"

        local schemaTypeIsValid = false

        if schemaValueType == "table" then
            if #schemaValue == 0 then
                ErrorNoHalt("[TLL Error] '" .. k .. "' types not found in schema! [" .. stackTraceStr .. "]\n")
                return false
            end

            for i = 1, #schemaValue do
                local value = schemaValue[i]
                local schemaType = TLL.Types[value]

                if !schemaType then
                    ErrorNoHalt("[TLL Error] Invalid type of '" .. k .. "' in schema! '" .. value .. "' does not exist! [" .. stackTraceStr .. "]\n")
                    return false
                end

                if type(v) == schemaType then
                    schemaTypeIsValid = true
                end
            end
        elseif schemaValueType == "string" then
            local schemaType = TLL.Types[schemaValue]
            if !schemaType then
                ErrorNoHalt("[TLL Error] Invalid type of '" .. k .. "' in schema! '" .. schemaValue .. "' does not exist! [" .. stackTraceStr .. "]\n")
                return false
            end

            schemaTypeIsValid = type(v) == schemaType
        end

        if !schemaTypeIsValid and !(schemaValueIsFunc and schemaValue(validateTable[k])) then
            local schemaType = schemaValueType == "table" and "(must be a " .. TLL.TableToString(schemaValue) .. ")"
                                    or schemaValueType == "function" and ""
                                    or "(must be a " .. schemaValue .. ")"

            errorText = errorText .. ("\t- %s %s\n"):format(k, schemaType)
            isValid = false
        end
    end

    if !isValid then ErrorNoHalt(errorText) end
    return isValid
end

--- Removes all entities found by class
--- @param class string @Entities class name
function TLL.RemoveAllByClass(class)
    local entities = ents.FindByClass(class)

    for i = 1, #entities do
        local ent = entities[i]
        ent:Remove()
    end
end

--- Returns a string of table elements separated by commas.
--- @param tbl table @The table to convert to string.
--- @return string
function TLL.TableToString(tbl)
    local sortedTable = tbl
    table.sort(sortedTable)

    local str = ""
    local sortedTableLength = #sortedTable

    for i = 1, sortedTableLength do
        local value = sortedTable[i]
        str = str .. value .. (i == sortedTableLength and "" or ", ")
    end

    return str
end
