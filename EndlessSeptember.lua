local f = CreateFrame("Frame")
local name, realm = UnitFullName("player")
local playerName = UnitName("player")
local timer
local ESFRAME
if C_AddOns.DoesAddOnExist("Baganator") then
    ESFRAME = CreateFrame("Frame", "ESFRAME", UIParent, "BasicFrameTemplate");
    ESFRAME:SetPoint("CENTER", UIParent, "CENTER",
        800, 0);
    ESFRAME:Hide()
else
    ESFRAME = CreateFrame("Frame", "ESFRAME", ContainerFrameCombinedBags, "BasicFrameTemplate");
    ESFRAME:SetPoint("TOPRIGHT", ContainerFrameCombinedBags, "TOPLEFT", 0, -20);
    ESFRAME:Show()
    -- ESFRAME = CreateFrame("Frame", "ESFRAME", ContainerFrameCombinedBags, "BasicFrameTemplate");
    -- ESFRAME:SetPoint("TOPRIGHT", ContainerFrameCombinedBags, "TOPLEFT", 0, -20);
    -- ESFRAME:Show()
end

ESFRAME:SetWidth(150);
ESFRAME:SetHeight(300);
ESFRAME.TitleText:SetText("无尽九月")
ESFRAME:SetMovable(true)
ESFRAME:SetClampedToScreen(true)
ESFRAME:SetScript("OnMouseUp", function()
    ESFRAME:StopMovingOrSizing();
end);
ESFRAME:SetScript("OnMouseDown", function()
    ESFRAME:StartMoving();
end);
ESFRAME:SetFrameStrata("LOW");

local preFrame = ESFRAME
-- 拍卖行
local button_a = CreateFrame("Button", nil, ESFRAME, "UIPanelButtonTemplate");
button_a:SetSize(130, 30)
button_a:SetPoint("TOPLEFT", preFrame, "TOPLEFT", 8, -28);
button_a:SetText("更新价格");
button_a:Show()
button_a:SetScript("OnClick", function()
    UpdateAll()
end);
preFrame = button_a

local btn = {}
btn.prefame = preFrame
function btn:CreatButton(text, callback)
    local button = CreateFrame("Button", nil, ESFRAME, "UIPanelButtonTemplate");
    button:SetSize(130, 30)
    button:SetPoint("TOPLEFT", btn.prefame, "BOTTOMLEFT", 0, 0);
    button:SetText(text);
    button:Show()
    button:SetScript("OnClick", function()
        callback()
    end);
    self.prefame = button
    return self
end

btn:CreatButton("切肉", function() QieRou() end)
    :CreatButton("切鱼", function() QieYu() end)
    :CreatButton("取出牛肉", function() FetchItem(ES.Constant.itemID_niu) end)
    :CreatButton("转移肉排", function() TranItem(ES.Constant.itemID_rou) end)
    :CreatButton("转移胡椒", function() TranItem(ES.Constant.itemID_hujiao) end)
    :CreatButton("转移尘粉", function() TranItem(ES.Constant.itemID_fencheng) end)
    :CreatButton("测试", function() Test() end)

function Test()
    -- local index = 1;
    -- local aura = C_UnitAuras.GetBuffDataByIndex("PLAYER", index)
    -- local aura = C_UnitAuras.GetAuraDataBySpellName("PLAYER", "永恒能量")
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(1232454)

    if aura then
        print(aura.name)
        print(aura.spellId)
        print(aura.points)

        for i, v in ipairs(aura.points) do
            print(i, v)
        end
    end
end

--收到密语
function f:CHAT_MSG_WHISPER(event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;
    if arg1 == "点菜" then
        DianCaiPlayer(arg2)
    end

    if arg1 == "切肉" then
        print("切肉")
        QieRou()
    end
end

--拍卖行打开
function f:AUCTION_HOUSE_SHOW(event)
    if not timer or timer:IsCancelled() then
        timer = C_Timer.NewTicker(60, function()
            UpdateAll()
        end)
    end
    UpdateAll()

    CreateAutionButton()
    -- local myCheckButton = CreateFrame("CheckButton", nil, AuctionHouseFrame, "ChatConfigCheckButtonTemplate")
    -- myCheckButton:SetPoint("TOPLEFT", 60, 0)
    -- myCheckButton:SetFrameStrata("HIGH");
    -- myCheckButton.Text:SetText("自动更新价格数据")
    -- -- myCheckButton.tooltip = "This is where you place MouseOver Text."
    -- myCheckButton:HookScript("OnClick", function()
    --     --do stuff
    -- end)
end

--拍卖行关闭
function f:AUCTION_HOUSE_CLOSED(event)
    if timer and not timer:IsCancelled() then
        timer:Cancel()
    end
end

--拍卖行一级结果更新
function f:AUCTION_HOUSE_BROWSE_RESULTS_UPDATED(event)
end

--拍卖行材料结果更新
function f:COMMODITY_SEARCH_RESULTS_UPDATED(event, itemid)
    CommodityResultUpdate(itemid)
end

function f:CHAT_MSG_LOOT(event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;

    --切肉
    if (string.find(arg1, "你获得了") and (string.find(arg1, "分切的肉排"))) then
        StackItem(ES.Constant.itemID_niu)
    end

    --搓慷
    if (string.find(arg1, "你制造了") and (string.find(arg1, "贝雷达尔之慷"))) then
        local b = ProfessionsFrame.CraftingPage.CreateAllButton;
        if b:IsVisible() then
            b:Click()
        end
    end
end

function f:CHAT_MSG_BN_WHISPER(event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;

    local bnSenderID = arg13
    if arg1 == "点菜" then
        DianCaiBN(bnSenderID)
    end
end

function f:OnEvent(event, ...)
    self[event](self, event, ...)
end

--打开商店页面
function f:MERCHANT_SHOW(event)
    if ESDB.AutoSellAllJunkItems then
        C_MerchantFrame.SellAllJunkItems() --自动出售垃圾物品
    end
    if ESDB.AutoRepaire then
        local repairAllCost, canRepair = GetRepairAllCost()
        if repairAllCost > 0 and canRepair and CanMerchantRepair() then
            if IsInGuild() and CanGuildBankRepair() then
                RepairAllItems(true)  --公修
            else
                RepairAllItems(false) --修理
            end
        end
    end
end

--登录或重载
function f:PLAYER_ENTERING_WORLD(event, ...)
    local isLogin, isReload = ...
    if isLogin or isReload then
        C_ChatInfo.RegisterAddonMessagePrefix(ES.Constant.addone_prefix)
    end
end

--收到插件密语
function f:CHAT_MSG_ADDON(event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;

    if ES.Constant.addone_prefix == arg1 then
        local result = Split(arg2, "=")
        -- print("r1:" .. result[1])
        -- print("r2:" .. result[2])
    end
end

--打开地图
function f:QUEST_LOG_UPDATE(event, ...)
    if ESDB.MapLocationShow then
        UpdateLocation()
    else
        LocationHide()
    end

    CreatePortals()
    if ESDB.ShowMapPort then
        PortShow()
    else
        PortHide()
    end

    UpdatePosition() --更新地图坐标位置
end

--角色移动
function f:OnUpdate(event, ...)
    UpdatePosition() --更新地图坐标位置
end

--打开大米钥匙界面
function f:CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN(event, ...)
    if ESDB.MPlusAutoKey then
        PlaceKeystone()
    end
end

--放入大米钥匙
function f:CHALLENGE_MODE_KEYSTONE_SLOTTED(event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;
    --  print("r1:" ..arg1)
end

f:RegisterEvent("AUCTION_HOUSE_SHOW")
f:RegisterEvent("AUCTION_HOUSE_CLOSED")
f:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
f:RegisterEvent("COMMODITY_SEARCH_RESULTS_UPDATED")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("MERCHANT_SHOW")

f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("CHAT_MSG_BN_WHISPER")

-- f:RegisterEvent("CHAT_MSG_CHANNEL")

f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:RegisterEvent("QUEST_LOG_UPDATE")

f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED")

-- f:RegisterEvent("OnUpdate")


-- f:RegisterEvent("AREA_POIS_UPDATED")
table.insert(PAPERDOLL_STATCATEGORIES[1].stats, { stat = "MOVESPEED" })
f:SetScript("OnEvent", f.OnEvent)

SlashCmdList["ES"] = function(Command)
    if Command:lower() == "clear" then
    elseif Command:lower() == "qr" then
        QieRou()
    elseif Command:lower() == "qy" then
        QieYu()
    elseif Command:lower() == "test" then
        Test()
    else
        if ESFRAME and not ESFRAME:IsVisible() then
            ESFRAME:Show()
        else
            ESFRAME:Hide()
        end
    end
end

SLASH_ES1 = "/es";
