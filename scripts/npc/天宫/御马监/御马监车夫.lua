-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-21 03:40:27

local NPC = {}
local 对话 = [[车夫就是我了#24
menu
1|御马监
4|我只是路过看看
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1199, 17, 34)

    end
end

return NPC
