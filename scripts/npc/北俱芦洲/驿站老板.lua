-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-25 08:49:56


local NPC = {}
local 对话 = [[真不公平，为什么我会被分配在这鬼地方?将就着先干吧.想去哪里呢?
menu
长安桥
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='长安桥' then
        玩家:切换地图(1001, 208, 114)
    end
    
end



return NPC