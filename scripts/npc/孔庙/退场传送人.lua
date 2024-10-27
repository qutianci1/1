-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-26 01:59:55
-- @Last Modified time  : 2023-08-25 03:38:16

local NPC = {}
local 对话 = [[暮春之时,万物生发。为祈祷风调雨顺谷物丰收，慰劳我大唐辛勤的子民们，唐王授意我等举办这热闹的梨园庙会，邀请三界子民前去游玩，欣赏那世代相传的民间曲艺以及玩乐风俗，不知意下如何?
menu
1|我要离场
2|点错了
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1001, 255, 138)
    end
end

return NPC
