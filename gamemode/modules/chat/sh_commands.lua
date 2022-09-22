Antagonist.ChatCommands = Antagonist.ChatCommands or {}

local IChatCommand = {
    name = isstring,
    description = isstring,
    condition = isfunction,
    delay = isnumber,
    arguments = istable,
}

local function checkChatCommand(command)
    for k in next, command do
        if !IChatCommand[k](command[k]) then
            return false, k
        end
    end

    return true
end

function Antagonist.DeclareChatCommand(command)
    local valid, element = checkChatCommand(command)
    if !valid then
        ErrorNoHalt(("Incorrect chat command! %s is invalid!"):format(element))
    end

    command.name = string.lower(command.name)
    Antagonist.ChatCommands[command.name] = Antagonist.ChatCommands[command.name] or command

    for k, v in next, command do
        Antagonist.ChatCommands[command.name][k] = v
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
    description = "Chat roleplay to say you're doing things that you can't show otherwise.",
    delay = 1,
})

Antagonist.DeclareChatCommand({
    name = "ooc",
    description = "Out of character non-roleplay global chat.",
    delay = 1,
})

Antagonist.DeclareChatCommand({
    name = "looc",
    description = "Out of character non-roleplay local chat.",
    delay = 1,
})
