local NPC = {}
local 对话 = [[
吾乃是守护天帝宝库大将。
menu
1|我要进入下一层
2|我要返回上一层
3|我什么都不想做

	放弃
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
