local L = ES.L

-- ES
L["addOnName"] = "无尽九月"
L["AutoSellAllJunkItems"] = "自动出售垃圾物品"
L["AutoRepaire"] = "自动修理物品"
L["MapLocationShow"] = "显示主城地图NPC位置"
L["ShowMapPort"] = "显示大秘境传送"
L["MapCoordinateShow"] = "地图坐标显示"
L["MPlusAutoKey"] = "大秘境自动插钥匙"


-- Make missing translations available
setmetatable(ES.L, {
  __index = function(self, key)
    self[key] = (key or "")
    return key
  end
})
