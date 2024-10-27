-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-05-17 17:31:09

local 物品 = {
    名称 = '年',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
end

local _神兽 = {'年'}

function 物品:使用(对象)
    local 文本 = '请选择你一种你想要的神兽\nmenu\n'
    for i=1,#_神兽 do
        文本 = 文本 .. i .. '|' .. _神兽[i]..'\n'
    end

    local x = 对象:选择窗口(文本)
    if x then
        x = x + 0
        if _神兽[x] then
            if 对象:添加召唤(生成召唤 { 名称 = _神兽[x] }) then
                self.数量 = self.数量 - 1
            end
        end
    end
end

function 物品:取描述()
end

return 物品
