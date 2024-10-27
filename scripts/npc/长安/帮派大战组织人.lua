
local NPC = {}
local 对话1 = [[
我这可以将你传送到帮战比武场，需要进去吗？
menu
帮战入场
我再想想
]]
local 对话2 = [[
我这可以将你传送到帮战比武场，需要进去吗？
menu
啥也不干
]]

function NPC:NPC对话(玩家, i)
    return 对话1
end

function NPC:NPC菜单(玩家, i)
    if i == '帮战入场' then
        return 玩家:帮战入场()
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC

--看我操作怎么测试帮战0k