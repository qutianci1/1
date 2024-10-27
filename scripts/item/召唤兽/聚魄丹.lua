-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-28 20:28:58
-- @Last Modified time  : 2024-08-28 20:45:44
local 物品 = {
    名称 = '聚魄丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:解除技能格子(ture) then
        self.数量 = self.数量 - 1
        对象:提示窗口('#Y你的' .. 对象.名称 .. '已开启一个技能格子！')
    else
        return '#Y 当前召唤兽技能格子已达到上限！'
    end
end

return 物品
