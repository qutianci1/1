local 物品 = {
    名称 = '伐骨洗髓丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:清空龙之骨() then
        self.数量 = self.数量 - 1
    else
        return '#Y当前召唤兽尚未未食用过龙之骨！'
    end
end

return 物品
