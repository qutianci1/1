-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-08-23 23:26:29
local 法术 = {
    类别 = '内丹',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '小楼夜哭',
    种族 = 3,
    id = 1212,
}

function 法术:法术施放(攻击方, 目标)
    if 攻击方.气血 <= 1 then
        return
    end
    local 消耗mp,伤害比 = self:取伤害(攻击方)
    self.xh = 消耗mp / 100
    for _, v in ipairs(目标) do
        攻击方.伤害 = math.floor(伤害比 / 100 * 攻击方.魔法)
        v:被法术攻击(攻击方, self)
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(math.floor(self.xh * 攻击方.魔法))
        self.xh=false
    end
end

function 法术:取伤害(召唤)
    local 亲密 = 召唤.亲密
    if 召唤.是否怪物 and 亲密 == 0 then
        亲密 = 5000000
    end
    local 数值=math.floor((((召唤.等级*self.等级/206600)^(1/2))*(1+0.25*self.转生)+(亲密^(1/6))*self.等级/4170)*1000)/1000+0.01
    local 系数=0
    if 数值>0.999 then
      系数=0.999
    else
      系数=数值
    end
    local 换蓝=数值*0.3
    local 牺牲比例=math.floor(系数*10000+0.5)/100
    local 换取比例=math.floor(换蓝*10000+0.5)/100

    return 牺牲比例, 换取比例
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述(召唤)
    local 消耗mp,伤害比 = self:取伤害(召唤)
    return string.format("通过牺牲自己MP当前的#R%.2f%%#W给对手造成自己MP当前值#R%.2f%%#W的MP伤害。"
        , 消耗mp, 伤害比)
end

local _bid = { 1310, 1311, 1312, 1317 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

local BUFF
BUFF = {
    法术 = '青面獠牙',
    名称 = '内丹特效',
    id = 1310
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
-- 单位.主动技能[#单位.主动技能+1]={名称="小楼夜哭",熟练度=单位.等级}
-- 取整前=(等级+单位.等级)*0.1129*(转生*0.25)+(等级+单位.等级)*0.1129*(亲密度^0.058254)
-- 取整前2=(等级+单位.等级)*0.0338*(转生*0.25)+(等级+单位.等级)*0.0338*(亲密度^0.058254)
-- if 取整前>99.99 then
--   取整前=99.99
-- end
-- 单位.小楼夜哭={}
-- 单位.小楼夜哭.伤害基础=0
-- 单位.小楼夜哭.消耗=qz(取整前*100)/100
-- 单位.小楼夜哭.伤害=qz(取整前2*100)/100
--    小楼夜哭 = "此技能通过牺牲自己的MP给对手造成MP伤害。",
