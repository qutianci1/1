-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 07:15:15
-- @Last Modified time  : 2024-08-22 11:09:16
local NPC = {}
local 对话 = [[赚点钱不容易，别看我是“老板”，其实赚的都是辛苦钱啊， 请问想要去哪呢?
menu
1|长安桥
2|长安留香阁
00|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1001, 208, 114)
    elseif i=='2' then
        玩家:切换地图(1001, 51, 45)
    end
    
end



return NPC