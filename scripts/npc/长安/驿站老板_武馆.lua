-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-14 05:21:05


local NPC = {}
local 对话 = [[这里是长安武馆驿站，来坐车吗?旁边那几个阴阳怪气的，不要理他们。
menu
1|长安桥 5|长安东
2|长安留香阁 6|东海渔村
3|大雁塔 99|我什么都不想做
4|皇宫门口
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1001, 208, 114)
    elseif i=='2' then
        玩家:切换地图(1001, 51, 45)
    elseif i=='3' then
        玩家:切换地图(1001, 55, 209)
    elseif i=='4' then
        玩家:切换地图(1001,404, 230)
    elseif i=='5' then
        玩家:切换地图(1193, 304, 186)
    elseif i=='6' then
        玩家:切换地图(1208, 179, 19)


    end
end



return NPC