-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-15 00:58:30


local NPC = {}
local 对话 = [[你想去哪里呢？
menu
1|长安东  
我什么都不想做 
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1193, 303, 155)
    end
end



return NPC