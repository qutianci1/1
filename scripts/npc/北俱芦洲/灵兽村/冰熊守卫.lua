-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 08:38:04
-- @Last Modified time  : 2022-06-17 00:41:21
local NPC = {}
local 对话 = [[灵兽村冰雪筑成,巧夺天工,实在是美不胜收。
menu
我要出灵兽村
离开
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='我要出灵兽村' then
        玩家:切换地图(101176, 30, 18)
    end
end



return NPC