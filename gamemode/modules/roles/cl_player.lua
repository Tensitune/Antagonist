local meta = FindMetaTable("Player")

function meta:ChangeRole(index)
    net.Start("Antagonist.Roles")
    net.WriteInt(index, 9)
    net.SendToServer()
end
