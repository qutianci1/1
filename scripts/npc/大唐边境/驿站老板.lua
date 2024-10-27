-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-06-14 20:24:21
local NPC = {}
local 对话 = [[迷途的路人还是让我送 你回家吧。
menu
1|长安桥
99|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1001, 208, 114)
    end
    
end



return NPC