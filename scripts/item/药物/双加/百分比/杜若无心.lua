-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-14 10:18:31
-- @Last Modified time  : 2024-08-24 18:08:39
local 物品 = {
    名称 = '杜若无心',
    叠加 = 999,
    类别 = 1,
    类型 = 3,
    对象 = 63,
    条件 = 63,
    绑定 = false,
    排序 = 0.5
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
        local q=对象.最大气血*0.5
        local m=对象.最大魔法*0.5
        对象:双加(q,m)
        self.数量 = self.数量 - 1
    end
end

return 物品
