-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2024-08-20 18:52:02
local NPC = {}
local 对话 = [[这里是洪洲驿站，最近猪肉涨价，车费自然也要跟着提啦，想要去哪呢?
menu
1|长安桥
2|长安留香阁
99|我什么都不想做
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