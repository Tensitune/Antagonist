util.AddNetworkString("Antagonist.Notification")

NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3

function Antagonist.Notify(recipients, notificationType, length, message)
    if IsValid(recipients) and istable(recipients) then
        local recipientsCount = #recipients
        if recipientsCount == 0 then return end

        for i = 1, recipientsCount do 
            local ply = recipients[i]

            if !IsValid(ply) then continue end
            if !ply:IsPlayer() then continue end

            net.Start("Antagonist.Notification")
            net.WriteInt(notificationType, 3)
            net.WriteInt(length, 6)
            net.WriteString(message)
            net.Send(ply)
        end

        return
    end 

    net.Start("Antagonist.Notification")
    net.WriteInt(notificationType, 3)
    net.WriteInt(length, 6)
    net.WriteString(message)

    if !recipients then
        net.Broadcast()
    else
        net.Send(recipients)
    end
end
