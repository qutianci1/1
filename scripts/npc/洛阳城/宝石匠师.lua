local NPC = {}
local 对话 = [[
艺之所在，全赖匠心独运。从我这出去的每一颗宝石都是精雕细琢，独一无二的。
menu
1|我想镶嵌/拆除宝石
2|我想合成/重铸宝石
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
