-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-04 19:43:59
-- @Last Modified time  : 2023-06-22 09:02:09

local NPC = {}
local 对话 = [[长安虽然繁华热闹，但是有一个地方比长安更值得一去，那就是修罗古城。怎么？你想去么？
menu
1|请送我去吧 
99|不，我更喜欢繁华的长安
]]


--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(101381, 280, 159)
    end
end



return NPC