-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-05-17 19:46:00

local 物品 = {
    名称 = '鬼狱灵反符',
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
    对象:切换地图(1124, 18, 16)
    self.数量 = self.数量 - 1
end

return 物品