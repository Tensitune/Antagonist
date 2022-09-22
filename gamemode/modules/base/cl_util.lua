function Antagonist.Notify(notificationType, length, message)
    notification.AddLegacy(message, notificationType, length)
end

net.Receive("Antagonist.Notification", function()
    local notificationType = net.ReadInt(3)
    local length = net.ReadInt(6)
    local message = net.ReadString()
    
    Antagonist.Notify(notificationType, length, message)
end)
