local NPC = {}
local 对话 = [[
长安有东、西两个城门，出了城门有时会有妖怪出没，可要小心啊。
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
