--0 行囊
--1-4 背包
--5 材料包
--6-11 银行
--12-16 战团银行
function TranItem(itemid)
    local itemcount = 0
    local storecount = 0
    local storeindex = {}
    local itemindex = {}
    --背包
    for i = 0, 5, 1 do
        -- print(C_Container.GetBagName(i))
        for j = 1, C_Container.GetContainerNumSlots(i), 1 do
            local containerInfo = C_Container.GetContainerItemInfo(i, j)
            if containerInfo then
                local item = ItemLocation:CreateFromBagAndSlot(i, j)
                if item:IsValid() and C_Item.GetItemID(item) == itemid then
                    table.insert(itemindex, {
                        bagindex = i,
                        slotindex = j
                    })
                    itemcount = itemcount + 1
                end
            end
        end
    end

    if C_Bank.CanUseBank(0) then
        --银行背包
        for i = 6, 11, 1 do
            if not (C_Container.GetBagName(i) == nil) then
                for j = 1, C_Container.GetContainerNumSlots(i), 1 do
                    local containerInfo = C_Container.GetContainerItemInfo(i, j)
                    if containerInfo == nil then
                        table.insert(storeindex, {
                            bagindex = i,
                            slotindex = j
                        })
                        storecount = storecount + 1
                    end
                end
            end
        end
    end
    --战团银行
    for i = 12, 16, 1 do
        -- print(C_Container.GetBagName(i))
        if not (C_Container.GetBagName(i) == nil) then
            for j = 1, C_Container.GetContainerNumSlots(i), 1 do
                local containerInfo = C_Container.GetContainerItemInfo(i, j)
                if containerInfo == nil then
                    table.insert(storeindex, {
                        bagindex = i,
                        slotindex = j
                    })
                    storecount = storecount + 1
                end
            end
        end
    end


    if storecount > itemcount then
        for i, v in ipairs(itemindex) do
            C_Container.PickupContainerItem(itemindex[i].bagindex, itemindex[i].slotindex)
            C_Container.PickupContainerItem(storeindex[i].bagindex, storeindex[i].slotindex)
        end
    else
        for i, v in ipairs(storeindex) do
            C_Container.PickupContainerItem(itemindex[i].bagindex, itemindex[i].slotindex)
            C_Container.PickupContainerItem(storeindex[i].bagindex, storeindex[i].slotindex)
        end
    end
end

function FetchItem(itemid)
    local itemcount = 0
    local storecount = 0
    local itemindex = {}
    local storeindex = {}

    --背包
    for i = 0, 5, 1 do
        for j = 1, C_Container.GetContainerNumSlots(i), 1 do
            local containerInfo = C_Container.GetContainerItemInfo(i, j)
            if containerInfo == nil then
                table.insert(storeindex, {
                    bagindex = i,
                    slotindex = j
                })
                storecount = storecount + 1
            end
        end
    end

    if C_Bank.CanUseBank(0) then
        --银行背包
        for i = 6, 11, 1 do
            if not (C_Container.GetBagName(i) == nil) then
                for j = 1, C_Container.GetContainerNumSlots(i), 1 do
                    local containerInfo = C_Container.GetContainerItemInfo(i, j)
                    if containerInfo then
                        local item = ItemLocation:CreateFromBagAndSlot(i, j)
                        if item:IsValid() and C_Item.GetItemID(item) == itemid then
                            table.insert(itemindex, {
                                bagindex = i,
                                slotindex = j
                            })
                            itemcount = itemcount + 1
                        end
                    end
                end
            end
        end
    end

    for i = 12, 16, 1 do
        -- print(C_Container.GetBagName(i))
        if not (C_Container.GetBagName(i) == nil) then
            for j = 1, C_Container.GetContainerNumSlots(i), 1 do
                local containerInfo = C_Container.GetContainerItemInfo(i, j)
                if containerInfo then
                    local item = ItemLocation:CreateFromBagAndSlot(i, j)
                    if item:IsValid() and C_Item.GetItemID(item) == itemid then
                        table.insert(itemindex, {
                            bagindex = i,
                            slotindex = j
                        })
                        itemcount = itemcount + 1
                    end
                end
            end
        end
    end
    if storecount > itemcount then
        for i, v in ipairs(itemindex) do
            C_Container.PickupContainerItem(itemindex[i].bagindex, itemindex[i].slotindex)
            C_Container.PickupContainerItem(storeindex[i].bagindex, storeindex[i].slotindex)
        end
    else
        for i, v in ipairs(storeindex) do
            C_Container.PickupContainerItem(itemindex[i].bagindex, itemindex[i].slotindex)
            C_Container.PickupContainerItem(storeindex[i].bagindex, storeindex[i].slotindex)
        end
    end
end

function StackItem(itemid)
    local itemindex = {}
    for i = 0, 5, 1 do
        -- print(C_Container.GetBagName(i))
        for j = 1, C_Container.GetContainerNumSlots(i), 1 do
            local containerInfo = C_Container.GetContainerItemInfo(i, j)
            if containerInfo then
                local item = ItemLocation:CreateFromBagAndSlot(i, j)
                if item:IsValid() and C_Item.GetItemID(item) == itemid then
                    table.insert(itemindex, {
                        bagindex = i,
                        slotindex = j
                    })
                end
            end
        end
    end

    if #itemindex >= 2 then
        local containerInfo = C_Container.GetContainerItemInfo(itemindex[1].bagindex, itemindex[1].slotindex)
        if containerInfo.stackCount < 100 then
            ClearCursor()
            C_Container.PickupContainerItem(itemindex[2].bagindex, itemindex[2].slotindex)
            C_Container.PickupContainerItem(itemindex[1].bagindex, itemindex[1].slotindex)
        end
    end
end
