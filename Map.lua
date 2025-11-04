local mapID_duoen = 2339 --多恩诺嘉尔
function UpdateLocation()
    local mapID = WorldMapFrame:GetMapID()
    if mapID == mapID_duoen then
        LocationShow()
    else
        LocationHide()
    end
end

local GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local WorldMapScrollChild = WorldMapFrame.ScrollContainer.Child

function CursorXY()
    local left, top = WorldMapScrollChild:GetLeft(), WorldMapScrollChild:GetTop()
    local width, height = WorldMapScrollChild:GetWidth(), WorldMapScrollChild:GetHeight()
    local scale = WorldMapScrollChild:GetEffectiveScale()
    if not left or not top then return end

    local x, y = GetCursorPosition()
    local cx = (x / scale - left) / width
    local cy = (top - y / scale) / height

    if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
        return
    end
    return cx, cy
end

function PlayerXY()
    local px, py
    local xy = GetPlayerMapPosition(WorldMapFrame:GetMapID(), "player")
    if xy then
        px, py = xy:GetXY()
        return px, py
    else
        return
    end
end
