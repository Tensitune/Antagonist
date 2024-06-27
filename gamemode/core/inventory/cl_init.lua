ag.inventory.client = ag.inventory.client or {}

local inventoryDataReceived = false

function ag.inventory.Get(callback)
    local retries = 0
    inventoryDataReceived = false

    net.Start("ag.GetInventory")
    net.SendToServer()

    timer.Create("ag.GetInventory", 0.1, 0, function()
        if inventoryDataReceived then
            timer.Remove("ag.GetInventory")
            callback(true, ag.inventory.client)
        elseif retries >= 50 then
            timer.Remove("ag.GetInventory")
            callback(false, nil)
        end

        retries = retries + 1
    end)
end

net.Receive("ag.GetInventory", function(_, ply)
    local jsonInventory = net.ReadString()

    ag.inventory.client = util.JSONToTable(jsonInventory)
    inventoryDataReceived = true
end)
