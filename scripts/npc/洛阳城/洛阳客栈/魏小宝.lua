local NPC = {}
local 对话 = [[
我叫魏小宝，魏大宝的魏，魏小宝的小，魏小宝的宝#89
menu
1|我要寄存召唤兽
2|我要取出寄存的召唤兽
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
