-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-04-24 19:57:32

local 物品 = {
    名称 = '清盈果',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加体力(50) then
        self.数量 = self.数量 - 1
        对象:常规提示("#Y你恢复了50点体力！")
    end
end

return 物品
