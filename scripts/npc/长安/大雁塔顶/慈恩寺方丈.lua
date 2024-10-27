local NPC = {}
local 对话 = [[
雁塔佛地竟出现妖魔怨气，为了天下生灵，侠士您愿意赶赴塔中，为镇妖封魔而战吗？
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
