-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-13 08:38:04
-- @Last Modified time  : 2023-04-27 01:30:47

local NPC = {}
local 对话 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
我要学习师门技能
我想要回长安
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '我想要回长安' then
        玩家:切换地图(1001, 380, 12)
    end
end

return NPC
