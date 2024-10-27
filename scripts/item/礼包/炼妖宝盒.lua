-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2023-05-14 02:15:04
local 物品 = {
    名称 = '炼妖宝盒',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local 炼妖表={"灵犀角","武帝袍","云罗帐","五溪散","雪蟾蜍","沧海珠","蓝田玉","烈焰砂","霄汉鼎","忆梦符","辟邪珠",'盘古石'}
    local 随机 = math.random(1, #炼妖表)
    local 参数 = math.random(1100, 1300) / 100
    参数 = string.format("%.1f", 参数)
    -- 炼妖表[随机] = '盘古石'
    if 炼妖表[随机] == '盘古石' then
        参数 = {}
        for i = 1, 4 do
            local rand_num = math.random(50, 60) / 10
            table.insert(参数, rand_num)
        end
    end
    if 对象:添加物品({ 生成物品 { 名称 = 炼妖表[随机], 参数 = 参数 } }) then
        self.数量 = self.数量 - 1
    end

end

return 物品
