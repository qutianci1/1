-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2023-04-28 16:30:14


local NPC = {}
local 对话 = [[你是大侠，飞过去要收2400两路费，你想飞那个？
menu
程府 领取种族任务
化生寺 我什么都不想做
方寸山
女儿村 
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='程府' then
        玩家:切换地图(1054, 10, 14)
    elseif i=='化生寺' then
        玩家:切换地图(11043, 24, 13)
    elseif i=='方寸山' then
        玩家:切换地图(1137, 16, 10)
    elseif i=='女儿村' then
        玩家:切换地图(1143, 12, 5)
    elseif i=='领取种族任务' then
    end
end



return NPC