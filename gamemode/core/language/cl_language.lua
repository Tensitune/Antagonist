function Antagonist.SetLanguage(lang)
    lang = lang or GetConVar("gmod_language"):GetString()

    net.Start("Antagonist.Language")
    net.WriteString(lang)
    net.SendToServer()
end

hook.Add("InitPostEntity", "Antagonist.Language", function()
    Antagonist.SetLanguage()
    hook.Remove("InitPostEntity", "Antagonist.Language")
end)
