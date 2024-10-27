-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2024-02-16 16:21:00

local 物品 = {
    名称 = '孝经',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 4,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化(t)
    local sj = math.random(1, 5)
    self.属性 = {
        气质 = 0,
        悟性 = 0,
        智力 = 0,
        耐力 = 0,
        内力 = 0,
        亲密 = 0,
        孝心 = sj,
    }
end
function 物品:使用(对象)
    self.数量 = self.数量 - 1
end
function 物品:取描述()

end
return 物品
