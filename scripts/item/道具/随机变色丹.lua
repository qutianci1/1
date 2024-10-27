-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-08 18:53:33
-- @Last Modified time  : 2023-04-17 08:46:03

local 物品 = {
    名称 = '随机变色丹',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    if 对象:添加物品({生成物品 {名称 = '变色丹', 数量 = 1}}) then
        self.数量 = self.数量 - 1
    end
end

return 物品
