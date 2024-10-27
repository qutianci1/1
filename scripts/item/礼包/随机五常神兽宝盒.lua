-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2023-05-14 02:15:11
local 物品 = {
    名称 = '随机五常神兽宝盒',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _五常神兽宝盒范围 = {
    { 名称 = '浪淘沙', 几率 = 60 },
    { 名称 = '范式之魂', 几率 = 60 },
    { 名称 = '垂云叟', 几率 = 60 },
    { 名称 = '颜如玉', 几率 = 60 },
    { 名称 = '五叶', 几率 = 100 },
}
function 物品:使用(对象)
    local mc = '猴精'
    for k, v in pairs(_五常神兽宝盒范围) do
        if math.random(100) <= v.几率 then
            mc = v.名称
            break
        end

    end
    if 对象:添加召唤(生成召唤 { 名称 =mc }) then
        self.数量 = self.数量 - 1
    end


end

return 物品
