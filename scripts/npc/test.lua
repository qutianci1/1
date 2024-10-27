-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:39
-- @Last Modified time  : 2022-07-19 06:33:33
local NPC = {}
local 对话 = [[你认错人了吧？
menu
物品测试 召唤兽测试
战斗测试
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '战斗测试' then
        --玩家:进入战斗('测试')
    elseif i == '物品测试' then
        --玩家:增加物品(生成道具('四叶花'))
    elseif i == '召唤兽测试' then
    --玩家:增加召唤(生成召唤('大海龟'))
    end
end

return NPC
