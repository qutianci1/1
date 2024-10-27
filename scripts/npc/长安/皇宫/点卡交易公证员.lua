-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-10 01:34:22
-- @Last Modified time  : 2024-02-24 13:16:43

local NPC = {}
local 对话 = [[
累计礼包：
#Y10：大话币100W+龙涎丸宝卷*1+玉枢返虚丸*10
100：大话币1000W+3级神兵礼盒*1+落魂砂*50+九玄仙玉*50
500：随机神兽宝盒*1+九转易筋丸*1+5万亲密丹*10
1000：大话币1E+5级神兵礼盒*1+神兵石*5
2000：大话币5E+随机五常神兽宝盒*1+10万亲密丹*10
5000：仙玉50W+神兽自选礼包*1+超级炼妖自选礼包*9
menu
1|我要充值卡密
2|查询赞助
3|再见！充不起！
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
         玩家:兑换卡密()
    elseif i == '2' then
        local 礼包范围 = {10,100,500,1000,2000,5000}
        local 文本 = '当前共计赞助'..玩家.充值..',礼包领取状态如下#r'
        if not 玩家.礼包 then
            玩家.礼包 = {}
        end
        for i=1,#礼包范围 do
            if 玩家.礼包[礼包范围[i]] then
                文本 = 文本..'#W累计'..礼包范围[i]..'礼包#G已领取#r'
            else
                文本 = 文本..'#W累计'..礼包范围[i]..'礼包#R未领取#r'
            end
        end
        return 文本
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
