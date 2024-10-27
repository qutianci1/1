local NPC = {}
local 对话 = [[
闲坐夜明月，幽人弹素琴。
menu
1|我要带孩子拜师(琴)
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
