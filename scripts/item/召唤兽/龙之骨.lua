-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-04-30 04:36:02

local 物品 = {
    名称 = '龙之骨',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    if 对象:使用龙之骨() then
        self.数量=self.数量-1
    else
        return '#Y 当前召唤兽食用数量已达上限！'
    end

end

return 物品
