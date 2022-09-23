--[[-----------------------------------------------------------------------
English (example) language file
---------------------------------------------------------------------------
This is the english language file. The things on the left side of the equals sign are the things you should leave alone
The parts between the quotes are the parts you should translate. You can also copy this file and create a new language.

You can copy missing phrases to this file and translate them.

-- Note --
Make sure the language code is right at the bottom of this file

-- Using a language --
Make sure the convar gmod_language is set to your language code. You can do that in a server config file.
---------------------------------------------------------------------------]]

Antagonist.AddTranslation("en", {
    needXPrivelege = "You need %s privileges in order to perform this action!",
    noPrivilege = "You don't have the right privileges to perform this action!",

    invalidArgs = "Invalid arguments!",
    cmdNotFound = "Command not found!",
    disabledOOC = "Global OOC has been disabled!",
    cantAfford = "You cannot afford this.",
    notEnoughResources = "You don't have enough resources to craft.",

    -- Talking
    hear_noone = "No-one can hear you!",
    hear_everyone = "Everyone can hear you!",
    hear_certain_persons = "Players who can hear you:",

    -- Misc
    admin = "admin",
    sadmin = "superadmin",
})
