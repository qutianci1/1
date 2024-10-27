-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-07-03 07:59:46
local NPC = {}
local 对话 = [[诸位侠士可是来救我们的吗？
menu
是的没错
我就来凑个热闹
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
end

return NPC
