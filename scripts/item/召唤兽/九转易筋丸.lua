local 物品 = {
    名称 = '九转易筋丸',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:使用九转易筋丸() then
        self.数量 = self.数量 - 1
        对象:常规提示('#Y%s使用了#G九转易筋丸#Y发生了些许变化！#145',对象.名称)
    else
        return '#Y 转生过的召唤兽无法食用！'
    end
end

return 物品
