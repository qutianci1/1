-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-09-04 04:06:23
-- @Last Modified time  : 2023-09-04 10:06:21

local NPC = {}
local 对话 = [[
我守卫这里千年，渐渐化成了一尊石像，如今，妖魔利用幻境掩藏自己，一旦修炼有成，它们定然要危害人间，可惜我已经无力去破除。不过，我可以送你们进入它们隐藏的幻境，来自尘世的英雄，你们愿意前去降服那些妖魔吗?
menu
1|愿意
2|我要出地宫
2|我再准备一下
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1291, 74, 58)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
