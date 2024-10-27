-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-09-22 00:56:40
local 法术 = {
    类别 = '内丹',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '天魔解体',
    种族 = 3,
    id = 1209,
}
local BUFF
function 法术:法术施放(攻击方, 目标)
    if 攻击方.气血 <= 1 then
        return
    end
    local 消耗hp,伤害比 = self:取伤害(攻击方)

    self.xh = 消耗hp / 100
    for _, v in ipairs(目标) do
        攻击方.伤害 = math.floor(伤害比 / 100 * 攻击方.气血)
        v:被法术攻击(攻击方, self)
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少气血(math.floor(self.xh * 攻击方.气血))
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
    local 亲密 = 召唤.亲密
    if 召唤.是否怪物 and 亲密 == 0 then
        亲密 = 5000000
    end
    local 数值=math.floor((((召唤.等级*self.等级/160000)^(1/2))*(1+0.25*self.转生)+(亲密^(1/6))*self.等级/参数)*1000)/1000+0.01
    local 系数=0
    if 数值 > 0.999 then
        系数=0.999
    else
        系数=数值
    end
    local 换血=math.floor(数值*(召唤.等级*召唤.等级*0.15/(召唤.最大魔法*1+0.01)+0.2)*1000)/1000
    local 牺牲比例=math.floor(系数*10000+0.5)/100
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

local _bid = { 1310, 1311, 1312, 1317 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end


BUFF = {
    法术 = '天魔解体',
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
