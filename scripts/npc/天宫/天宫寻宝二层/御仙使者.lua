local NPC = {}
local 对话 = [[
本尊目前体力为#Y/10#W/点，当我们体力降至0时，本层宝物必将浮现于世。
menu
1|挑战
2|放弃
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
