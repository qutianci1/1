-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-05-07 09:59:25
local 物品 = {
    名称 = '盘古石',
    叠加 = 0,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    绑定 = false,
}

function 物品:初始化()
    if not self.参数 then
        self.参数 = {1,2,3,4}
    end
end

function 物品:使用(对象)

end

function 物品:取描述()
    return "#Y抗风 +"..self.参数[1]..'%, 抗水 +'..self.参数[2]..'%, 抗雷 +'..self.参数[3]..'%, 抗火 +'..self.参数[4]..'%'
end

return 物品