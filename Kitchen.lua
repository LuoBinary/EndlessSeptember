function QieRou()
    local not_found = true
    for i = 0, 5, 1 do
        for j = 1, C_Container.GetContainerNumSlots(i), 1 do
            local containerInfo = C_Container.GetContainerItemInfo(i, j)
            if containerInfo then
                local item = ItemLocation:CreateFromBagAndSlot(i, j)
                if not_found and item:IsValid() and C_Item.GetItemID(item) == 223512 then
                    C_TradeSkillUI.CraftSalvage(445118, 100000, item)
                    not_found = false
                end
            end
        end
    end
end

function QieYu()
    local not_found = true
    for i = 0, 5, 1 do
        for j = 1, C_Container.GetContainerNumSlots(i), 1 do
            local containerInfo = C_Container.GetContainerItemInfo(i, j)
            if containerInfo then
                local item = ItemLocation:CreateFromBagAndSlot(i, j)
                if not_found and item:IsValid() and (C_Item.GetItemID(item) == 220134 or C_Item.GetItemID(item) == 220135 or C_Item.GetItemID(item) == 220136 or C_Item.GetItemID(item) == 220137) and containerInfo.stackCount >= 5 then
                    C_TradeSkillUI.CraftSalvage(445127, 100000, item)
                    not_found = false
                end
            end
        end
    end
end