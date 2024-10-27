local NPC = {}
local 对话 = [[
这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话需要消耗一个天机密令哦！
menu
1|我要挑战普通难度
2|我要挑战困难难度
3|我要挑战卓越难度
4|我要挑战炼狱难度
5|妖怪太强大，快送回家
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
