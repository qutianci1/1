-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-05-17 17:34:07

local 物品 = {
    名称 = '超级炼妖自选礼包',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
end

local 炼妖表={"灵犀角","武帝袍","云罗帐","五溪散","雪蟾蜍","沧海珠","蓝田玉","烈焰砂","霄汉鼎","忆梦符","辟邪珠"}

function 物品:使用(对象)
    local 文本 = '请选择你一种你想要的炼妖\nmenu\n'
    for i=1,#炼妖表 do
        文本 = 文本 .. i .. '|' .. 炼妖表[i]..'\n'
    end

    local x = 对象:选择窗口(文本)
    if x then
        x = x + 0
        if 炼妖表[x] then
            if 对象:添加物品({ 生成物品 { 名称 = 炼妖表[x] , 参数 = 14 } }) then
                self.数量 = self.数量 - 1
            end
        end
    end
end

function 物品:取描述()
end

return 物品
