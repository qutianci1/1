-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2024-10-14 22:07:52

local 物品 = {
    名称 = '神兽自选礼包',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
end

local _神兽 = {'超级蟾蜍','超级蝙蝠','年','超级蜘蛛','超级海龟','超级毒蛇','超级飞鱼','紫霞仙子','青霞仙子','龙太子','春三十娘','白晶晶','泾河龙王','至尊小宝','牛魔王','浪淘沙','范式之魂','垂云叟','颜如玉','五叶'}

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
