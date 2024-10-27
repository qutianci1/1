-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2023-04-18 06:38:15


local NPC = {}
local 对话 = [[你是大侠，飞过去要收2400两路费，你想飞那个？
menu
三尸派 领取种族任务
白骨洞 我什么都不想做
兰若寺
阴都 
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='三尸派' then
        玩家:切换地图(1009, 30, 17)
    elseif i=='白骨洞' then
        玩家:切换地图(101301, 19, 9)
    elseif i=='兰若寺' then
        玩家:切换地图(101395, 172, 93)
    elseif i=='阴都' then
        玩家:切换地图(101394, 25, 12)
    elseif i=='领取种族任务' then


    end
end



return NPC