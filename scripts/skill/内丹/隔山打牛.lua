-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-08 19:32:35
-- @Last Modified time  : 2023-08-23 23:27:13

local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '隔山打牛',
    种族 = 1
}

local BUFF
function 法术:物理攻击(攻击方, 受击方)
    local ndjl, ndcd = self:取内丹(攻击方)
    if math.random(100) < ndjl then
        if (攻击方.位置 > 10 and 受击方.位置 < 10) or (攻击方.位置 < 10 and 受击方.位置 > 10) then
            local dst = 攻击方:随机敌方(
                1,
                function(v)
                    if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') and (not 受击方 or 受击方 ~= v ) then
                        return true
                    end
                end
            )

            if dst[1] then
                攻击方.伤害 = math.floor(攻击方.伤害 * ndcd * 0.01)
                if 攻击方.伤害 < 1 then
                    攻击方.伤害 = 1
                end
                dst[1]:被法术攻击(攻击方)
            end
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
    math.floor(
        ((召唤.等级 * 召唤.等级 * 0.2) / (召唤.最大魔法 * 1 + 1) + ndjl * 3) * 1000
    ) / 1000;
    ndjl = math.ceil(ndjl * 10000) / 100
    ndcd = math.ceil(ndcd * 10000) / 100
    return ndjl, ndcd
end

function 法术:法术取描述(召唤)
    local ndjl, ndcd = self:取内丹(召唤)
    return string.format("物理攻击的时候有#R%.2f%%#W的几率对攻击对象周围的目标造成攻击值的#R%.2f%%#W的伤害。"
        , ndjl, ndcd)
end

local _bid = { 1304, 1305, 1306, 1315 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '隔山打牛',
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
-- 取整前=(等级+单位.等级)*0.05*(转生*0.25)+(等级+单位.等级)*0.05*(亲密度^0.05604)--2.4676--41.95
-- 取整前2=(等级+单位.等级)*0.15*(转生*0.25)+(等级+单位.等级)*0.15*(亲密度^0.056015)--2.4666-125.8
-- 单位.隔山打牛={}
-- 单位.隔山打牛.几率=qz(取整前*100)/100
-- 单位.隔山打牛.伤害百分比=qz(取整前2*100)/100
--伤害=伤害*伤害百分比
-- function 战斗处理类:取隔山伤害(数额,编号,目标)
--     local 伤害 = 0
--     伤害=qz(数额*self.参战单位[编号].隔山打牛.伤害*0.01)
--     if self.参战单位[目标].尘埃落定~=nil then
--       伤害=伤害-self.参战单位[目标].尘埃落定
--     end
--     if 伤害<1 then
--       伤害=1
--     end
--     return qz(伤害)
--   end
--   隔山打牛 = "物理攻击的时候有一定几率对攻击对象周围的某个目标造成伤害。",
