function GM:Initialize()
    self.Sandbox.Initialize(self)
end

function GM:InitPostEntity()
    local physData = physenv.GetPerformanceSettings()
    physData.MaxVelocity = 2000
    physData.MaxAngularVelocity = 3636

    physenv.SetPerformanceSettings(physData)

    game.ConsoleCommand("physgun_DampingFactor 0.9\n")
    game.ConsoleCommand("sv_sticktoground 0\n")
    game.ConsoleCommand("sv_airaccelerate 1000\n")

    hook.Run("Antagonist.InitPostEntity")
end
