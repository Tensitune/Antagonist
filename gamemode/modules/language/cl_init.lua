local gmodLanguage = GetConVar("gmod_language"):GetString()

hook.Add("InitPostEntity", "Antagonist.Language", function()
    net.Start("Antagonist.Language")
    net.WriteString(gmodLanguage)
    net.SendToServer()
end)
