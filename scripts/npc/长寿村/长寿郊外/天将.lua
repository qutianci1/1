-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2024-08-19 09:13:27
local NPC = {}
local 对话 = [[来吧，孩子，天庭需要你，不能飞的话我可以送你上去。
menu
天宫
我什么都不想做
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='天宫' then
        玩家:切换地图(1111, 27, 10)
    end
end



return NPC