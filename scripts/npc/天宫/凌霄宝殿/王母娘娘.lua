local NPC = {}
local 对话 = [[
天上一日，地上一年。
menu
1|进入灵兽园10分钟(需低级搜寻令)
2|进入灵兽园20分钟(需中级搜寻令+100W银子)
3|进入灵兽园30分钟(需高级搜寻令+300W银子)
4|我在想想
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
