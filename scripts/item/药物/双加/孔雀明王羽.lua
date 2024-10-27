-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-14 10:18:31
-- @Last Modified time  : 2024-08-24 18:08:20
local 物品 = {
    名称 = '孔雀明王羽',
    叠加 = 999,
    类别 = 1,
    类型 = 3,
    对象 = 63,
    条件 = 63,
    绑定 = false,
    排序 = 45000
}

function 物品:使用(对象)
    local r , t
    if 对象.是否玩家 then
        r = 对象:判断是否满血(对象.是否玩家)
        t = 对象:判断是否满蓝(对象.是否玩家)
    elseif 对象.是否召唤 then
        r = 对象:判断是否满血(对象.是否召唤)
        t = 对象:判断是否满蓝(对象.是否召唤)
    end
    if r and t then
        if 对象.是否玩家 then
            对象:提示窗口('#Y你已经满状态！')
        else
            对象:提示窗口('#Y你的召唤已经满状态！')
        end
    else
        对象:双加(45000,45000)
        self.数量 = self.数量 - 1
    end
end

return 物品
