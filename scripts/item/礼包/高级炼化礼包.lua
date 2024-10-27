-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2023-05-17 19:00:40
local 物品 = {
    名称 = '高级炼化礼包',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加物品({
        生成物品 { 名称 = '九彩云龙珠', 数量 = 297, 价值 = 165 },
        生成物品 { 名称 = '血玲珑', 数量 = 99 },
        生成物品 { 名称 = '内丹精华', 数量 = 99 },

    }) then
        self.数量 = self.数量 - 1
    end

end

return 物品
