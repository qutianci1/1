local NPC = {}
local 对话 = [[
你想换种族么？想换你就说啊，你不说我怎么知道你想换种族呢？你虽然很有诚意的看着我，但我还是知道你是想换种族的。不可能你想换种族我不给你换啊？你到底要不要换种族呢？
menu
1|我受不了了，我要换种族
2|我先了解以下规则先
99|离开
]]
-- 2|我想重设修正
-- 4|确认本世修正
-- 5|我要开启第二套属性
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local 种族, 性别, 外形 = 玩家:换角色窗口(玩家.转生)
        if 种族 then
            local r = 玩家:换角色检测()
            if r then
                return r
            end
            玩家:换角色处理(种族, 性别, 外形)
        end
    elseif i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    end
end

return NPC
