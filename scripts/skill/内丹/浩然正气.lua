-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-24 09:47:51
-- @Last Modified time  : 2023-08-23 23:26:25
local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '浩然正气',
    id = 1213,
    是否物理法术 = true,
    种族 = 1
}

local BUFF
function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        local ndjl, ndcd = self:取内丹(攻击方)
        if math.random(100) < ndjl then
            攻击方.伤害 = math.floor(攻击方.最大魔法 * ndcd * 0.01)
            if 攻击方.伤害 < 1 then
                攻击方.伤害 = 1
            end
            挨打方:被法术攻击(攻击方)
            return true
        end
    end
end

function 法术:取内丹(召唤)
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

    local ndcd =
    math.floor(((召唤.等级 * 召唤.等级 * 0.2) / (召唤.最大魔法 * 1 + 1) + ndjl) * 10000) /
        10000;
    ndjl = math.ceil(ndjl * 10000) / 100
    ndcd = math.ceil(ndcd * 10000) / 100
    return ndjl, ndcd

end

function 法术:法术取描述(召唤)
    local ndjl, ndcd = self:取内丹(召唤)
    return string.format("召唤兽物理攻击，有#R%.2f%%#W几率附加造成按对方自身法力#R%.2f%%#W的伤害。"
        , ndjl, ndcd)
end

local _bid = { 1304, 1305, 1306, 1315 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '浩然正气',
    名称 = '内丹特效',
    id = 1304
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
-- 取整前= (0.06 * self.等级 + 0.04 * 召唤.等级) * (self.转生 * 0.25) + (0.06 * self.等级 + 0.04 * 召唤.等级)*(1+召唤.亲密^0.04)--2.4679--83.91
-- 单位.浩然正气=qz(取整前*100)/100
-- function 战斗处理类:取浩然伤害(编号,目标)
--     local MP值 = self.参战单位[编号].最大魔法
--     if MP值<10000 then
--     MP值=10000
--     end
--     local 伤害 = 0
--     伤害=qz((self.参战单位[编号].浩然正气+577900/MP值)*self.参战单位[目标].最大魔法*0.01)
--     if self.参战单位[目标].上善若水~=nil then
--       伤害=伤害-self.参战单位[目标].上善若水
--     end
--     if 伤害<1 then
--       伤害=1
--     end
--     return qz(伤害)
--   end
--    浩然正气 = "召唤兽物理攻击，有几率附加造成按对方自身法力百分比的伤害。",
