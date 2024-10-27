-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 07:35:43
-- @Last Modified time  : 2022-06-14 20:42:17
local NPC = {}
local 对话 = [[有车坐何必自己走呢?让我送你下山吧。想去哪?
menu
长寿村
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='长寿村' then
        玩家:切换地图(1070, 51, 19)
    end
    
end



return NPC