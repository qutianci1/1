-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2024-08-20 21:24:40
local NPC = {}
local 对话 = [[想下山吗？我送你一程吧。
menu
大唐边境南
我什么都不想做 
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='大唐边境南' then
        玩家:切换地图(1173, 87, 5)
    end
end



return NPC