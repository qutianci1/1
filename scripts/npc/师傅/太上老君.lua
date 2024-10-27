-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 08:38:04
-- @Last Modified time  : 2024-08-19 13:00:30

local NPC = {}
local 对话1 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
1|我要学习师门技能
2|我想要回长安
]]

local 对话2 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
2|我想要回长安
]]
--其它对话
function NPC:NPC对话(玩家, i)
    if 玩家.种族 == 3 then
        return 对话1
    end
    return 对话2
end
local _smjn = { '雷霆霹雳', '日照光华', '雷神怒击', '电闪雷鸣', '天诛地灭' }
function NPC:NPC菜单(玩家, i)
    if i == '2' then
        玩家:切换地图(1001, 382, 10)
    elseif i == '1' then
        local r = self:技能选项(玩家)
        if r then
            return "你进入门派也有一些日子了,学习一下新技能吧！\nmenu\n5|" .. r
        else
            return "你已经学会了所有门派技能"
        end
    elseif i == '5' then
        local r = self:技能选项(玩家)
        if r then
            玩家:添加技能(r, 1)
            玩家:常规提示(string.format( "#Y你学会了#G%s",r ))
        end
    end
end

function NPC:技能选项(玩家)
    for k, v in ipairs(_smjn) do
        if not 玩家:取技能是否存在(v) then
            return v
        end
    end
end

return NPC
