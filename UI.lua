-- /fstck 打开框架
local UI = {}
UI.index = 0
function UI:CreateBankButton(context, callback)
    local button = CreateFrame("Button", nil, BankFrame, "UIPanelButtonTemplate");
    button:SetSize(80, 30)
    button:SetPoint("BOTTOMLEFT", BankFrame, "BOTTOMLEFT", self.index * 80, 0);
    button:SetText(context);
    button:Show()
    button:SetScript("OnClick", function()
        callback()
    end);
    self.index = self.index + 1
    return self
end

function UI:CreateAuctionButton()
    local button = CreateFrame("Button", nil, AuctionHouseFrame, "UIPanelButtonTemplate");
    button:SetSize(100, 20)
    button:SetFrameStrata("HIGH");
    button:SetPoint("TOPRIGHT", AuctionHouseFrame, "TOPRIGHT", -30, 0);
    button:SetText("更新价格");
    button:Show()
    button:SetScript("OnClick", function()
        UpdateAll()
    end);
    button:SetFrameStrata("HIGH");
    return self
end

UI.port_size = 45
UI.p = CreateFrame("Frame", nil, WorldMapFrame)
UI.p:SetSize(UI.port_size, 300)
UI.p:SetPoint("TOP", WorldMapFrame, "TOP", 155, -140)
UI.index_port = 0
UI.PortFrameCreated = false
function UI:CreatePortal(port)
    local button = CreateFrame("Button", nil, UI.p, "InsecureActionButtonTemplate")
    button:SetPoint("TOP", UI.p, "TOP", 0, -self.index_port * UI.port_size)
    button:SetSize(UI.port_size * 1.2, UI.port_size)
    button:SetFrameStrata("HIGH");
    button:RegisterForClicks("AnyDown", "AnyUp")
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", port.spell)
    -- button:Show()

    local f = CreateFrame("Frame", nil, UI.p)
    f:SetPoint("TOP", UI.p, "TOP", 0, -self.index_port * UI.port_size)
    f:SetSize(60, UI.port_size)
    f:SetFrameStrata("HIGH");
    f.tex = f:CreateTexture()
    f.tex:SetAllPoints(f)
    f.tex:SetTexture(port.texture)

    -- local isUsable = C_Spell.IsSpellUsable(port.spell)

    if not C_SpellBook.IsSpellKnown(port.spell) then
        f.tex:SetDesaturated(true)
    end
    -- f.tex:SetDesaturated(true)
    -- f:Show()

    local t = f:CreateFontString(nil, "OVERLAY", "GameTooltipText")
    t:SetPoint("CENTER", f, "CENTER", 0, 0)
    t:SetJustifyH("CENTER")
    t:SetText(port.title)
    t:SetFont("fonts/arhei.ttf", 20, "OUTLINE");
    -- t:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE");
    local color = HexToRGBA("#FFFFFF")
    t:SetTextColor(color.r, color.g, color.b, color.a);
    self.index_port = self.index_port + 1
end

function UI:CreatePortals()
    if UI.PortFrameCreated then
        return
    end
    for _, v in ipairs(ES.Constant.ports) do
        UI:CreatePortal(v)
    end
    UI.PortFrameCreated = true
end

local texttemplate = "%%s: %%.%df, %%.%df"
local text = texttemplate:format(1, 1)
UI.position = CreateFrame("Frame", nil, WorldMapFrame.ScrollContainer)
UI.cursortext = UI.position:CreateFontString(nil, "OVERLAY")
UI.playertext = UI.position:CreateFontString(nil, "OVERLAY")
UI.cursortext:SetTextColor(1, 1, 1)
UI.playertext:SetTextColor(1, 1, 1)
UI.cursortext:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer, "BOTTOM", 30, 20)
UI.playertext:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "BOTTOM", -30, 20)
UI.cursortext:SetFont(GameFontNormal:GetFont(), 14, "OUTLINE")
UI.playertext:SetFont(GameFontNormal:GetFont(), 14, "OUTLINE")
UI.positionTimerCreated = false;

function UI:UpdatePosition()
    if ESDB.MapCoordinateShow then
        local cx, cy = CursorXY()
        local px, py = PlayerXY()
        if cx then
            UI.cursortext:SetFormattedText(text, "鼠标", 100 * cx, 100 * cy)
        else
            UI.cursortext:SetText("")
        end

        if not px or px == 0 then
            UI.playertext:SetText("")
        else
            UI.playertext:SetFormattedText(text, "玩家", 100 * px, 100 * py)
        end
    else
        UI.cursortext:SetText("")
        UI.playertext:SetText("")
    end
end

UI.m = CreateFrame("Frame", nil, WorldMapFrame.ScrollContainer.Child)
UI.MapLocationFrameCreated = false
function UI:CreateLocation()
    if UI.MapLocationFrameCreated then
        return
    end
    UI.m:SetPoint("CENTER", WorldMapFrame.ScrollContainer.Child, "CENTER", 0, 0);
    UI.m:SetFrameStrata("MEDIUM");
    UI.m:SetSize(1, 1)
    UI.m:Show()

    for _, v in ipairs(ES.Constant.MapLocations) do
        -- local f = UI.m:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        local f = UI.m:CreateFontString(nil, "OVERLAY", "GameTooltipText")
        f:SetPoint("CENTER", UI.m, "CENTER", v.x, v.y)
        f:SetJustifyH("CENTER")
        f:SetText(v.title)
        f:SetFont(STANDARD_TEXT_FONT, 65, "OUTLINE");
        local color = HexToRGBA(v.c)
        f:SetTextColor(color.r, color.g, color.b, color.a);
    end
    UI.MapLocationFrameCreated = true
end

function UI:CreateBankButtons()
    UI:CreateBankButton("取牛肉", function() FetchItem(ES.Constant.itemID_niu) end)
        :CreateBankButton("放肉排", function() TranItem(ES.Constant.itemID_rou) end)
        :CreateBankButton("放胡椒", function() TranItem(ES.Constant.itemID_hujiao) end)
        :CreateBankButton("放尘粉", function() TranItem(ES.Constant.itemID_fencheng) end)
end

function CreateAutionButton()
    UI:CreateAuctionButton()
end

function UI:LocationShow()
    if UI.m then
        UI.m:Show()
    end
end

function UI:LocationHide()
    if UI.m then
        UI.m:Hide()
    end
end

function UI:PortShow()
    if UI.p then
        UI.p:Show()
    end
end

function UI:PortHide()
    if UI.p then
        UI.p:Hide()
    end
end

function LocationShow()
    UI:LocationShow()
end

function LocationHide()
    UI:LocationHide()
end

function PortShow()
    UI:PortShow()
end

function PortHide()
    UI:PortHide()
end

function CreatePortals()
    UI:CreatePortals()
end

function UpdatePosition()
    if not UI.positionTimerCreated then
        C_Timer.NewTicker(0.01, function()
            UI:UpdatePosition()
        end)
        UI.positionTimerCreated = true
    end
end

UI:CreateBankButtons()
UI:CreateLocation()
