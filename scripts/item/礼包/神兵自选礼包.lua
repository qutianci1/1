-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2024-04-27 14:04:14

--local 装备库  = require('数据库/神兵库')
local 物品 = {
    名称 = '神兵自选礼包',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
if not self.参数 then
        self.参数=6
    end
end

local 神兵表={"金箍棒","宣花斧","盘古锤","枯骨刀","乾坤无定","芭蕉扇","八景灯","多情环","赤炼鬼爪","毁天灭地","搜魂钩","混天绫","索魂幡","震天戟","缚龙索","斩妖剑","藕丝步云履","混元盘金锁","锁子黄金甲","五彩宝莲衣","凤翅瑶仙簪","紫金七星冠"}

function 物品:使用(对象)
    local x = 对象:神兵窗口(神兵表,self.参数)
    if x then
        for i=1,#神兵表 do
            if 神兵表[i] == x[1] then
                if 对象:添加物品({ 生成装备 { 名称 = x[1] , 等级 = x[2] ,序号=x[3]} }) then
                    self.数量 = self.数量 - 1
                end
            end
        end
    end
end

function 物品:取描述()
end

return 物品
