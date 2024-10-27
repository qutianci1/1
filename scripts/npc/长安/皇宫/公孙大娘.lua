local NPC = {}
local 对话 = [[
长安有东、西两个城门，出了城门有时会有妖怪出没，可要小心啊。
menu
1|我要带孩子拜师(剑舞)
2|我要进行孩子修炼
3|我要使用高级物品进行孩子修炼
4|我只是路过看看
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
