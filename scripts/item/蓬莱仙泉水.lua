-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2022-08-06 16:13:39
local 物品 = {
    名称 = '蓬莱仙泉水',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)

    if 对象:添加任务('蓬莱仙泉水') then
        self.数量 = self.数量 - 1
    end

end

return 物品
