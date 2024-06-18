if SERVER then
    util.AddNetworkString("ag.Radial")
    util.AddNetworkString("ag.Inventory")
    return
else
    net.Receive("ag.Radial", function()
        local entity = net.ReadEntity()

        local radialMenu = vgui.Create("ag.Radial")
        radialMenu:SetEntity(entity)
    end)

    net.Receive("ag.Inventory", function()
        vgui.Create("ag.Inventory")
    end)
end
