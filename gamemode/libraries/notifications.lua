if SERVER then
    NOTIFY_GENERIC = 0
    NOTIFY_ERROR = 1
    NOTIFY_UNDO = 2
    NOTIFY_HINT = 3

    util.AddNetworkString("ag.Notification")

    function ag.util.Notify(recipient, notificationType, length, message)
        net.Start("ag.Notification")
        net.WriteInt(notificationType, 3)
        net.WriteInt(length, 6)
        net.WriteString(message)

        if (IsValid(recipient) and recipient:IsPlayer()) or istable(recipient) then
            net.Send(recipient)
        else
            net.Broadcast()
        end
    end
else
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
end
