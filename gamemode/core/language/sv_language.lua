util.AddNetworkString("Antagonist.Language")

net.Receive("Antagonist.Language", function(_, ply)
    local lang = net.ReadString() or "en"
    local supportedLanguages = Antagonist.Languages

    for i = 1, #supportedLanguages do
        local supportedLang = supportedLanguages[i]
        if supportedLang == lang then
            ply.Language = lang
            return
        end
    end

    ply.Language = "en"
end)
