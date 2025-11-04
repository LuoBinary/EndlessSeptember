ES.Option.count_niu = 5000
ES.Option.count_rou = 5000
ES.Option.count_kang = 200
ES.Option.SellAllJunkItems = true
ES.Option.AutoRepair = true


local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local addon = ...
local L = ES.L or {}

local DefaultDB = {
    AutoSellAllJunkItems = true,
    AutoRepaire = true,
    MapLocationShow = true,
    ShowMapPort = true,
    MapCoordinateShow = true,
    MPlusAutoKey = true
}
local options = {
    { key = "AutoSellAllJunkItems" },
    { key = "AutoRepaire" },
    { key = "MapLocationShow" },
    { key = "ShowMapPort" },
    { key = "MapCoordinateShow" },
    { key = "MPlusAutoKey" }
}

ESDB = DefaultDB

local function OnClickCheckbox(self)
    ESDB[self.key] = self:GetChecked()
end

local function InitCheckbox(parent)
    for i = 1, parent:GetNumChildren() do
        local checkbox = select(i, parent:GetChildren())
        if (checkbox.key) then
            checkbox:SetChecked(ESDB[checkbox.key])
        end
    end
end

local function CreateCheckbox(list, parent, anchor, offsety)
    local checkbox
    local stepy = 25
    if (not list) then return offsety end
    for i, v in ipairs(list) do
        checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
        checkbox.key = v.key
        -- checkbox.checkedFunc = v.checkedFunc
        -- checkbox.uncheckedFunc = v.uncheckedFunc
        checkbox.Text:SetText(L[v.key])
        checkbox:SetScript("OnClick", OnClickCheckbox)
        checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 12, -6 - offsety)
        offsety = offsety + stepy
    end
end


local frame = CreateFrame("Frame")
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("TOPLEFT", 18, -16)
frame.title:SetText(addon)
CreateCheckbox(options, frame, frame.title, 9)
local category = Settings.RegisterCanvasLayoutCategory(frame, addon)
Settings.RegisterAddOnCategory(category)


LibEvent:attachEvent("VARIABLES_LOADED", function()
    if not ESDB then
        ESDB = DefaultDB
        print(ESDB.AutoSellAllJunkItems)
    end
    InitCheckbox(frame)
end)
