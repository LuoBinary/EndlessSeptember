function UpdateItem(itemid)
    local itemKey = C_AuctionHouse.MakeItemKey(itemid)
    C_AuctionHouse.SendSearchQuery(itemKey, {}, false)
end

function UpdateAll()
    local ES_CC = ES.Constant.itemID_niu
    C_Timer.NewTicker(1, function()
        if ES_CC and ES_CC ~= 0 then
            UpdateItem(ES_CC)
            if ES_CC == ES.Constant.itemID_niu then
                ES_CC = ES.Constant.itemID_rou
            elseif ES_CC == ES.Constant.itemID_rou then
                ES_CC = ES.Constant.itemID_kang
            elseif ES_CC == ES.Constant.itemID_kang then
                ES_CC = ES.Constant.itemID_niu
            end
        end
    end, 3)
end

function CommodityResultUpdate(itemid)
    local ncount = 1
    if itemid == ES.Constant.itemID_niu then
        ncount = ES.Option.count_niu
    elseif itemid == ES.Constant.itemID_rou then
        ncount = ES.Option.count_rou
    elseif itemid == ES.Constant.itemID_kang then
        ncount = ES.Option.count_kang
    else
        return
    end

    local ncount_s = 0
    for i = 1, C_AuctionHouse.GetNumCommoditySearchResults(itemid) do
        local result = C_AuctionHouse.GetCommoditySearchResultInfo(itemid, i)
        if result ~= nil then
            ncount_s = ncount_s + result.quantity
            if ncount_s >= ncount then
                local price = (result.unitPrice / 10000)
                SendAddonMsg(price .. "=" .. itemid)
                SaveES(price, itemid)
                break
            end
        end
    end
end
