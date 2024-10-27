-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-09-12 23:18:20
-- @Last Modified time  : 2023-09-12 23:19:00

local NPC = {}
local 对话 = [[
听说，我们大圣当年就在这里吃了不少仙桃，不知道我......
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
