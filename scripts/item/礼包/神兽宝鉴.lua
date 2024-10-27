-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2024-08-28 20:29:17
local 物品 = {
    名称 = '神兽宝鉴',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _神兽宝盒范围 = {
    { 名称 = '超级蟾蜍', 几率 = 50 },
    { 名称 = '紫霞仙子', 几率 = 50 },
    { 名称 = '超级蝙蝠', 几率 = 10 },
    { 名称 = '超级蜘蛛', 几率 = 50 },
    { 名称 = '浪淘沙', 几率 = 10 },
    { 名称 = '青霞仙子', 几率 = 50 },
    { 名称 = '龙太子', 几率 = 50 },
    { 名称 = '范式之魂', 几率 = 10 },
    { 名称 = '超级海龟', 几率 = 50 },
    { 名称 = '范式之魂', 几率 = 10 },
    { 名称 = '春三十娘', 几率 = 50 },
    { 名称 = '垂云叟', 几率 = 10 },
    { 名称 = '超级毒蛇', 几率 = 50 },
    { 名称 = '颜如玉', 几率 = 10 },
    { 名称 = '白晶晶', 几率 = 50 },
    { 名称 = '五叶', 几率 = 10 },
    { 名称 = '超级飞鱼', 几率 = 50 },
    { 名称 = '泾河龙王', 几率 = 10 },
    { 名称 = '至尊小宝', 几率 = 50 },
    { 名称 = '牛魔王', 几率 = 50 },
}

function 物品:使用(对象)
    local mc = '超级毒蛇'
    for k, v in pairs(_神兽宝盒范围) do
        if math.random(100) <= v.几率 then
            mc = v.名称
            break
        end
    end
    if 对象:添加召唤(生成召唤 { 名称 = mc }) then
        self.数量 = self.数量 - 1
    end


end

return 物品
