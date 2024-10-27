local NPC = {}
local 对话 = [[
曾经我做过一份差事，后来没了。所以我现在一直很清闲......
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
