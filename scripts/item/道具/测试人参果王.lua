-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-07-27 20:46:54
-- @Last Modified time  : 2024-07-29 11:25:04
local 物品 = {
    名称 = '测试人参果王',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加经验(99999999) then
        self.数量 = self.数量 - 1
    else
        对象:提示窗口('#Y 你等级已经达到上限，无法食用！')
    end
end

return 物品
