local NPC = {}
local 对话 = [[
嫦娥姐姐……寂寞嫦娥舒广袖，万里长空且为霓裳舞……
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
