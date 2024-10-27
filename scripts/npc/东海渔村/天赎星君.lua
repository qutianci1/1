local NPC = {}
local 对话 = [[
既然玉皇大帝有命，我这就送你入库寻宝，嘿嘿，小心宝没寻到，反而断送了性命，我劝你还是不要进入的好.
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
