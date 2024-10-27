-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2023-11-19 17:43:31

local NPC = {}
local 对话 = [[
足不出户，便晓天下大事，轻轻一按，信息信手拈来。你好！我是水陆大会百晓生，有什么我能帮助你的吗#55
menu
1|查询积分情况
2|水陆积分兑换
3|离开
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.积分.水陆积分 then
            玩家.积分.水陆积分 = 0
        end
        return '你当前拥有#G'..玩家.积分.水陆积分..'#W水陆积分'
    elseif i == '2' then
        if not 玩家.积分.水陆积分 then
            玩家.积分.水陆积分 = 0
        end
        玩家:购买窗口('scripts/shop/水陆积分.lua')
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
