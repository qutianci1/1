-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-17 00:52:55
-- @Last Modified time  : 2022-09-02 09:56:27
local 商店 = {}

local list = {
    { 类别 = "普通装备", 名称 = "血刀", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "浑元金", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "银斧", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "万里灭云棍", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "明月扇", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "龙须拂尘", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "玄铁重剑", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "电闪雷鸣鞭", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "方天画戟", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "勾魂幡", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "云龙绸带", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "离别钩", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "狼牙拳套", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "胭脂血", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "占星之卷", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "镶刺银环", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "苏绣灯笼", 价格 = 60000 },
    { 类别 = "普通装备", 名称 = "诛仙", 价格 = 60000 },
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
        for _ = 1, n do
            table.insert(物品表, 生成装备(t))
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
