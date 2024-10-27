-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-08 07:06:01
-- @Last Modified time  : 2023-05-08 07:22:40

local 物品 = {
    名称 = '坐骑经验书',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    local r = 对象:取乘骑坐骑()
    if r then
        r:添加经验(500)
        对象:提示窗口('#W你的坐骑#Y'..r.名称.."#W增加了#R500#W点经验。")
        self.数量 = self.数量 - 1
    else
        对象:常规提示("#Y未找到当前坐骑！")
    end
end

return 物品
