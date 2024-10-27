-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2023-05-17 19:00:40
local 物品 = {
    名称 = 'vip4',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加物品({
        生成物品 { 名称 = '银票', 参数 = 200000000, 属性="#Y增加银两 200000000", 数量 = 1 },
        生成物品 { 名称 = '帮派成就册', 参数 = 100000,属性="#Y增加帮派成就 100000", 数量 = 1 },
        生成物品 { 名称 = '亲密丹', 参数=100000,属性="#Y增加亲密度 100000", 数量 = 100 },
		生成物品 { 名称 = '神兵石', 数量 = 20 },
        生成物品 { 名称 = '补天神石', 数量 = 50 },
        生成物品 { 名称 = '盘古精铁', 数量 = 50 },
        生成物品 { 名称 = '天外飞石', 数量 = 50 },
        生成物品 { 名称 = '四级神兵自选', 数量 = 1 },
        生成物品 { 名称 = '清盈果',属性="#Y恢复1000点体力", 数量 = 100 },
        生成物品 { 名称 = '冥灵妃子封印卡', 数量 = 1 },
        生成物品 { 名称 = '超级元气丹', 数量 = 2 },
        生成物品 { 名称 = '神兽宝鉴', 数量 = 1 },
        生成物品 { 名称 = '三界召集令', 数量 = 1 },
    }) then
        self.数量 = self.数量 - 1
    end

end

return 物品
