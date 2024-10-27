-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-04-18 14:43:15

local NPC = {}
local 对话 = [[
我带你上楼吧，为什么这么贵?这些钱可是交保护费用的，不然我早被怪物吃了。
menu
1|大雁塔六层
2|我哪儿也不去
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1090, 74, 58)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
