-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-13 13:00:45
-- @Last Modified time  : 2023-05-13 13:05:44

local 物品 = {
    名称 = '帮派成就册',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:初始化()
    if not self.参数 then
        self.参数 = 1000
    end
end
function 物品:使用(对象)
    if 对象:添加成就(self.参数) then
        self.数量 = self.数量 - 1
    end
end

function 物品:取描述()
    if self.参数 then
        return '#Y帮派成就：'..self.参数..'点'
    end
end

return 物品