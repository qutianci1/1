-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2024-08-20 21:49:39

local NPC = {}
local 对话 = [[这里就是长安最繁华的地方，长安清风桥，哈哈，你要去哪里呢?
menu
1|江洲 5|洛阳集市
2|丰都 6|东海渔村
3|洪洲 7|大雁塔
4|洛阳 8|轮回司
99|我什么都不想做
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1110, 268, 132)
    elseif i == '2' then
        玩家:切换地图(1110, 23, 162)
    elseif i == '3' then
        玩家:切换地图(1110, 45, 34)
    elseif i == '4' then
        玩家:切换地图(1236, 114, 94)
    elseif i == '5' then
        玩家:切换地图(1236, 358, 70)
    elseif i == '6' then
        玩家:切换地图(1208, 179, 19)
    elseif i == '7' then
        玩家:切换地图(1001, 55, 209)
	elseif i == '8' then
        玩家:切换地图(1125, 51, 21)
    end
end

return NPC
