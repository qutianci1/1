-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2024-10-15 00:43:20

local 物品 = {
    名称 = '凝精聚气丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}
function 物品:初始化()

end

function 物品:使用(对象)
    if 对象:添加聚气丹经验(500000) then
        self.数量=self.数量-1
    else
        对象:提示窗口('#Y召唤兽内丹等级已达上限或身上没有内丹。')
    end
end




return 物品
