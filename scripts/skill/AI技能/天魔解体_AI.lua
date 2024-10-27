-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2023-09-22 01:00:54

-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-09-22 00:46:35
local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '天魔解体_AI',
    种族 = 3,
    id = 1209,
}

function 法术:法术施放(攻击方, 目标)
    if 攻击方.气血 <= 1 then
        return
    end
    local 消耗hp,伤害比 = self:取伤害(攻击方)

    self.xh = 消耗hp
    for _, v in ipairs(目标) do
        攻击方.伤害 = math.floor(伤害比 / 100 * 攻击方.气血)
        v:被法术攻击(攻击方, self)
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少气血(self.xh)
        self.xh=false
    end
end

function 法术:取伤害(召唤)
    local 参数=0
    if 召唤.转生==0 then
        参数=4000
    else
        参数=3755
    end
    local 亲密 = 5000000
    if not self.等级 then
        self.等级 = 召唤.等级
    end
    if not self.转生 then
        self.转生 = 召唤.转生
    end
    local 数值=math.floor((((召唤.等级*self.等级/160000)^(1/2))*(1+0.25*self.转生)+(亲密^(1/6))*self.等级/参数)*1000)/1000+0.01
    local 系数=0
    if 数值 > 0.999 then
        系数=0.999
    else
        系数=数值
    end
    local 换血=math.floor(数值*(召唤.等级*召唤.等级*0.15/(召唤.最大魔法*1+0.01)+0.2)*1000)/1000
    local 牺牲比例=3566
    local 换取比例=math.floor(换血*10000+0.5)/100
    return 牺牲比例, 换取比例
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述(召唤)
    local 消耗hp,伤害比 = self:取伤害(召唤)
    return string.format("通过牺牲自己HP当前的#R%.2f%%#W给对手造成自己HP当前值#R%.2f%%#W的HP伤害。"
        , 消耗hp, 伤害比)
end

-- local _bid = { 1310, 1311, 1312, 1317 }
-- function 法术:切换内丹BUFF(召唤)
--     BUFF.id = _bid[self.转生 + 1]
--     召唤:添加BUFF(BUFF)
-- end

-- local BUFF
-- BUFF = {
--     法术 = '天魔解体',
--     名称 = '内丹特效',
--     id = 1310
-- }
-- 法术.BUFF = BUFF


-- function BUFF:BUFF添加前(buff)
--     if buff.名称 == '内丹特效' then
--         self:删除()
--     end
-- end

return 法术
