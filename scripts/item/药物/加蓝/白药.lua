local 物品 = {
    名称 = '白药',
    叠加 = 999,
    类别 = 1,
    类型 = 2,
    对象 = 63,
    条件 = 63,
    绑定 = false,
    排序 = 2000
}

function 物品:使用(对象)
    local r
    if 对象.是否玩家 then
        r = 对象:判断是否满血(对象.是否玩家)
    elseif 对象.是否召唤 then
        r = 对象:判断是否满血(对象.是否召唤)
    end
    if not r then
        对象:增减魔法(2000)
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
