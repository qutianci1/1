-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-08-24 23:54:21

local 物品 = {
    名称 = '神兵礼盒',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
    if not self.参数 then
        self.参数=1
    end
end

local _武器 = {"金箍棒","宣花斧","盘古锤","枯骨刀","乾坤无定","芭蕉扇","八景灯","多情环","赤炼鬼爪","毁天灭地","搜魂钩","混天绫","索魂幡","震天戟","缚龙索","斩妖剑", }
--local _武器 = {"枯骨刀", }
local _衣服 = { "锁子黄金甲", "五彩宝莲衣" }
local _帽子 = { "凤翅瑶仙簪", "紫金七星冠" }
local _项链 = { "混元盘金锁"}
local _鞋子 = { "藕丝步云履","步定乾坤履"}

function 物品:使用(对象)
    local 名称 = "锁子黄金甲"
    local 几率 = math.random(12)
    if 几率 <= 5 then
        名称 = _武器[math.random(#_武器)]
    elseif 几率 <= 7 then
        名称 = _衣服[math.random(#_衣服)]
    elseif 几率 <= 9 then
        名称 = _帽子[math.random(#_帽子)]
    elseif 几率 <= 10 then
        名称 = _项链[math.random(#_项链)]
    else
        名称 = _鞋子[math.random(#_鞋子)]
    end
    local r = 生成装备 { 名称 = 名称, 等级 = self.参数 }

    if r then
        if 对象:添加物品({r}) then
            self.数量 = self.数量 - 1
            --对象:发送系统("#R%s#C高喊着：一旦拥有，别无所求！爽快打开神兵宝盒得到了#G#m(%s)[%s]#m#n#44"
               -- , 对象.名称, r.nid, r.原名)
        end
    end




end

function 物品:取描述()
        return "#Y获得"..self.参数.."级随机神兵"
end

return 物品
