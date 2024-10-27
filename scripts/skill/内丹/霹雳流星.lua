-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-24 09:47:51
-- @Last Modified time  : 2023-08-23 23:26:15
local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '霹雳流星',
    id = 604,
    是否物理法术 = true,
    种族 = 4
}

local BUFF
function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) < self:取几率(攻击方) then --
            攻击方.伤害 = self:取伤害(攻击方, 挨打方) --
            挨打方:被法术攻击(攻击方)
            return true
        end
    end
end

function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.0002364957 * math.pow(攻击方.最大魔法, 1.57));
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local 亲密 = 召唤.亲密
    if 召唤.是否怪物 and 亲密 == 0 then
        亲密 = 5000000
    end
    local ndjl =
    math.floor(
        (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
        1000
    ) * 0.000004;

    ndjl = math.ceil(ndjl * 10000) / 100
    return ndjl
end

function 法术:法术取描述(召唤)
    local ndjl = self:取几率(召唤)
    local ndcd = math.floor(296.1572 + 0.0002364957 * math.pow(召唤.最大魔法, 1.57));
    return string.format("在物理攻击的时候有#R%.2f%%#W的几率产生#R%s#W雷系法术伤害。", ndjl, ndcd)
end

local _bid = { 1307, 1308, 1309, 1316 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '霹雳流星',
    名称 = '内丹特效',
    id = 1307
}
法术.BUFF = BUFF


function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术

-- 取整前=(转生*3.4)+(等级+单位.等级)*0.05*(1+亲密度^0.00999)
-- 单位.乘风破浪=qz(取整前*100)/100--几率
--local 伤害 = qz(296.1572+0.0002364957*self.参战单位[编号].最大魔法^1.57)
--  伤害=伤害*(1+self.参战单位[我].加强雷/100)*(1-self.参战单位[敌].抗雷/100+self.参战单位[我].忽视抗雷/100)-
-- 伤害=self:强克伤害加成(我,敌,伤害)
--特效==    id = 604,
