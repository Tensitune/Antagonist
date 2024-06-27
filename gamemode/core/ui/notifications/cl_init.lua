function ag.util.Notify(notificationType, length, message)
    local sound = notificationType == NOTIFY_ERROR and "buttons/button16.wav"
                    or notificationType == NOTIFY_HINT and "ambient/water/rain_drip1.wav"
                    or "buttons/lightswitch2.wav"

    notification.AddLegacy(message, notificationType, length)
    surface.PlaySound(sound)
end

net.Receive("ag.Notification", function()
    local notificationType = net.ReadInt(3)
    local length = net.ReadInt(6)
    local message = net.ReadString()

    ag.util.Notify(notificationType, length, message)
end)
