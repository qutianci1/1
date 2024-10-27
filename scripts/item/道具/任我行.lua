-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2024-04-13 06:12:56
local 物品 = {
    名称 = '任我行',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 0,
    绑定 = false
}

function 物品:初始化()
end

function 物品:使用(对象)
    对象:添加称谓('任我行')
    self.数量 = self.数量 - 1
end

function 物品:取描述()
end

return 物品