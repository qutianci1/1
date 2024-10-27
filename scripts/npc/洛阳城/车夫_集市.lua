-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2023-04-10 16:58:37
local NPC = {}
local 对话 = [[这里是洛阳集市驿站，排队上车啦，一个一个来，不要挤，想要去哪呢?
menu
长安桥 大唐边境北
四圣庄 洛阳
万寿山 洛阳镖局
皇宫门口 我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='长安桥' then
        玩家:切换地图(1001, 208, 114)
    elseif i=='四圣庄' then
        玩家:切换地图(101295, 212, 34)
    elseif i=='万寿山' then
        玩家:切换地图(101299, 15, 99)
    elseif i=='皇宫门口' then
        玩家:切换地图(1001,404, 230)
    elseif i=='大唐边境北' then
        玩家:切换地图(1173, 558, 316)
    elseif i=='洛阳' then
        玩家:切换地图(1236, 114, 94)
    elseif i=='洛阳镖局' then
        玩家:切换地图(1236, 331, 165)
    end
end

return NPC