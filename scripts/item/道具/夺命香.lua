-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-05-15 11:39:20
local 物品 = {
    名称 = '夺命香',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
end

function 物品:使用(对象)
    对象:添加任务('夺命香')
    self.数量 = self.数量 - 1
    对象:常规提示("#Y你使用了夺命香,冲动是魔鬼,请谨慎行事")
end

function 物品:取描述()
end

return 物品
