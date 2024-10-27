-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-17 00:52:55
-- @Last Modified time  : 2023-09-06 18:13:06
local 商店 = {}

local list = {
    --{ 类别 = "道具", 名称 = "召唤兽宝卷", 价格 = 3200 },
    { 类别 = "道具", 名称 = "神兵礼盒", 价格 = 100 },
    { 类别 = "道具", 名称 = "龙之骨奖励", 价格 = 500 },
    { 类别 = "道具", 名称 = "龙涎丸奖励", 价格 = 500 },
    { 类别 = "道具", 名称 = "筋骨提气丸", 价格 = 500 },
    { 类别 = "道具", 名称 = "神兽碎片", 价格 = 200 },
    --{ 类别 = "道具", 名称 = "随便", 价格 = 50 },
    { 类别 = "道具", 名称 = "仙器礼盒", 价格 = 1 },
    { 类别 = '道具', 名称 = '仙器礼盒',参数=3,属性="#Y获得3阶随机仙器", 价格 = 199 }
}

function 商店:取商品()
    return list
end


    function 商店:购买(玩家, i, n)
    local 总价 = n * list[i].价格
    local 积分 = 玩家.积分.功绩 or 0
    if 积分 >= 总价 then
        local t = 复制表(list[i])
        t.类别 = nil
        t.价格 = nil
        local 物品表 = {}
        local 第一 = 生成物品(t)
        if 第一.是否叠加 then
            第一.数量 = n
            table.insert(物品表, 第一)
        else
            for _ = 1, n do
                table.insert(物品表, 生成物品(t))
            end
        end
        if 玩家:添加物品_无提示(物品表) then
            玩家:扣除积分('功绩',总价)
            玩家:提示窗口('#Y你兑换了%s个#G%s#Y,共消耗%s积分。',  n,t.名称, 总价)
            return true
        else
            return '#Y空间不足'
        end
    else
        return '#Y你的积分不足，兑换失败！'
    end
end

return 商店

