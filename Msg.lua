-- 游戏角色点菜
function DianCaiPlayer(user)
    local money = GetMoney()
    local gold = floor(money / 1e4)
    local silver = floor(money / 100 % 100)
    local copper = money % 100

    local niu = C_Item.GetItemCount(223512, true, true, true, true)
    local rou = C_Item.GetItemCount(222738, true, true, true, true)
    local kang = C_Item.GetItemCount(222728, true, true, true, true)

    C_ChatInfo.SendChatMessage(("菜单:%d金%d牛%d肉%d慷"):format(gold, niu, rou, kang), "WHISPER", nil, user)
end

-- 战网消息点菜
function DianCaiBN(bnSenderID)
    local money = GetMoney()
    local gold = floor(money / 1e4)
    local silver = floor(money / 100 % 100)
    local copper = money % 100

    local niu = C_Item.GetItemCount(223512, true, true, true, true)
    local rou = C_Item.GetItemCount(222738, true, true, true, true)
    local kang = C_Item.GetItemCount(222728, true, true, true, true)

    BNSendWhisper(bnSenderID, ("菜单:%d金%d牛%d肉%d慷"):format(gold, niu, rou, kang))
end

function SendAddonMsg(msg)
    C_ChatInfo.SendAddonMessage(ES.Constant.addone_prefix, msg, "GUILD", nil)
end
