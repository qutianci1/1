local 物品 = {
    名称 = '混元丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:洗点() then
        self.数量 = self.数量 - 1
    else
        return '#Y当前召唤兽尚未加点！'
    end
end

return 物品
