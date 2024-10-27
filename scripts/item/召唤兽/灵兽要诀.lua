-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-28 20:28:58
-- @Last Modified time  : 2024-08-28 20:45:44
local 物品 = {
    名称 = '灵兽要诀',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加领悟技能(ture) then
        self.数量 = self.数量 - 1
        对象:提示窗口('#Y你的' .. 对象.名称 .. '学会了一个技能！')
    else
        return '#Y 当前召唤兽技能格子已达到上限，无法继续学习！'
    end
end

return 物品
