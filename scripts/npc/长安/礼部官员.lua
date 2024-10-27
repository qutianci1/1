-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-26 01:59:55
-- @Last Modified time  : 2023-08-25 03:33:33

local NPC = {}
local 对话 = {
    [[暮春之时,万物生发。为祈祷风调雨顺谷物丰收，慰劳我大唐辛勤的子民们，唐王授意我等举办这热闹的梨园庙会，邀请三界子民前去游玩，欣赏那世代相传的民间曲艺以及玩乐风俗，不知意下如何?
menu
99|劳动人民光荣！
]],
    [[暮春之时,万物生发。为祈祷风调雨顺谷物丰收，慰劳我大唐辛勤的子民们，唐王授意我等举办这热闹的梨园庙会，邀请三界子民前去游玩，欣赏那世代相传的民间曲艺以及玩乐风俗，不知意下如何?
menu
1|带我去观赏庙会
2|带我去参加擂台赛
99|劳动人民光荣！
]]
}
function NPC:NPC对话(玩家, i)
    if os.date('%w', os.time()) == '5' then
        return 对话[2]
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(101386, 7, 26)
    elseif i == '2' then
        玩家:切换地图(101386, 46, 56)
    end
end

return NPC
