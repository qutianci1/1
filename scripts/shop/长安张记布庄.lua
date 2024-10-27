-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-17 00:52:55
-- @Last Modified time  : 2022-09-02 09:56:56
local 商店 = {}

local list = {
    { 类别 = "普通装备", 名称 = "鹅毛帽", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "凤头钗", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "妖气斗篷", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "五彩裙", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "舍利珠", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "追星踏月", 价格 = 40000 },
}

function 商店:取商品()
    return list
end

function 商店:购买(玩家, i, n)
    local 总价 = n * list[i].价格
    if 玩家.银子 >= 总价 then
        local t = 复制表(list[i])
        t.类别 = nil
        t.价格 = nil
        local 物品表 = {}
        local 第一 = 生成装备(t)
        if 第一.是否叠加 then
            第一.数量 = n
            table.insert(物品表, 第一)
        else
            for _ = 1, n do
                table.insert(物品表, 生成装备(t))
            end
        end
        if 玩家:添加物品_无提示(物品表) then
            玩家:扣除银子(总价)
            玩家:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s银两。',  n,t.名称, 总价)
            return true
        else
            return '#Y空间不足'
        end

    else
        return '#Y你的银两不足，不能购买！'
    end
end

return 商店
