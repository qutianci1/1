-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2024-02-24 12:02:32

local NPC = {}
local 对话 = [[
我大唐英雄，入凌烟阁地宫降妖除魔，胜者，唐王以功绩论赏！#r#R注意预留物品栏和召唤兽栏避免损失
menu
1|我要兑换物品
2|了解功绩兑换规则
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/地宫兑换.lua')
    elseif i == '2' then
        return '除了随便奖励外，所有奖励都会在每次成功兑换时上涨部分积分,上涨积分有上限,达到上限则停止上涨。每日凌晨12点所有会涨价的奖励都会回落一些价格，但不会低于最初兑换价格。'
    elseif i == '3' then
    end
end

return NPC
