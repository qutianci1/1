-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2023-09-05 14:05:32

local NPC = {}
local 对话 = [[
凌烟阁地宫被妖魔占据，皇上以我大唐二十四功臣画像悬于凌烟阁镇压，遏制这些妖魔出世，但要扫除这些妖魔永绝后患，还需天下豪杰之力。英雄！你愿意担起这个重任吗？
menu
1|进入地宫
2|了解地宫情况
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(101406, 68, 38)
    elseif i == '2' then
        return '地宫里艰险异常，妖魔奸猾凶狠,很久以前，封印妖魔的英雄最终化成了石像,千百年来守卫着地宫，保得人间安详,找到他们的石像,你会得到指引的。#r每天你最多完成两次地宫挑战,否则容易邪气侵体,对以后修行不利!'
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
