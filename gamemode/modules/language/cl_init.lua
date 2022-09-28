local gmodLanguage = GetConVar("gmod_language"):GetString()

local function agLanguage()
    net.Start("Antagonist.Language")
    net.WriteString(gmodLanguage)
    net.SendToServer()
end
hook.Add("InitPostEntity", "Antagonist.Language", agLanguage)
