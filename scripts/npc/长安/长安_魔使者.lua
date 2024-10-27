-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-13 09:28:35


local NPC = {}
local 对话 = [[你是大侠，飞过去要收2400两路费，你想飞那个？
menu
盘丝洞 领取种族任务
地府 我什么都不想做
魔王寨
狮驼岭 
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='盘丝洞' then
        玩家:切换地图(1144, 7, 9)
    elseif i=='地府' then
        玩家:切换地图(1124, 19, 12)
    elseif i=='魔王寨' then
        玩家:切换地图(1145, 16, 9)
    elseif i=='狮驼岭' then
        玩家:切换地图(1134, 7, 4)
    elseif i=='领取种族任务' then


    end
end



return NPC