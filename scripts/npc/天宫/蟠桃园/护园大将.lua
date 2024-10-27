local NPC = {}
local 对话 = [[
我是护园大将,在这里帮王母娘娘看守蟠桃园的日子已经数不清了,很想去见见以前的一些朋友,哎
menu
1|有什么可以帮助你的？(领取200环任务链)
2|我只是看看
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
