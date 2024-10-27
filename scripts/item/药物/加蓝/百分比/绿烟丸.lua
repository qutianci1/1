-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-14 10:18:31
-- @Last Modified time  : 2024-08-24 17:57:50
local 物品 = {
    名称 = '绿烟丸',
    叠加 = 999,
    类别 = 1,
    类型 = 2,
    对象 = 63,
    条件 = 63,
    绑定 = false,
    排序 = 0.4
}

function 物品:使用(对象)
    local r
    if 对象.是否玩家 then
        r = 对象:判断是否满血(对象.是否玩家)
    elseif 对象.是否召唤 then
        r = 对象:判断是否满血(对象.是否召唤)
    end
    if not r then
        local t=对象.最大魔法*0.4
        对象:增减魔法(t)
        self.数量 = self.数量 - 1
    else
        if 对象.是否玩家 then
            对象:提示窗口('#Y你已经满魔！')
        else
            对象:提示窗口('#Y你的召唤已经满魔！')
        end
    end
end

return 物品
