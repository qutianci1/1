-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-29 13:01:35
-- @Last Modified time  : 2024-08-24 17:18:00


local 物品 = {
    名称 = '九转龙涎香',
    叠加 = 999,
    类别 = 1,
    类型 = 1,
    对象 = 63,
    条件 = 63,
    绑定 = false,
    排序 = 1800
}

function 物品:使用(对象)
    local r
    if 对象.是否玩家 then
        r = 对象:判断是否满血(对象.是否玩家)
    elseif 对象.是否召唤 then
        r = 对象:判断是否满血(对象.是否召唤)
    end
    if not r then
        对象:增减气血(1800)
        self.数量 = self.数量 - 1
    else
        if 对象.是否玩家 then
            对象:提示窗口('#Y你已经满血！')
        else
            对象:提示窗口('#Y你的召唤已经满血！')
        end
    end
end

return 物品
