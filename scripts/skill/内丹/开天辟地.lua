-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-08-23 23:26:28
local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '开天辟地',
    种族 = 2
}
local BUFF
function 法术:法术施放(攻击方, 目标)
end

function 法术:公式(召唤)
    local 亲密 = 召唤.亲密
    if 召唤.是否怪物 and 亲密 == 0 then
        亲密 = 5000000
    end
    local ndjl =
    math.floor(
        (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
        1000
    ) * 0.000005;
    ndjl = math.ceil(ndjl * 10000) / 100
    return ndjl
end

function 法术:法术取描述(召唤)
    local ndjl = self:公式(召唤)
    return string.format("此技能在使用仙法攻击的时候有#R%.2f%%#W几率忽视对方的法术抗性。", ndjl)
end

function 法术:计算(召唤)
    return {开天辟地 = self:公式(召唤)}
end

local _bid = { 1301, 1302, 1303, 1314 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '开天辟地',
    名称 = '内丹特效',
    id = 1301
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
-- 取整前=(等级+单位.等级)*0.05*(转生*0.25)+(等级+单位.等级)*0.05*(亲密度^0.05604)--2.4676--41.95
-- 单位.开天辟地=qz(取整前*100)/100
--此技能在使用仙法攻击的时候有一定几率忽视对方的法术抗性。
