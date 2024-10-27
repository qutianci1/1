local NPC = {}
local 对话 = [[
洛阳是比京城还热闹的地方，我们可喜欢来这里赶集了。
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
