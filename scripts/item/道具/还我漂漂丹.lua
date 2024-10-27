-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-05-15 12:21:34
local 物品 = {
    名称 = '还我漂漂丹',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
end

function 物品:使用(对象)
    local r = 对象:取任务('变身卡')
    if r then
        r.外形 = 对象.原形
        对象:刷新外形()
        self.数量 = self.数量 - 1
    else
        对象:常规提示("#Y你并没有使用变身卡")
    end
end

function 物品:取描述()
end

return 物品
