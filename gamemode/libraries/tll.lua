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

--- Validates a table against a schema.
--- Schema example:
--- * {
--- *     name = isstring,
--- *     list = istable,
--- *     func = isfunction,
--- *     multiType = function(self) return isstring(self) or istable(self) end,
--- * }
--- @param schema table @The table validation schema.
--- @param validateTable table @The table to validate.
--- @param validationString table @String what table we are validating for ErrorNoHalt.
--- @return boolean @Whether the validation succeeded.
function TLL.CheckTableValidation(schema, validateTable, validationString)
    if !istable(schema) then
        ErrorNoHalt("Schema must be a table!")
        return false
    end

    if !istable(validateTable) then
        ErrorNoHalt("Table to validate against schema is not a table!")
        return false
    end

    local errorText = "Incorrect " .. (validationString or "table") .. "! Invalid elements:\n"
    local isValid = true

    for k in next, validateTable do
        if !schema[k](validateTable[k]) then
            errorText = errorText .. (" - %s\n"):format(k)
            isValid = false
        end
    end

    if !isValid then ErrorNoHalt(errorText) end
    return isValid
end
