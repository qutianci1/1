local NPC = {}
local 对话 = [[
这长安城中有一大雁塔，听说里面镇压了十万妖魔，要是没有两把刷子可别进去送死。
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
