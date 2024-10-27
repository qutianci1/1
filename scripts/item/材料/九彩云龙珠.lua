-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 00:49:34
local 物品 = {
    名称 = '九彩云龙珠',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()
    if not self.价值 then
        self.价值 = 125
    end
end
function 物品:使用(对象)

end
function 物品:取描述()
    return "价值:"..self.价值
end
return 物品