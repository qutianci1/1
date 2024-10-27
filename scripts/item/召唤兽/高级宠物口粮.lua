-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-10-11 21:35:59
-- @Last Modified time  : 2024-10-16 15:44:41

local 物品 = {
    名称 = '高级宠物口粮',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    local r = 对象:添加忠诚度(99)
    if  r ==true then
        self.数量=self.数量-1
    else
        return '#Y 当前召唤兽食用数量已达上限！'
    end

end

return 物品
