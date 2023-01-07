util.AddNetworkString("Antagonist.Notification")

NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3

function Antagonist.Notify(recipient, notificationType, length, message)
    net.Start("Antagonist.Notification")
    net.WriteInt(notificationType, 3)
    net.WriteInt(length, 6)
    net.WriteString(message)

    if (IsValid(recipient) and recipient:IsPlayer()) or istable(recipient) then
        net.Send(recipient)
    else
        net.Broadcast()
    end
end
