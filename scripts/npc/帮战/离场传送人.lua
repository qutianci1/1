-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-26 01:59:55
-- @Last Modified time  : 2024-03-14 21:43:21

local NPC = {}
local 对话 = [[快跑吧,炮灰?
menu
1|我要离场
2|点错了
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1001, 353, 26)
    end
end

return NPC
