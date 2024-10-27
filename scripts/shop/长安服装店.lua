-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-17 00:52:55
-- @Last Modified time  : 2023-04-15 01:00:53
local 商店 = {}

local list = {
    { 类别 = "普通装备", 名称 = "纶巾", 价格 = 10000 },
    { 类别 = "普通装备", 名称 = "金钗", 价格 = 10000 },
    { 类别 = "普通装备", 名称 = "胸甲", 价格 = 10000 },
    { 类别 = "普通装备", 名称 = "纱裙", 价格 = 10000 },
    { 类别 = "普通装备", 名称 = "五色飞石", 价格 = 10000 },
    { 类别 = "普通装备", 名称 = "牛皮靴", 价格 = 10000 },
    { 类别 = "普通装备", 名称 = "书生巾", 价格 = 20000 },
    { 类别 = "普通装备", 名称 = "玉钗", 价格 = 20000 },
    { 类别 = "普通装备", 名称 = "夜魔披风", 价格 = 20000 },
    { 类别 = "普通装备", 名称 = "丝绸长裙", 价格 = 20000 },
    { 类别 = "普通装备", 名称 = "水晶珠链", 价格 = 20000 },
    { 类别 = "普通装备", 名称 = "神行靴", 价格 = 20000 }
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
        if not 第一 then
            return '#Y商品信息错误'
        end
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
