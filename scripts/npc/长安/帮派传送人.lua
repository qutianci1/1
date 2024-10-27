-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-04-09 00:26:21

local NPC = {}
local 对话 = [[
你还没有帮派呢，不能传送。
menu
1|送我回帮派
2|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:进入帮派()
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
