function GM:HUDDrawTargetID()
    return false
end

function GM:PlayerStartVoice(ply)
    if ply == LocalPlayer() then
        ply.IsTalking = true
    end

    self.Sandbox.PlayerStartVoice(self, ply)
end

function GM:PlayerEndVoice(ply)
    if ply == LocalPlayer() then
        ply.IsTalking = false
    end

    self.Sandbox.PlayerEndVoice(self, ply)
end
