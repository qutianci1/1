-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-23 23:14:45
-- @Last Modified time  : 2023-06-29 21:26:50

local 物品 = {
    名称 = '修正卡',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.转生 < 1 then
        对象:提示窗口('#Y你还没有转生,无法使用修正卡')
        return
    end
    local 转生 = 对象.转生
    local 已选 = 0
    local 判断 = 1
    local 新修正 = {}
    local 文本 = {
        [1] = '请重新选择你的一世修正\nmenu\n1|男人\n2|男魔\n3|男仙\n4|男鬼\n5|女人\n6|女魔\n7|女仙\n8|女鬼',
        [2] = '请重新选择你的二世修正\nmenu\n1|男人\n2|男魔\n3|男仙\n4|男鬼\n5|女人\n6|女魔\n7|女仙\n8|女鬼',
        [3] = '请重新选择你的三世修正\nmenu\n1|男人\n2|男魔\n3|男仙\n4|男鬼\n5|女人\n6|女魔\n7|女仙\n8|女鬼',
    }
    local a = 1
    while 已选 < 转生 do
        local x
        if 已选 ~= 判断 then
            x = 对象:选择窗口(文本[a])
            判断 = 已选
        end
        if x then
            x = x + 0
            a = a + 1
            已选 = 已选 + 1
            local 性别 = 1
            local 种族 = 0
            if x > 4 then 性别 = 2 end
            if x == 1 or x == 5 then
                种族 = 1
            elseif x == 2 or x == 6 then
                种族 = 2
            elseif x == 3 or x == 7 then
                种族 = 3
            elseif x == 4 or x == 8 then
                种族 = 4
            end
            table.insert(新修正, 种族 * 1000 + 性别)
        end
    end

    if 已选 == 转生 then
        对象:重选修正(新修正)
        self.数量 = self.数量 - 1
    end
end

return 物品
