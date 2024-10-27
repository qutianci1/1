-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-24 09:47:51
-- @Last Modified time  : 2023-09-22 00:42:46
local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '万佛朝宗',
    种族 = 2
}

local BUFF
function 法术:法术施放(攻击方, 目标)

end


function 法术:公式(召唤)
    local 关键参数=内丹系数调整(召唤.转生, self.转生)
    local 亲密 = 召唤.亲密
    if 召唤.是否怪物 and 亲密 == 0 then
        亲密 = 5000000
    end
    local 数值=math.floor((((召唤.等级*self.等级*0.04)^(1/2))*(1+0.25*self.转生)+(亲密^(1/6))*关键参数*self.等级/50)*1000)*0.000005
    local 几率=math.floor(数值*10000+0.5)/100
    local 程度=math.floor(数值*2*10000+0.5)/100
    return 几率, 程度
end

function 法术:法术取描述(召唤)
    local ndjl, ndcd = self:公式(召唤)
    return string.format("有#R%.2f%%#W几率将#R%.2f%%#W的伤害反震。", ndjl, ndcd)
end

function 法术:计算(召唤)
    local ndjl, ndcd = self:公式(召唤)
    local list       = { 反震率 = ndjl, 反震程度 = ndcd }
    return list
end

local _bid = { 1301, 1302, 1303, 1314 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '万佛朝宗',
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
-- 取整前=(等级+单位.等级)*0.05*(转生*0.25)+(等级+单位.等级)*0.05*(亲密度^0.05604)--2.4676--41.95
-- 取整前2=(等级+单位.等级)*0.1*(转生*0.25)+(等级+单位.等级)*0.1*(亲密度^0.056048)--2.4679--83.91
-- 单位.反震率=单位.反震率+qz(取整前*100)/100
-- 单位.反震程度=单位.反震程度+qz(取整前2*100)/100
--万佛朝宗    万佛朝宗 = "此技能有一定几率将伤害反震。",
