local 物品 = {
    名称 = '宝象遁行符',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = true,
}

function 物品:使用(对象)
    if not 对象.是否队长 then
        对象:提示窗口('#Y只有队长才可以使用飞行道具')
        return
    end

    for _, b in 对象:遍历队友() do
        for _, v in b:遍历任务() do
            if v.飞行限制 then
                for _, d in 对象:遍历队友() do
                    d:提示窗口('#Y%s身上有限制飞行的任务！', v.名称)
                end
                return
            end
        end
    end
    对象:切换地图(101529, 88, 86)
    self.数量 = self.数量 - 1
end





return 物品