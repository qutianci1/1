-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-05-07 09:59:00
local 物品 = {
    名称 = '云罗帐',
    叠加 = 0,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}

function 物品:初始化()
    if not self.参数 then
        self.参数 = 1
    end
end

function 物品:使用(对象)

end

function 物品:取描述()
    return "#Y抗封印 +"..self.参数..'%'
end

return 物品