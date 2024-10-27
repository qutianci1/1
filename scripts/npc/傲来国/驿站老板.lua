-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2024-08-20 21:28:52
local NPC = {}
local 对话 = [[这里是傲来国驿站，想要去哪呢?
menu
长安桥 
洛阳
我什么都不想做 
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='长安桥' then
        玩家:切换地图(1001, 208, 114)
    elseif i=='洛阳' then
        玩家:切换地图(1236, 114, 94)
    end
end



return NPC