-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 07:40:51
-- @Last Modified time  : 2022-06-15 15:55:13
local NPC = {}
local 对话 = [[我是张闻的弟弟，我俩江湖诨号为“有去有回”。这位客官在此耍累了么?那我可以送你回到长安温柔乡里去!
menu
长安桥
我什么都不想做 
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='长安桥' then
        玩家:切换地图(1001, 208, 114)
    end
end


return NPC