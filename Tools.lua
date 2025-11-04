-- 分割字符串
function Split(str, reps)
    local resultStrList = {}
    str = string.gsub(str, '[^' .. reps .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

-- 颜色字符串转RGBA
function HexToRGBA(origin)
    local hex = origin:gsub("#", "") -- 移除开头的 '#'
    local r = tonumber("0x" .. hex:sub(1, 2))
    local g = tonumber("0x" .. hex:sub(3, 4))
    local b = tonumber("0x" .. hex:sub(5, 6))
    local a = #hex > 7 and tonumber("0x" .. hex:sub(7, 8)) or 255 -- 默认透明度为255（不透明）
    return { r = r / 255, g = g / 255, b = b / 255, a = a / 255 }
end
