function DesEs()

    ES_CC = 0
    ES_NIU = {}
    ES_ROU = {}
    ES_KANG = {}
    print("数据已清空")
end

function InitEs()

    if ES_CC == nil then
        ES_CC = 223512
    end

    if ES_CC_ENABLE == nil then
        ES_CC_ENABLE = true
    end

    if ES_NIU == nil then
        ES_NIU = {}
    end
    if ES_ROU == nil then
        ES_ROU = {}
    end
    if ES_KANG == nil then
        ES_KANG = {}
    end
end

function SaveES(price, itemid)

    InitEs()
    local l = {
        datetime = date("%Y-%m-%d %H:%M:%S"),
        price = price,
        itemid = itemid
    }

    -- print("ES保存数据：" .. C_Item.GetItemNameByID(itemid) .. "(" .. price .. "g)")
    if itemid == ES.Constant.itemID_niu then
        table.insert(ES_NIU, l)
    elseif itemid == ES.Constant.itemID_rou then
        table.insert(ES_ROU, l)
    elseif itemid == ES.Constant.itemID_kang then
        table.insert(ES_KANG, l)
    end
end
