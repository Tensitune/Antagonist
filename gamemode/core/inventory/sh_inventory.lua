ag.inventory.slots = {
    [1] = "SLOT_HEAD",
    [2] = "SLOT_MASK",
    [3] = "SLOT_EYES",
    [4] = "SLOT_EARS",
    [5] = "SLOT_HANDS",
    [6] = "SLOT_GLOVES",
    [7] = "SLOT_SHOES",
    [8] = "SLOT_BELT",
    [9] = "SLOT_UNIFORM",
    [10] = "SLOT_OUTER_SUIT",
    [11] = "SLOT_BACK",
    [12] = "SLOT_ID",
    [13] = "SLOT_PDA",
    [14] = "SLOT_LEFT_POCKET",
    [15] = "SLOT_RIGHT_POCKET",
}

hook.Add("InitPostEntity", "ag.Inventory", function()
    for slotID, slot in next, ag.inventory.slots do
        _G[slot] = slotID
    end
end)
