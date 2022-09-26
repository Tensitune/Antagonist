Antagonist.ChatCommands = Antagonist.ChatCommands or {}

local chatCommandSchema = {
    name = "string",
    description = "string",
    condition = "function",
    delay = "number",
    arguments = "table",
}

function Antagonist.DeclareChatCommand(command)
    local valid = TLL.CheckTableValidation(chatCommandSchema, command, "chat command")
    if !valid then return end

    local name = string.lower(command.name)
    Antagonist.ChatCommands[name] = Antagonist.ChatCommands[name] or command

    for k, v in next, command do
        Antagonist.ChatCommands[name][k] = v
    end
end

function Antagonist.RemoveChatCommand(name)
    Antagonist.ChatCommands[string.lower(name)] = nil
end

function Antagonist.GetChatCommand(name)
    return Antagonist.ChatCommands[string.lower(name)]
end

function Antagonist.GetChatCommands()
    return Antagonist.ChatCommands
end

--[[---------------------------------------------------------------------------
Chat commands
---------------------------------------------------------------------------]]
Antagonist.DeclareChatCommand({
    name = "me",
    description = Antagonist.GetPhrase(nil, "command_me"),
    delay = 1,
})

Antagonist.DeclareChatCommand({
    name = "ooc",
    description = Antagonist.GetPhrase(nil, "command_ooc"),
    delay = 1,
})

Antagonist.DeclareChatCommand({
    name = "looc",
    description = Antagonist.GetPhrase(nil, "command_looc"),
    delay = 1,
})
