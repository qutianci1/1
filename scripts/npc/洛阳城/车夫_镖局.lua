-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-06-16 19:33:55
local NPC = {}
local 对话 = [[这里是洛阳镖局驿站，最近人好少啊，不过生意还是要做的，你要去哪里呢?
menu
洛阳
洛阳集市
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='皇宫门口' then
        玩家:切换地图(1001,404, 230)
    elseif i=='洛阳' then
        玩家:切换地图(1236, 114, 94)
    elseif i=='洛阳集市' then
        玩家:切换地图(1236, 355, 66)
    end
end

return NPC