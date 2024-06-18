ag.chat.commandList = ag.chat.commandList or {}

function ag.chat.DeclareCommand(command)
    local name = string.lower(command.name)
    ag.chat.commandList[name] = ag.chat.commandList[name] or command

    for k, v in next, command do
        ag.chat.commandList[name][k] = v
    end
end

function ag.chat.RemoveCommand(name)
    ag.chat.commandList[string.lower(name)] = nil
end

function ag.chat.GetCommand(name)
    return ag.chat.commandList[string.lower(name)]
end

function ag.chat.GetCommands()
    return ag.chat.commandList
end

--[[---------------------------------------------------------------------------
Chat commands
---------------------------------------------------------------------------]]
ag.chat.DeclareCommand({
    name = "y",
    description = ag.lang.GetPhrase("command_yell"),
    delay = 1,
})

ag.chat.DeclareCommand({
    name = "w",
    description = ag.lang.GetPhrase("command_whisper"),
    delay = 1,
})

ag.chat.DeclareCommand({
    name = "me",
    description = ag.lang.GetPhrase("command_me"),
    delay = 1,
})

ag.chat.DeclareCommand({
    name = "ooc",
    description = ag.lang.GetPhrase("command_ooc"),
    delay = 1,
})

ag.chat.DeclareCommand({
    name = "looc",
    description = ag.lang.GetPhrase("command_looc"),
    delay = 1,
})

ag.chat.DeclareCommand({
    name = "flip",
    description = ag.lang.GetPhrase("command_flip"),
    delay = 1,
})
