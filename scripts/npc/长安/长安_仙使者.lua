-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-13 10:48:13


local NPC = {}
local 对话 = [[你是大侠，飞过去要收2400两路费，你想飞那个？
menu
天宫 领取种族任务
龙宫 我什么都不想做
五庄观
普陀山 
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='天宫' then
        玩家:切换地图(1113, 14, 7)
    elseif i=='龙宫' then
        玩家:切换地图(1117, 18, 10)
    elseif i=='五庄观' then
        玩家:切换地图(1147, 13, 12)
    elseif i=='普陀山' then
        玩家:切换地图(1141, 7, 4)
    elseif i=='领取种族任务' then
    end
end



return NPC