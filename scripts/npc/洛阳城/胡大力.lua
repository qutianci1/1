local NPC = {}
local 对话 = [[
在这里你可以查看兵器谱的排名情况，你想查看吗？
menu
1|我就是来查看的
2|我只是路过看看
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
