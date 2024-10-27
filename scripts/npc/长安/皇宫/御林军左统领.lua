local NPC = {}
local 对话 = [[
奉圣上旨意，我在此为各路英雄收集入门装备
menu
1|我要兑换装备
2|我要找回新手装备
3|我只是路过看看
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
