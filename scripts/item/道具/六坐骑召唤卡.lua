-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-11-03 17:45:54
local 物品 = {
    名称 = '六坐骑召唤卡',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 0,
    绑定 = false
}

function 物品:初始化()
end

function 物品:使用(对象)
    if not 对象:检测坐骑(6) then
        对象:添加坐骑(6)
        self.数量 = self.数量 - 1
    else
        对象:常规提示('#Y已拥有同类坐骑,无法继续获得')
    end
end

function 物品:取描述()
end

return 物品