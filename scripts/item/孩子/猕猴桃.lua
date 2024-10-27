-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2024-02-15 19:03:33

local 物品 = {
    名称 = '猕猴桃',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 4,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()
end
function 物品:使用(对象)
    self.数量 = self.数量 - 1
end
function 物品:取描述()

end
return 物品
